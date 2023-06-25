import 'package:flutter/material.dart';
import 'package:zest_front_house/constants/styles.dart';

class ModeSelectorPage extends StatelessWidget {
  const ModeSelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mode Selector',
      home: Scaffold(
        appBar: AppBar(
            title: Text('Mode Selector', style: getRobotoFontStyle(20, true, textColor)),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: textColor),
              onPressed: () {
                Navigator.pop(context);
              },
            )
        ),
        body: const Center(
          child: Text(
            'Something here',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}