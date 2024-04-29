// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      email: json['email'] as String,
      password: json['password'] as String,
      id: (json['id'] as num).toInt(),
      token: json['token'] as String,
      lastTokenUpdate: json['lastTokenUpdate'] == null
          ? null
          : DateTime.parse(json['lastTokenUpdate'] as String),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'id': instance.id,
      'token': instance.token,
      'lastTokenUpdate': instance.lastTokenUpdate?.toIso8601String(),
    };
