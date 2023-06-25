// To parse this JSON data, do
//
//     final mongoDbModel = mongoDbModelFromJson(jsonString);

import 'dart:convert';

MongoDbModel mongoDbModelFromJson(String str) => MongoDbModel.fromJson(json.decode(str));

String mongoDbModelToJson(MongoDbModel data) => json.encode(data.toJson());

class MongoDbModel {

  MongoDbModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });

  factory MongoDbModel.fromJson(Map<String, dynamic> json) => MongoDbModel(
    id: json['__id'],
    firstName: json['firstName'],
    lastName: json['lastName'],
    phoneNumber: json['phoneNumber'],
  );
  int id;
  String firstName;
  String lastName;
  String phoneNumber;

  Map<String, dynamic> toJson() => {
    '__id': id,
    'firstName': firstName,
    'lastName': lastName,
    'phoneNumber': phoneNumber,
  };
}
