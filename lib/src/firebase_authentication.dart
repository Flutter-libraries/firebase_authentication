import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/firebase_authentication.dart';
import 'package:firebase_authentication/src/cache.dart';
import 'package:firebase_authentication/src/models/auth_user.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Generates a cryptographically secure random nonce, to be included in a
/// credential request.
String generateNonce([int length = 32]) {
  const charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = math.Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
}

/// Returns the sha256 hash of [input] in hex notation.
String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

/// {@template sign_up_with_email_and_password_failure}
/// Thrown if during the sign up process if a failure occurs.
/// {@endtemplate}
class SignUpWithEmailAndPasswordFailure implements Exception {
  /// {@macro sign_up_with_email_and_password_failure}
  const SignUpWithEmailAndPasswordFailure([
    this.code = 'unknown',
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  /// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/createUserWithEmailAndPassword.html
  factory SignUpWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return SignUpWithEmailAndPasswordFailure(
          code,
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return SignUpWithEmailAndPasswordFailure(
          code,
          'This user has been disabled. Please contact support for help.',
        );
      case 'email-already-in-use':
        return SignUpWithEmailAndPasswordFailure(
          code,
          'An account already exists for that email.',
        );
      case 'operation-not-allowed':
        return SignUpWithEmailAndPasswordFailure(
          code,
          'Operation is not allowed.  Please contact support.',
        );
      case 'weak-password':
        return SignUpWithEmailAndPasswordFailure(
          code,
          'Please enter a stronger password.',
        );
      default:
        return SignUpWithEmailAndPasswordFailure(code);
    }
  }

  /// The associated code.
  final String code;

  /// The associated error message.
  final String message;
}

/// {@template log_in_with_email_and_password_failure}
/// Thrown during the login process if a failure occurs.
/// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/signInWithEmailAndPassword.html
/// {@endtemplate}
class LogInWithEmailAndPasswordFailure implements Exception {
  /// {@macro log_in_with_email_and_password_failure}
  const LogInWithEmailAndPasswordFailure([
    this.code = 'unknown',
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory LogInWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return LogInWithEmailAndPasswordFailure(
          code,
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return LogInWithEmailAndPasswordFailure(
          code,
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return LogInWithEmailAndPasswordFailure(
          code,
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return LogInWithEmailAndPasswordFailure(
          code,
          'Incorrect password, please try again.',
        );
      default:
        return LogInWithEmailAndPasswordFailure(code);
    }
  }

  /// The associated code.
  final String code;

  /// The associated error message.
  final String message;
}

/// {@template log_in_with_google_failure}
/// Thrown during the sign in with google process if a failure occurs.
/// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/signInWithCredential.html
/// {@endtemplate}
class LogInWithGoogleFailure implements Exception {
  /// {@macro log_in_with_google_failure}
  const LogInWithGoogleFailure([
    this.code = 'unknown',
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory LogInWithGoogleFailure.fromCode(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return LogInWithGoogleFailure(
          code,
          'Account exists with different credentials.',
        );
      case 'invalid-credential':
        return LogInWithGoogleFailure(
          code,
          'The credential received is malformed or has expired.',
        );
      case 'operation-not-allowed':
        return LogInWithGoogleFailure(
          code,
          'Operation is not allowed.  Please contact support.',
        );
      case 'user-disabled':
        return LogInWithGoogleFailure(
          code,
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return LogInWithGoogleFailure(
          code,
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return LogInWithGoogleFailure(
          code,
          'Incorrect password, please try again.',
        );
      case 'invalid-verification-code':
        return LogInWithGoogleFailure(
          code,
          'The credential verification code received is invalid.',
        );
      case 'invalid-verification-id':
        return LogInWithGoogleFailure(
          code,
          'The credential verification ID received is invalid.',
        );
      case 'invalid-phone-number':
        return LogInWithGoogleFailure(
          code,
          'The provided phone number is not valid',
        );
      default:
        return LogInWithGoogleFailure(code);
    }
  }

  /// The associated code.
  final String code;

  /// The associated error message.
  final String message;
}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}

/// {@template authentication_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class AuthenticationRepository {
  /// {@macro authentication_repository}
  AuthenticationRepository({
    CacheClient? cache,
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    FacebookAuth? facebookAuth,
  })  : _cache = cache ?? CacheClient(),
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard(),
        _facebookAuth = facebookAuth ?? FacebookAuth.instance;

  final CacheClient _cache;
  final FirebaseAuth _firebaseAuth;

  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;

  /// Used for phone auth on web
  late ConfirmationResult _confirmationResult;

  /// Whether or not the current environment is web
  /// Should only be overriden for testing purposes. Otherwise,
  /// defaults to [kIsWeb]
  @visibleForTesting
  bool isWeb = kIsWeb;

  /// User cache key.
  /// Should only be used for testing purposes.
  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';

  /// Stream of [AuthUser] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [AuthUser.empty] if the user is not authenticated.
  Stream<AuthUser> get user {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      final authToken = await firebaseUser?.getIdToken();
      final user = firebaseUser == null
          ? AuthUser.empty
          : firebaseUser.toUser.copyWith(authToken: authToken);
      _cache.write(key: userCacheKey, value: user);
      return user;
    });
  }

  /// Stream of [AuthUser] which will emit the current user when
  /// the authentication state changes.
  /// This stream will also emit when the user is signed out.
  ///
  /// Emits [AuthUser.empty] if the user is not authenticated.
  Stream<AuthUser> get userChanges async* {
    _firebaseAuth.userChanges().asyncMap((firebaseUser) async* {
      final authToken = await firebaseUser?.getIdToken();
      final user = firebaseUser == null
          ? AuthUser.empty
          : firebaseUser.toUser.copyWith(authToken: authToken);
      _cache.write(key: userCacheKey, value: user);
      yield user;
    });
  }

  /// Returns the current cached user.
  /// Defaults to [AuthUser.empty] if there is no cached user.
  AuthUser get currentUser {
    return _cache.read<AuthUser>(key: userCacheKey) ?? AuthUser.empty;
  }

  /// Anom sign in
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<AuthUser?> signInAnonymously() async {
    try {
      final userCredentials = await _firebaseAuth.signInAnonymously();
      return userCredentials.user == null
          ? AuthUser.empty
          : userCredentials.user!.toUser;
    } on FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  /// Creates a new user with the provided [email] and [password].
  ///
  /// Throws a [SignUpWithEmailAndPasswordFailure] if an exception occurs.
  Future<String> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credentials = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credentials.user!.uid;
    } on FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  ///
  Future<void> sendResetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(
        email: email,
      );
    } on FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  /// Link provider to user
  Future<void> linkWithProvider(SocialProvider provider) async {
    try {
      if (kIsWeb) {
        await _linkWithPopup(provider);
      } else if (provider == SocialProvider.google) {
        await _linkWithGoogle();
      } else if (provider == SocialProvider.facebook) {
        await _linkWithFacebook();
      } else {
        throw const LogInWithEmailAndPasswordFailure();
      }
    } on FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (e) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  /// Link provider to user
  Future<void> _linkWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _firebaseAuth.currentUser?.linkWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  /// Link provider to user
  Future<void> _linkWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final loginResult = await _facebookAuth.login();

      if (loginResult.accessToken != null) {
        // Create a credential from the access token
        final facebookAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);

        await _firebaseAuth.currentUser
            ?.linkWithCredential(facebookAuthCredential);
      }
    } on FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  Future<void> _linkWithPopup(SocialProvider provider) async {
    await _firebaseAuth.currentUser?.linkWithPopup(
      provider == SocialProvider.facebook
          ? FacebookAuthProvider()
          : GoogleAuthProvider(),
    );
  }

