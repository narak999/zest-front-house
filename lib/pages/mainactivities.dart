import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zest_front_house/constants/styles.dart';
import 'package:zest_front_house/model/mongodbmodel.dart';

class MainActivitiesPage extends StatelessWidget {

  const MainActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Main Activities',
      home: Scaffold(
        appBar: AppBar(
            title: Text('Main Activities', style: getRobotoFontStyle(20, true, textColor)),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: textColor),
              onPressed: () {
                Navigator.pop(context);
              },
            )
        ),
        body: Center(
          child: FutureBuilder<Map<String, dynamic>?>(
            future: readDataFromCache(),
            builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Text('Passcode: ${MongoDbModel.fromJson(snapshot.data).lastName}',
                style: getRobotoFontStyle(20, true, textColor),);
              }
            },
          )
        ),
      ),
    );
  }

  Future<Map<String, dynamic>?> readDataFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString('staffInfo');
    Map<String, dynamic>? result = value != null ? jsonDecode(value): null;
    return result;
  }
}