import 'package:flutter/material.dart';
import 'package:zest_front_house/constants/styles.dart';
import 'package:zest_front_house/pages/adminpages/staffpage.dart';
import 'package:zest_front_house/pages/adminpages/registerpage.dart';

import 'mainactivities.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
            ),
            actions: [
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (
                        BuildContext context) => const MainActivitiesPage()
                    )
                  );
                },
                icon: Row(
                  children: [
                      Text('Main Activities', style: getRobotoFontStyle(20, true, textColor)),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.restaurant_menu,
                        color: textColor,
                        size: 40
                      )
                  ]
                ), label: const Text(''),
              ),
            const SizedBox(width: 4)
          ]
        ),
        body: Center(
          child:  SafeArea(
            child: Container(
              width: 750,
              height: 400,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildAdminButtons('Staff', const Color(0xfffffee0), Image.asset('assets/images/icons/icons8-waitress-skin-type-3-96.png'), context),
                      buildAdminButtons('Register', const Color(0xffdefefd), Image.asset('assets/images/icons/icons8-imac-96.png'), context),
                      buildAdminButtons('Inventory', const Color(0xfffeeeff), Image.asset('assets/images/icons/icons8-box-96.png'), context),
                      buildAdminButtons('Supplier', const Color(0xffd2fed9), Image.asset('assets/images/icons/icons8-truck-96.png'), context)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildAdminButtons('Menu', const Color(0xffdefefd), Image.asset('assets/images/icons/icons8-menu-96.png'), context),
                      buildAdminButtons('Reports', const Color(0xfffeeeff), Image.asset('assets/images/icons/icons8-analytics-96.png'), context),
                      buildAdminButtons('Training', const Color(0xffd2fed9), Image.asset('assets/images/icons/icons8-training-96.png'), context),
                      buildAdminButtons('Gift Card', const Color(0xfffffee0), Image.asset('assets/images/icons/icons8-gift-card-96.png'), context)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildAdminButtons('Schedule', const Color(0xfffeeeff), Image.asset('assets/images/icons/icons8-calendar-96.png'), context),
                      buildAdminButtons('Tables', const Color(0xffd2fed9), Image.asset('assets/images/icons/icons8-table-96.png'), context),
                      buildAdminButtons('Bar', const Color(0xfffffee0), Image.asset('assets/images/icons/icons8-bar-96.png'), context),
                      buildAdminButtons('Delivery', const Color(0xffdefefd), Image.asset('assets/images/icons/icons8-motorcycle-delivery-multiple-boxes-96.png'), context)
                    ],
                  ),
                ],
              )
            )
          )
        )
      )
    );
  }

  Widget buildAdminButtons(String name, Color bgColor, Image selectedImage, BuildContext context) {
    return Container(
        width: 150,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ElevatedButton(
            onPressed: () => navigateToPages(name, context),
            style: ElevatedButton.styleFrom(
              backgroundColor: bgColor,
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  width: 50,
                  child: selectedImage,
                ),
                const SizedBox(height: 8),
                Text(name, style: getRobotoFontStyle(18, true, textColor))
              ],
            )
        )
    );
  }

  void navigateToPages(String name, BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) {
              switch(name) {
                case 'Staff':
                  return const StaffPage();
                case 'Register':
                  return const RegisterPage();
                default:
                  return const RegisterPage();
              }
            }
        )
    );
  }
}