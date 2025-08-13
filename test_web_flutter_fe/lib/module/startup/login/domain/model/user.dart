// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:test_web_flutter_fe/core/clean_arch_setup/abstraction/app_immutable.dart';

part 'user.g.dart';

@JsonSerializable()
@CopyWith()
class User extends Model {
  @JsonKey(name: "userID")
  final String? userID;

  @JsonKey(name: "userName")
  final String? userName;

  @JsonKey(name: "password")
  final String? password;

  @JsonKey(name: "email")
  final String? email;

  @JsonKey(name: "displayName")
  final String? displayName;

  @JsonKey(name: "fullName")
  final String? fullName;

  @JsonKey(name: "isActive")
  final bool? isActive;

  const User({
    this.userID,
    this.userName,
    this.password,
    this.email,
    this.displayName,
    this.fullName,
    this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.fromJsonString(String jsonString) =>
      User.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  String toJsonString() => json.encode(toJson());
}
