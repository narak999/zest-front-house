import 'package:flutter/material.dart';
import 'package:zest_front_house/constants/styles.dart';
import 'package:zest_front_house/model/mongdb.dart';
import 'package:zest_front_house/model/mongodbmodel.dart';

class MongoDbInsert extends StatefulWidget {
  const MongoDbInsert({super.key});

  @override
  State<MongoDbInsert> createState() => _MongoDbInsertState();
}

class _MongoDbInsertState extends State<MongoDbInsert> {
  MongoDatabase db = MongoDatabase(admin: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text('Insert Data: ',
                style: getRobotoFontStyle(20, true, textColor)),
            const SizedBox(height: 50),
            ElevatedButton(
                onPressed: () {
                  _connect();
                },
                child: Text(
                    'Connect', style: getRobotoFontStyle(20, true, textColor))
            ),
            const SizedBox(height: 50),
            ElevatedButton(
                onPressed: () {
                  _insertData('Taylor', 'Swift', 'Manager', true, '131398', 4);
                },
                child: Text(
                    'Insert', style: getRobotoFontStyle(20, true, textColor))
            ),
            const SizedBox(height: 50),
            ElevatedButton(
                onPressed: () {
                  _queryData();
                },
                child: Text(
                    'Query', style: getRobotoFontStyle(20, true, textColor))
            ),
            const SizedBox(height: 50),
            ElevatedButton(
                onPressed: () {
                  _disconnect();
                },
                child: Text(
                    'Disconnect', style: getRobotoFontStyle(20, true, textColor))
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _connect() async {
    db.connect();
  }

  Future<void> _disconnect() async {
    db.disconnect();
    print('Disconnected!');
  }

  Future<void> _insertData(String fName, String lName, String _role,
      bool _admin, String _passcode, int _icon) async {
    final MongoDbModel userData = MongoDbModel(
        firstName: fName,
        lastName: lName,
        role: _role,
        admin: _admin,
        passcode: _passcode,
        icon: _icon);
    String result = await db.insert(userData);
    print(result);
  }

  Future<void> _queryData() async {
    List<dynamic> result = await db.getData();
    result.forEach((dynamic str) {
      MongoDbModel model = MongoDbModel.fromJson(str);
      print('First Name: ${model.firstName}\n'
          'Last Name: ${model.lastName}\n'
          'Role: ${model.role}\n'
          'Admin: ${model.admin}\n'
          'Passcode: ${model.passcode}\n'
          'Icon: ${model.icon}\n');
    });
  }
}
