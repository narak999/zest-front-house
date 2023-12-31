import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zest_front_house/constants/styles.dart';
import 'package:zest_front_house/pages/adminpage.dart';
import 'package:zest_front_house/pages/mainactivities.dart';
import 'package:zest_front_house/pages/timeclockpage.dart';

import '../model/mongdb.dart';
import '../model/mongodbmodel.dart';

class CustomNumberPad extends StatefulWidget {

  const CustomNumberPad({super.key, required this.title});
  final String title;

  @override
  _CustomNumberPadState createState() => _CustomNumberPadState();
}

class _CustomNumberPadState extends State<CustomNumberPad> {
  String _pinNumber = '';
  int _dotCount = 0;
  bool _isLoadingGo = false;
  bool _isLoadingTC = false;

  void updateDisplay(String value) {
    setState(() {
      if (_pinNumber.length < 6) {
        _pinNumber += value;
        _dotCount++;
      }
    });
  }

  void clearDisplay() {
    setState(() {
      if (_pinNumber != '') {
        _pinNumber = _pinNumber.substring(0, _pinNumber.length - 1);
        _dotCount--;
      }
    });
  }

  Future<void> verifyPIN(String pinNumber, bool goOrTC) async {
    setState(() => goOrTC ? _isLoadingGo = true : _isLoadingTC = true);
    MongoDatabase db = MongoDatabase(admin: true);
    await db.connect();

    List<dynamic> result = await db.getData(mongo.where.eq('passcode', pinNumber));
    if (result.isEmpty) {
      setState(() => goOrTC ? _isLoadingGo = false : _isLoadingTC = false);
      //clearAllDisplay();
      throw Error();
    }

    String value = jsonEncode(result[0]);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('staffInfo', value);

    setState(() {
      goOrTC ? _isLoadingGo = false : _isLoadingTC = false;
      Navigator.push(
          context,
          PageTransition(
              child: goOrTC ? const MainActivitiesPage() : TimeClockPage(restaurantName: widget.title),
              type: PageTransitionType.topToBottom
          )
      ).then((value) {
        clearAllDisplay();
      }
      );
    });
  }

