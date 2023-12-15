import 'package:flutter/material.dart';
import 'package:zest_front_house/model/mongdb.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  MongoDatabase db = MongoDatabase(admin: true);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Text('Hello')
      ),
    );
  }
}