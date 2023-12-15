import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zest_front_house/model/mongdb.dart';

import '../../constants/styles.dart';
import '../../model/mongodbmodel.dart';
import '../timeclockpage.dart';

class StaffPage extends StatefulWidget {
  const StaffPage({super.key});

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  MongoDatabase db = MongoDatabase(admin: true);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            title: Text('Manage Staff', style: getRobotoFontStyle(20, true, textColor)),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: textColor),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
        ),
        body: Center(
          child: SafeArea(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right:10, top: 20, bottom: 20),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    width: 220,
                    height: 500,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        futureBuilder('icon'),
                        const SizedBox(height: 12),
                        futureBuilder('name'),
                        const SizedBox(height: 8),
                        futureBuilder('role'),
                        const SizedBox(height: 8),
                        futureBuilder('clockEntries'),
                        const SizedBox(height: 10),
                        buildAddStaffButton(),
                        const SizedBox(height:15),
                        buildRemoveStaffButton(),
                        const SizedBox(height: 15),
                        buildModifyStaffButton()
                      ],
                    )
                  )
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 20, right:10, top: 20, bottom: 20),
                    child: Container(
                        padding: const EdgeInsets.all(18),
                        width: 500,
                        height: 500,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            futureBuilder('icon'),
                            const SizedBox(height: 12),
                            futureBuilder('name'),
                            const SizedBox(height: 8),
                            futureBuilder('role')
                          ],
                        )
                    )
                )
              ],
            )
          )
        ),
      )
    );
  }
}

Widget buildAddStaffButton() {
  return Container(
      width: 160,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
          onPressed: () => {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff8bc24a),
          ),
          child: Column(
            children: [
              const SizedBox(height: 5),
              const Icon(Icons.add_circle_outline, size: 20, color: Colors.white),
              const SizedBox(height: 5),
              Text('Add Staff', style: getRobotoFontStyle(18, true, Colors.white))
            ],
          )
      )
  );
}

Widget buildRemoveStaffButton() {
  return Container(
      width: 160,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
          onPressed: () => {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xfffc0303),
          ),
          child: Column(
            children: [
              const SizedBox(height: 5),
              const Icon(Icons.remove_circle_outline, size: 20, color: Colors.white),
              const SizedBox(height: 5),
              Text('Remove Staff', style: getRobotoFontStyle(18, true, Colors.white))
            ],
          )
      )
  );
}

Widget buildModifyStaffButton() {
  return Container(
      width: 160,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
          onPressed: () => {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xffff9700),
          ),
          child: Column(
            children: [
              const SizedBox(height: 5),
              const Icon(Icons.change_circle_outlined, size: 20, color: Colors.white),
              const SizedBox(height: 5),
              Text('Modify Staff', style: getRobotoFontStyle(18, true, Colors.white))
            ],
          )
      )
  );
}

Widget futureBuilder(String data) {
  return FutureBuilder<Map<String, dynamic>?>(
    future: readDataFromCache(),
    builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Text('Loading!');
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        Object? value;
        switch(data) {
          case 'name':
            value = '${MongoDbModel.fromJson(snapshot.data).firstName!} ${MongoDbModel.fromJson(snapshot.data).lastName}';
            return Text('$value', style: getRobotoFontStyle(18, true, textColor));
          case 'role':
            value = MongoDbModel.fromJson(snapshot.data).role;
            return Text('Role: $value', style: getRobotoFontStyle(15, false, textColor));
          case 'icon':
            value = MongoDbModel.fromJson(snapshot.data).icon;
            return iconPicker(value as int?);
          case 'clockEntries':
            value = MongoDbModel.fromJson(snapshot.data).weeklyClockEntries;
            break;
        }
        return Text(value.toString(),
          style: getRobotoFontStyle(18, true, textColor));
      }
    },
  );
}

Future<Map<String, dynamic>?> readDataFromCache() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? value = prefs.getString('staffInfo');
  Map<String, dynamic>? result = value != null ? jsonDecode(value): null;
  return result;
}