// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordModel _$RecordModelFromJson(Map<String, dynamic> json) => RecordModel(
      name: json['name'] as String?,
      score: json['score'] as int?,
      level: json['level'] as int?,
    );

Map<String, dynamic> _$RecordModelToJson(RecordModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'score': instance.score,
      'level': instance.level,
    };
