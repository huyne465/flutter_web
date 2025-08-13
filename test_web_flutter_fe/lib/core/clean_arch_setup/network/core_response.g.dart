// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'core_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoreResponse _$CoreResponseFromJson(Map<String, dynamic> json) => CoreResponse(
  json['success'] as bool?,
  json['data'],
  json['message'] as String?,
);

Map<String, dynamic> _$CoreResponseToJson(CoreResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'message': instance.message,
    };
