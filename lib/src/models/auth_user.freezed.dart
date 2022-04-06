// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'auth_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AuthUser _$AuthUserFromJson(Map<String, dynamic> json) {
  return _AuthUser.fromJson(json);
}

/// @nodoc
class _$AuthUserTearOff {
  const _$AuthUserTearOff();

  _AuthUser call(
      {String id = '',
      String? email,
      String? phone,
      String? name,
      String? photo,
      String? providerId}) {
    return _AuthUser(
      id: id,
      email: email,
      phone: phone,
      name: name,
      photo: photo,
      providerId: providerId,
    );
  }

  AuthUser fromJson(Map<String, Object?> json) {
    return AuthUser.fromJson(json);
  }
}

/// @nodoc
const $AuthUser = _$AuthUserTearOff();

/// @nodoc
mixin _$AuthUser {
  String get id => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get photo => throw _privateConstructorUsedError;
  String? get providerId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuthUserCopyWith<AuthUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthUserCopyWith<$Res> {
  factory $AuthUserCopyWith(AuthUser value, $Res Function(AuthUser) then) =
      _$AuthUserCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String? email,
      String? phone,
      String? name,
      String? photo,
      String? providerId});
}

/// @nodoc
class _$AuthUserCopyWithImpl<$Res> implements $AuthUserCopyWith<$Res> {
  _$AuthUserCopyWithImpl(this._value, this._then);

  final AuthUser _value;
  // ignore: unused_field
  final $Res Function(AuthUser) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? name = freezed,
    Object? photo = freezed,
    Object? providerId = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: phone == freezed
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      photo: photo == freezed
          ? _value.photo
          : photo // ignore: cast_nullable_to_non_nullable
              as String?,
      providerId: providerId == freezed
          ? _value.providerId
          : providerId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$AuthUserCopyWith<$Res> implements $AuthUserCopyWith<$Res> {
  factory _$AuthUserCopyWith(_AuthUser value, $Res Function(_AuthUser) then) =
      __$AuthUserCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String? email,
      String? phone,
      String? name,
      String? photo,
      String? providerId});
}

/// @nodoc
class __$AuthUserCopyWithImpl<$Res> extends _$AuthUserCopyWithImpl<$Res>
    implements _$AuthUserCopyWith<$Res> {
  __$AuthUserCopyWithImpl(_AuthUser _value, $Res Function(_AuthUser) _then)
      : super(_value, (v) => _then(v as _AuthUser));

  @override
  _AuthUser get _value => super._value as _AuthUser;

  @override
  $Res call({
    Object? id = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? name = freezed,
    Object? photo = freezed,
    Object? providerId = freezed,
  }) {
    return _then(_AuthUser(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: phone == freezed
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      photo: photo == freezed
          ? _value.photo
          : photo // ignore: cast_nullable_to_non_nullable
              as String?,
      providerId: providerId == freezed
          ? _value.providerId
          : providerId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_AuthUser extends _AuthUser {
  const _$_AuthUser(
      {this.id = '',
      this.email,
      this.phone,
      this.name,
      this.photo,
      this.providerId})
      : super._();

  factory _$_AuthUser.fromJson(Map<String, dynamic> json) =>
      _$$_AuthUserFromJson(json);

  @JsonKey()
  @override
  final String id;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? name;
  @override
  final String? photo;
  @override
  final String? providerId;

  @override
  String toString() {
    return 'AuthUser(id: $id, email: $email, phone: $phone, name: $name, photo: $photo, providerId: $providerId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AuthUser &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.email, email) &&
            const DeepCollectionEquality().equals(other.phone, phone) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.photo, photo) &&
            const DeepCollectionEquality()
                .equals(other.providerId, providerId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(email),
      const DeepCollectionEquality().hash(phone),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(photo),
      const DeepCollectionEquality().hash(providerId));

  @JsonKey(ignore: true)
  @override
  _$AuthUserCopyWith<_AuthUser> get copyWith =>
      __$AuthUserCopyWithImpl<_AuthUser>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AuthUserToJson(this);
  }
}

abstract class _AuthUser extends AuthUser {
  const factory _AuthUser(
      {String id,
      String? email,
      String? phone,
      String? name,
      String? photo,
      String? providerId}) = _$_AuthUser;
  const _AuthUser._() : super._();

  factory _AuthUser.fromJson(Map<String, dynamic> json) = _$_AuthUser.fromJson;

  @override
  String get id;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  String? get name;
  @override
  String? get photo;
  @override
  String? get providerId;
  @override
  @JsonKey(ignore: true)
  _$AuthUserCopyWith<_AuthUser> get copyWith =>
      throw _privateConstructorUsedError;
}
