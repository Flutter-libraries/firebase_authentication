import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

/// {@template user}
/// AuthUser model
///
/// [AuthUser.empty] represents an unauthenticated user.
/// {@endtemplate}
@freezed
class AuthUser with _$AuthUser {
  /// {@macro user}
  const factory AuthUser(
      {@Default('') String id,
      String? email,
      String? phone,
      String? name,
      String? photo,
      String? providerId}) = _AuthUser;

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
}
