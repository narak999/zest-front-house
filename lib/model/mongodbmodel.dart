import 'dart:convert';

MongoDbModel mongoDbModelFromJson(String str) => MongoDbModel.fromJson(json.decode(str));

String mongoDbModelToJson(MongoDbModel data) => json.encode(data.toJson());

class MongoDbModel {

  MongoDbModel({
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.admin,
    required this.passcode,
    required this.icon,
    required this.phoneNumber,
    required this.dailyClockEntries,
    required this.weeklyClockEntries
  });

  factory MongoDbModel.fromJson(Map<String, dynamic>? json) => MongoDbModel(
    firstName: json?['firstName'],
    lastName: json?['lastName'],
    role: json?['role'],
    admin: json?['admin'],
    passcode: json?['passcode'],
    icon: json?['icon'],
    phoneNumber: json?['phoneNumber'],
    dailyClockEntries: json?['dailyClockEntries'],
    weeklyClockEntries: json?['weeklyClockEntries']
  );
  String? firstName;
  String? lastName;
  String? role;
  bool? admin;
  String? passcode;
  int? icon;
  String? phoneNumber;
  List<dynamic>? dailyClockEntries;
  List<dynamic>? weeklyClockEntries;

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'role': role,
    'admin': admin,
    'passcode': passcode,
    'icon': icon,
    'phoneNumber': phoneNumber,
    'dailyClockEntries': dailyClockEntries,
    'weeklyClockEntries': weeklyClockEntries
  };
}
