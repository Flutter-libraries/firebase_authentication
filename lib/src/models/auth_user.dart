import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

enum SocialProvider {
  /// Google provider
  google('google', 'google.com'),

  /// Facebook provider
  facebook('facebook', 'facebook.com'),

  /// Apple provider
  apple('apple', 'apple.com');

  final String id;
  final String domain;
  const SocialProvider(this.id, this.domain);
}

/// {@template user}
/// AuthUser model
///
/// [AuthUser.empty] represents an unauthenticated user.
/// {@endtemplate}
@freezed
class AuthUser with _$AuthUser {
  /// {@macro user}
  const factory AuthUser({
    @Default('') String id,
    String? email,
    String? phone,
    String? name,
    String? photo,
    String? providerId,
    @Default(false) bool emailVerified,
  }) = _AuthUser;

  const AuthUser._();

  ///
  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);

  /// Empty user which represents an unauthenticated user.
  static const empty = AuthUser();

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == AuthUser.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != AuthUser.empty;

  /// Getter to determine if the account has google linked
  bool get isGoogleLinked =>
      providerId ==
      SocialProvider.google.id; // providers.contains(SocialProvider.google);

  /// Getter to determine if the account has facebook linked
  bool get isFacebookLinked =>
      providerId ==
      SocialProvider
          .facebook.id; // providers.contains(SocialProvider.facebook);
}