  void clearAllDisplay() {
    setState(() {
      _pinNumber = '';
      _dotCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AbsorbPointer(
        absorbing: _isLoadingGo || _isLoadingTC,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(widget.title, style: getRobotoFontStyle(20, true, textColor)),
              actions: [
                TextButton.icon(
                    onPressed: () => showCustomDialog(context, () {
                      if (!mounted) return;
                      Navigator.of(context).pop();
                    }),
                    icon: Row(
                        children: [
                          Text('Admin', style: getRobotoFontStyle(20, true, textColor)),
                          const SizedBox(width: 4),
                          Icon(
                          Icons.admin_panel_settings_sharp,
                          color: textColor,
                          size: 40
                          )
                        ]
                    ), label: const Text(''),
                ),
                const SizedBox(width: 4)
              ],
            ),
          body: Center (
            child: SafeArea(
              child: Container(
                width: 555,
                height: 400,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                    const SizedBox(width: 20),
                    Container(
                      width: 340,
                      height: 370,
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Enter your PIN number:',
                              style: getRobotoFontStyle(20, true, textColor),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:  List.generate(6,
                                    (int index) => Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 8),
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: index < _dotCount ? Colors.black87 : Colors.transparent,
                                    border: Border.all(color: Colors.black87),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Divider(thickness: 3, height: 12, color: Color(0xff076c87)),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildNumberButton('1'),
                                _buildNumberButton('2'),
                                _buildNumberButton('3')
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildNumberButton('4'),
                                _buildNumberButton('5'),
                                _buildNumberButton('6')
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildNumberButton('7'),
                                _buildNumberButton('8'),
                                _buildNumberButton('9'),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildClearAllButton(),
                                _buildNumberButton('0'),
                                _buildClearButton()
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        const SizedBox(height: 215),
                        _buildGoButton(),
                        _buildTimeClockButton()
                        ]
                    )
                  ]
                )
              )
            )
          )
        )
      )
    );
  }

  Widget _buildNumberButton(String number) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      onPressed: () {
        updateDisplay(number);
      },
      child: Text(
        number,
        style: TextStyle(color: textColor ,fontSize: 24),
      ),
    );
  }

  Widget _buildClearButton() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      onPressed: () {
        clearDisplay();
      },
      child: Icon(color: textColor, Icons.backspace),
    );
  }

  Widget _buildClearAllButton() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      onPressed: () {
        clearAllDisplay();
      },
      child: Icon(color: textColor, Icons.close_rounded, size: 26)
    );
  }

  Widget _buildGoButton() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child:
        ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff8bc24a)),
            ),
            onPressed: () async {
              if (_pinNumber.length != 6) {
                showWrongPINPopup(context);
              } else {
                if (!_isLoadingGo) {
                  try {
                    await verifyPIN(_pinNumber, true);
                  } catch (error) {
                    showWrongPINPopup(context);
                    setState(() => _isLoadingGo = false);
                  }
                }
              }
            },
            child: _isLoadingGo ? const Column(
                children: [
                  SizedBox(height: 5),
                  SizedBox(
                      height: 28,
                      width: 28,
                      child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3
                      )
                  ),
                  SizedBox(height: 3),
                  Text('       Go       ', style: TextStyle(color: Colors.white, fontSize: 20)),
                  SizedBox(height: 5)
                ])
                : const Column(
                children: [
                  SizedBox(height: 5),
                  Icon(size: 28, Icons.subdirectory_arrow_right_outlined, color: Colors.white),
                  SizedBox(height: 3),
                  Text('       Go       ', style: TextStyle(color: Colors.white, fontSize: 20)),
                  SizedBox(height: 5)
                ]
            )
        )
    );
  }

  Widget _buildTimeClockButton() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffff9700)),
            ),
            onPressed: () async {
              if (_pinNumber.length != 6) {
                showWrongPINPopup(context);
              } else {
                if (!_isLoadingTC) {
                  try {
                    await verifyPIN(_pinNumber, false);
                  } catch (error) {
                    showWrongPINPopup(context);
                    setState(() => _isLoadingTC = false);
                  }
                }
              }
            },
            child: _isLoadingTC ? const Column(
                children: [
                  SizedBox(height: 5),
                  SizedBox(
                    height: 28,
                    width: 28,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3
                    )
                  ),
                  SizedBox(height: 3),
                  Text('Time Clock', style: TextStyle(color: Colors.white, fontSize: 18)),
                  SizedBox(height: 5)
                ])
                : const Column(
                children: [
                  SizedBox(height: 5),
                  Icon(size: 28, Icons.hourglass_bottom_outlined, color: Colors.white),
                  SizedBox(height: 3),
                  Text('Time Clock', style: TextStyle(color: Colors.white, fontSize: 18)),
                  SizedBox(height: 5)
                ]
            )
        )
    );
  }

  void showWrongPINPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {

        return AlertDialog(
          title: Row (
              children: [
                const Icon(Icons.warning, size: 25, color: Colors.red),
                const SizedBox(width: 5),
                _pinNumber.length != 6 ? Text('Enter PIN Number', style: getRobotoFontStyle(20, true, textColor))
                : Text('Wrong PIN Number', style: getRobotoFontStyle(20, true, textColor))
              ]
          ),
          content: Text('Please try again!', style: TextStyle(color: textColor, fontSize: 18)),
          actions: [
            TextButton(
              onPressed: () {Navigator.of(context).pop();},
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  void showCustomDialog(BuildContext context, VoidCallback onSuccess) {
    TextEditingController passcodeController = TextEditingController();
    bool isLoadingAdmin = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: Text('Enter Admin Password:', style: getRobotoFontStyle(20, true, textColor)),
              content: isLoadingAdmin
                      ? const Padding(
                        padding: EdgeInsets.only(left: 100, right: 100, top: 14, bottom: 14),
                        child: CircularProgressIndicator()
                      )
                      : TextField(
                          keyboardType: TextInputType.text,
                          controller: passcodeController,
                          obscureText: true,
                        ),
              actions: [
                TextButton(
                    onPressed: isLoadingAdmin ? null : () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ElevatedButton(
                  onPressed: isLoadingAdmin
                      ? null
                      : () async {
                    setState(() => isLoadingAdmin = true);

                    String enteredPasscode = passcodeController.text.trim();
                    List<dynamic> result = <dynamic>[];
                    try {
                      MongoDatabase db = MongoDatabase(admin: true);
                      await db.connect();

                      result = await db.getData(mongo.where.eq(
                          'passcode', enteredPasscode));
                      await db.disconnect();

                      if (result.isEmpty) {
                        setState(() => isLoadingAdmin = false);
                        wrongPasscodeAlertDialog();
                      }
                      MongoDbModel model = MongoDbModel.fromJson(result[0]);
                      String value = jsonEncode(result[0]);
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setString('staffInfo', value);
                      onSuccess.call();

                      if (context.mounted) {
                        if (enteredPasscode == model.passcode && model.admin == true) {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: const AdminPage(),
                                  type: PageTransitionType.topToBottom
                              )
                          );
                        } else {
                          wrongPasscodeAlertDialog();
                          setState(() {
                            isLoadingAdmin = false;
                          });
                        }
                      }
                    } catch (error) {
                      wrongPasscodeAlertDialog();
                      setState(() {
                        isLoadingAdmin = false;
                      });
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void wrongPasscodeAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Wrong Passcode', style: getRobotoFontStyle(20, true, textColor)),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Try Again'),
            ),
          ],
        );
      },
    );
  }

}
