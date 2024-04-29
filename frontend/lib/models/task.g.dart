// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskImpl _$$TaskImplFromJson(Map<String, dynamic> json) => _$TaskImpl(
      title: json['title'] as String,
      completed: json['completed'] as bool,
      description: json['description'] as String?,
      deadline: json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
      id: (json['id'] as num?)?.toInt(),
      ownerId: (json['ownerId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$TaskImplToJson(_$TaskImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'completed': instance.completed,
      'description': instance.description,
      'deadline': instance.deadline?.toIso8601String(),
      'id': instance.id,
      'ownerId': instance.ownerId,
    };
