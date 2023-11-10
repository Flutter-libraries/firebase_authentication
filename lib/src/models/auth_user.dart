import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

/// List of available social providers
enum SocialProvider {
  /// Google provider
  @JsonValue('google.com')
  google('google.com', 'google.com'),

  /// Facebook provider
  @JsonValue('facebook.com')
  facebook('facebook.com', 'facebook.com'),

  /// Apple provider
  @JsonValue('apple.com')
  apple('apple.com', 'apple.com');

  /// Const
  const SocialProvider(this.id, this.domain);

  /// 
  final String id;

  ///
  final String domain;

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
    @Default([]) List<SocialProvider> providers,
    String? authToken,
    @Default(false) bool emailVerified,
    @Default(false) bool isAnonymous,
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
  bool get isGoogleLinked => providers.contains(SocialProvider.google);

  /// Getter to determine if the account has facebook linked
  bool get isFacebookLinked => providers.contains(SocialProvider.facebook);

  /// Getter to determine if the account has apple linked
  bool get isAppleLinked => providers.contains(SocialProvider.apple);
}
