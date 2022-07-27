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
      providers: (json['providers'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$SocialProviderEnumMap, e))
              .toList() ??
          const <SocialProvider>[],
    );

Map<String, dynamic> _$$_AuthUserToJson(_$_AuthUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'phone': instance.phone,
      'name': instance.name,
      'photo': instance.photo,
      'providerId': instance.providerId,
      'providers':
          instance.providers.map((e) => _$SocialProviderEnumMap[e]!).toList(),
    };

const _$SocialProviderEnumMap = {
  SocialProvider.google: 'google',
  SocialProvider.facebook: 'facebook',
};