  /// Starts the Sign In with Google Flow.
  ///
  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  Future<AuthUser?> logInWithGoogle() async {
    try {
      late final AuthCredential credential;
      if (isWeb) {
        final googleProvider = GoogleAuthProvider();

        final credential = await _firebaseAuth.signInWithPopup(
          googleProvider,
        );
        if (credential.credential != null) {
          final userCredentials =
              await _firebaseAuth.signInWithCredential(credential.credential!);
          return userCredentials.user == null
              ? AuthUser.empty
              : userCredentials.user!.toUser;
        }
      } else {
        final googleUser = await _googleSignIn.signIn();
        final googleAuth = await googleUser!.authentication;
        credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final userCredentials =
            await _firebaseAuth.signInWithCredential(credential);
        return userCredentials.user == null
            ? AuthUser.empty
            : userCredentials.user!.toUser;
      }

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code != 'popup-closed-by-user') {
        throw LogInWithGoogleFailure.fromCode(e.code);
      }
    } catch (_) {
      throw const LogInWithGoogleFailure();
    }
  }

  /// Starts the Sign In with Apple Flow.
  ///
  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  Future<AuthUser?> logInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will
      // fail.
      final userCredentials =
          await _firebaseAuth.signInWithCredential(oauthCredential);
      return userCredentials.user == null
          ? AuthUser.empty
          : userCredentials.user!.toUser;
    } on FirebaseAuthException catch (e) {
      throw LogInWithGoogleFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithGoogleFailure();
    }
  }

  /// Starts the Sign In with Apple Flow.
  ///
  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  Future<void> logInWithAppleWeb() async {
    try {
      // Create and configure an OAuthProvider for Sign In with Apple.
      final provider = OAuthProvider('apple.com')
        ..addScope('email')
        ..addScope('name');

      // Sign in the user with Firebase.
      await _firebaseAuth.signInWithPopup(provider);
    } on FirebaseAuthException catch (e) {
      throw LogInWithGoogleFailure.fromCode(e.code);
    } catch (e) {
      throw const LogInWithGoogleFailure();
    }
  }

  /// Starts the Sign In with Facebook Flow.
  ///
  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  Future<AuthUser?> logInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final loginResult = await _facebookAuth.login();

      if (loginResult.status == LoginStatus.success) {
        // Create a credential from the access token
        final OAuthCredential credential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);
        // Once signed in, return the UserCredential
        final userCredentials =
            await FirebaseAuth.instance.signInWithCredential(credential);
        return userCredentials.user == null
            ? AuthUser.empty
            : userCredentials.user!.toUser;
      }

      return null;
    } on FirebaseAuthException catch (e) {
      throw LogInWithGoogleFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithGoogleFailure();
    }
  }

  /// Starts the Sign In with Facebook Flow.
  ///
  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  Future<void> logInWithFacebookWeb() async {
    try {
      // Create a new provider
      final facebookProvider = FacebookAuthProvider()
        ..addScope('email')
        ..setCustomParameters(<String, dynamic>{
          'display': 'popup',
        });

      // Once signed in, return the UserCredential
      await _firebaseAuth.signInWithPopup(facebookProvider);
    } on FirebaseAuthException catch (e) {
      throw LogInWithGoogleFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithGoogleFailure();
    }
  }

  /// Starts the Sign In with Phone Flow.
  ///
  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  Future<void> logInWithPhone(String phoneNumber, Function() onCodeSent) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // ANDROID ONLY!

          // Sign the user in (or link) with the auto-generated credential
          await _firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          throw LogInWithGoogleFailure.fromCode(e.code);
        },
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId = verificationId;
          onCodeSent();
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      throw LogInWithGoogleFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithGoogleFailure();
    }
  }

  /// Store verification id
  late String verificationId;

  /// Confirme phone with code
  Future<void> confirmPhoneCode(String code) async {
    // Create a PhoneAuthCredential with the code
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: code,
    );

    // Sign the user in (or link) with the credential
    await _firebaseAuth.signInWithCredential(credential);
  }

  /// Starts the Sign In with Phone Flow on Web platform
  ///
  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  Future<void> logInWithPhoneWeb(String phoneNumber) async {
    final confirmationResult = await _firebaseAuth.signInWithPhoneNumber(
      phoneNumber,
      // RecaptchaVerifier(
      //   auth: _firebaseAuthPlatform,
      //   container: 'recaptcha',
      //   size: RecaptchaVerifierSize.compact,
      //   theme: RecaptchaVerifierTheme.dark,
      //   onSuccess: () => log('reCAPTCHA Completed!'),
      //   onError: (FirebaseAuthException error) =>
      //       log(error.message ?? 'Unknown Error'),
      //   onExpired: () => log('reCAPTCHA Expired!'),
      // )
    );

    _confirmationResult = confirmationResult;
  }

  /// Confirm phone code on Web platform
  ///
  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  Future<void> confirmPhoneCodeWeb(String verificationCode) async {
    await _confirmationResult.confirm(verificationCode);
  }

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  /// Signs out the current user which will emit
  /// [AuthUser.empty] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      await Future.wait([
        if (_firebaseAuth.currentUser != null) _firebaseAuth.signOut(),
        if (_googleSignIn.currentUser != null) _googleSignIn.signOut(),
      ]);
    } catch (_) {
      throw LogOutFailure();
    }
  }

  /// Unlink provider from user
  Future<void> unlinkProvider(SocialProvider provider) async {
    try {
      await _firebaseAuth.currentUser?.unlink(provider.domain);
    } on FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  /// Send email verification
  Future<void> sendEmailVerification() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }
}

extension on User {
  AuthUser get toUser {
    final providers = <SocialProvider>[];

    var finaldisplayName = displayName;

    if (providerData.isNotEmpty) {
      // Find out a valid display name in providers when has not displayName
      if (displayName == null || displayName!.isEmpty) {
        for (final data in providerData) {
          if (data.displayName != null && data.displayName!.isNotEmpty) {
            finaldisplayName = data.displayName;
          }
        }
      }
      for (final userInfo in providerData) {
        final socialProvider =
            SocialProvider.values.where((v) => v.id == userInfo.providerId);
        if (socialProvider.isNotEmpty) providers.add(socialProvider.first);
      }
    }
    return AuthUser(
      id: uid,
      email: email,
      phone: phoneNumber,
      name: finaldisplayName,
      // providers: providers,
      photo: photoURL,
      emailVerified: emailVerified,
      isAnonymous: isAnonymous,
    );
  }
}
