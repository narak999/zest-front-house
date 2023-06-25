import 'package:flutter/material.dart';
import 'package:zest_front_house/constants/styles.dart';

class MongoDbInsert extends StatefulWidget {
  const MongoDbInsert({super.key});

  @override
  State<MongoDbInsert> createState() => _MongoDbInsertState();
}

class _MongoDbInsertState extends State<MongoDbInsert> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text('Insert Data: ', style: getRobotoFontStyle(20, true, textColor))
          ],
        ),
      ),
    );
  }
}
