// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AuthUser _$$_AuthUserFromJson(Map<String, dynamic> json) => _$_AuthUser(
      id: json['id'] as String? ?? '',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      name: json['name'] as String?,
      photo: json['photo'] as String?,
      providerId: json['providerId'] as String?,
      authToken: json['authToken'] as String?,
      emailVerified: json['emailVerified'] as bool? ?? false,
      isAnonymous: json['isAnonymous'] as bool? ?? false,
    );

Map<String, dynamic> _$$_AuthUserToJson(_$_AuthUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'phone': instance.phone,
      'name': instance.name,
      'photo': instance.photo,
      'providerId': instance.providerId,
      'authToken': instance.authToken,
      'emailVerified': instance.emailVerified,
      'isAnonymous': instance.isAnonymous,
    };
