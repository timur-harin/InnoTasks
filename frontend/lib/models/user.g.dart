// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      email: json['email'] as String,
      password: json['password'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'runtimeType': instance.$type,
    };

_$UserChangePasswordImpl _$$UserChangePasswordImplFromJson(
        Map<String, dynamic> json) =>
    _$UserChangePasswordImpl(
      email: json['email'] as String,
      password: json['password'] as String,
      new_password: json['new_password'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$UserChangePasswordImplToJson(
        _$UserChangePasswordImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'new_password': instance.new_password,
      'runtimeType': instance.$type,
    };
