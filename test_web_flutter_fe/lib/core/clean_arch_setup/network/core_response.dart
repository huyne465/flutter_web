import 'dart:convert';
import 'package:json_annotation/json_annotation.dart'; // Thêm import này
import 'package:test_web_flutter_fe/core/clean_arch_setup/abstraction/app_immutable.dart';

part 'core_response.g.dart';

@JsonSerializable()
class CoreResponse extends Model {
  @JsonKey(name: "success")
  final bool? success;

  @JsonKey(name: "data")
  final dynamic data;

  @JsonKey(name: "message")
  final String? message;

  const CoreResponse(this.success, this.data, this.message);

  factory CoreResponse.fromJson(Map<String, dynamic> json) =>
      _$CoreResponseFromJson(json);

  factory CoreResponse.fromJsonString(String jsonString) =>
      CoreResponse.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$CoreResponseToJson(this);

  String toJsonString() => json.encode(toJson());

  bool get isSuccess => success == true;

  String responseMessage() {
    return message ?? "";
  }
}
