import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zest_front_house/constants/styles.dart';
import 'package:zest_front_house/pages/adminpage.dart';
import 'package:zest_front_house/pages/mainactivities.dart';
import 'package:zest_front_house/pages/timeclockpage.dart';

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

  void verifyPINGo() {
    setState(() => _isLoadingGo = true);
    Future.delayed(
      const Duration(seconds: 3),
          () => setState(() {
            _isLoadingGo = false;
            Navigator.push(
              context,
              PageTransition(
                  child: const ModeSelectorPage(),
                  type: PageTransitionType.topToBottom
              )
            ).then((value) {
              clearAllDisplay();
            }
            );
          }),
    );
  }

  void verifyPINTC() {
    setState(() => _isLoadingTC = true);
    Future.delayed(
      const Duration(seconds: 3),
          () => setState(() {
        _isLoadingTC = false;
        Navigator.push(
          context,
          PageTransition(
              child: TimeClockPage(employeeName: 'Sreyhuong', restaurantName: widget.title),
              type: PageTransitionType.bottomToTop
          )
        ).then((value) {
          clearAllDisplay();
        }
        );
      }),
    );
  }

  void clearAllDisplay() {
    setState(() {
      _pinNumber = '';
      _dotCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
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
                      const SizedBox(height: 230),
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
    );
  }

  Widget _buildNumberButton(String number) {
    return ElevatedButton(
      onPressed: () {
        updateDisplay(number);
      },
      child: Text(
        number,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildClearButton() {
    return ElevatedButton(
      onPressed: () {
        clearDisplay();
      },
      child: const Icon(Icons.backspace),
    );
  }

  Widget _buildClearAllButton() {
    return ElevatedButton(
      onPressed: () {
        clearAllDisplay();
      },
      child: const Icon(Icons.close_rounded, size: 26)
    );
  }

  Widget _buildGoButton() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: ElevatedButton(
            onPressed: () {
              if (_pinNumber.length != 6) {
                showWrongPINPopup(context);
              } else {
                if (!_isLoadingGo) {
                  verifyPINGo();
                }
              }
            },
            child: _isLoadingGo ? Column(
                children: [
                  const SizedBox(height: 5),
                  CircularProgressIndicator(
                      color: textColor,
                      strokeWidth: 2.5
                  ),
                  Text('       Go       ', style: TextStyle(color: textColor, fontSize: 20))
                ])
                : Column(
                children: [
                  const SizedBox(height: 5),
                  Icon(Icons.subdirectory_arrow_right_outlined, color: textColor),
                  Text('       Go       ', style: TextStyle(color: textColor, fontSize: 20))
                ]
            )
        )
    );
  }

  Widget _buildTimeClockButton() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: ElevatedButton(
            onPressed: () {
              if (_pinNumber.length != 6) {
                showWrongPINPopup(context);
              } else {
                if (!_isLoadingTC) {
                  verifyPINTC();
                }
              }
            },
            child: _isLoadingTC ? Column(
                children: [
                  const SizedBox(height: 5),
                  CircularProgressIndicator(
                    color: textColor,
                    strokeWidth: 2.5
                  ),
                  Text('Time Clock', style: TextStyle(color: textColor, fontSize: 20))
                ])
                : Column(
                children: [
                  const SizedBox(height: 5),
                  Icon(Icons.hourglass_bottom_outlined, color: textColor),
                  Text('Time Clock', style: TextStyle(color: textColor, fontSize: 20))
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
                Text('Wrong PIN Number', style: getRobotoFontStyle(20, true, textColor))
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
                    setState(() {
                      isLoadingAdmin = true;
                    });

                    String enteredPasscode = passcodeController.text.trim();
                    await Future.delayed(const Duration(seconds: 3));
                    onSuccess.call();

                    if (context.mounted) {
                      if (enteredPasscode == '12345') {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                            PageTransition(
                                child: const AdminPage(),
                                type: PageTransitionType.topToBottom
                            )
                        ).then((dynamic value) {
                          clearAllDisplay();
                        });
                      } else {
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
                        setState(() {
                          isLoadingAdmin = false;
                        });
                      }
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

}
