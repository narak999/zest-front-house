import 'package:flutter/material.dart';
import 'package:zest_front_house/constants/styles.dart';
import 'package:zest_front_house/model/mongodbmodel.dart';

class MainActivitiesPage extends StatelessWidget {

  const MainActivitiesPage({super.key, required this.staffInfo});
  final MongoDbModel staffInfo;

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
          child: Text(
            'Hello ${staffInfo.firstName} ${staffInfo.lastName}',
            style: getRobotoFontStyle(20, true, textColor),
          ),
        ),
      ),
    );
  }
}