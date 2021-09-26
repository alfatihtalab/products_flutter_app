// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.id,
  });

  String id;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
