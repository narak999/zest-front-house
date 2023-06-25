import 'package:flutter/material.dart';
import 'package:zest_front_house/constants/styles.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Page',
      home: Scaffold(
        appBar: AppBar(
            title: Text('Admin Page', style: getRobotoFontStyle(20, true, textColor)),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: textColor),
              onPressed: () {
                Navigator.pop(context);
              },
            )
        ),
        body: const Center(
          child:  Text('Admin Page'),
        ),
      ),
    );
  }



}