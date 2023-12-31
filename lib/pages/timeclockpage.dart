import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zest_front_house/constants/styles.dart';
import 'package:intl/intl.dart';
import 'package:zest_front_house/pages/mainactivities.dart';

import '../model/mongodbmodel.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class TimeClockPage extends StatefulWidget {

  const TimeClockPage({super.key, required this.restaurantName});
  final String restaurantName;
  
  @override
  State<TimeClockPage> createState() => _TimeClockPageState();
}

class _TimeClockPageState extends State<TimeClockPage> {
  late Timer timer;
  String _formattedTime = DateFormat('h:mm a').format(DateTime.now());
  final String _formattedDate = DateFormat('EEEE, MMMM d').format(DateTime.now());
  bool _isClockedIn = false;
  bool _isOnBreak = false;
  // final List<DateTime> _clockedInList = <DateTime>[];
  // final List<DateTime> _clockedOutList = <DateTime>[];
  // final List<DateTime> _startBreakList = <DateTime>[];
  // final List<DateTime> _endBreakList = <DateTime>[];
  DateTime _clockedIn = DateTime.now();
  DateTime _clockedOut = DateTime.now();
  DateTime _startBreak = DateTime.now();
  DateTime _endBreak = DateTime.now();
  final List<Widget> timeClockColumn = <Widget>[];
  Duration _dayTotal = const Duration(hours: 0);
  final Duration _weekTotal = const Duration(hours: 0);
  Duration _breakToday = const Duration(hours: 0);
  final Duration _breakThisWeek = const Duration(hours: 0);

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(minutes: 1), (Timer t) {
      if (mounted) {
        setState(() {
          _formattedTime = DateFormat('h:mm a').format(DateTime.now());
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void clockIn() {
    setState(() {
      _isClockedIn = true;
    });
    DateTime temp = DateTime.now();
    _clockedIn = DateTime(
      temp.year,
      temp.month,
      temp.day,
      temp.hour,
      temp.minute
    );
    timeClockColumn.add(
      Row(
        children: [
          const SizedBox(width: 100),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Clocked in:', style: getRobotoFontStyle(18, false, const Color(0xff8bc24a))),
          ),
          const Spacer(flex: 1),
          Align(
            alignment: Alignment.centerRight,
            child: Text(DateFormat('h:mm a').format(DateTime.now()), style: getRobotoFontStyle(18, false, textColor)),
          ),
          const SizedBox(width: 100)
        ]
      )
    );
    timeClockColumn.add(const Divider(thickness: 0.5, color: Colors.black));
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ClockInOutScreen(
              restaurant: widget
                  .restaurantName,
              isClockedIn: _isClockedIn
          )
        )
    );
  }

  void clockOut() {
    setState(() {
      _isClockedIn = false;
      DateTime temp = DateTime.now();
      _clockedOut = DateTime(
          temp.year,
          temp.month,
          temp.day,
          temp.hour,
          temp.minute
      );
      _dayTotal += _calculateHoursWorked(_clockedIn, _clockedOut);
    });
    timeClockColumn.add(
        Row(
            children: [
              const SizedBox(width: 100),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Clocked out:', style: getRobotoFontStyle(18, false, const Color(0xfffc0303))),
              ),
              const Spacer(flex: 1),
              Align(
                alignment: Alignment.centerRight,
                child: Text(DateFormat('h:mm a').format(DateTime.now()), style: getRobotoFontStyle(18, false, textColor)),
              ),
              const SizedBox(width: 100)
            ]
        )
    );
    timeClockColumn.add(const Divider(thickness: 0.5, color: Colors.black));
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ClockInOutScreen(
                restaurant: widget
                    .restaurantName,
                isClockedIn: _isClockedIn
            )
        )
    );
  }

  void startBreak() {
    setState(() {
      _isOnBreak = true;
    });
    DateTime temp = DateTime.now();
    _startBreak = DateTime(
        temp.year,
        temp.month,
        temp.day,
        temp.hour,
        temp.minute
    );
    timeClockColumn.add(
        Row(
            children: [
              const SizedBox(width: 100),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Break started:', style: getRobotoFontStyle(18, false, const Color(0xffff9700))),
              ),
              const Spacer(flex: 1),
              Align(
                alignment: Alignment.centerRight,
                child: Text(DateFormat('h:mm a').format(DateTime.now()), style: getRobotoFontStyle(18, false, textColor)),
              ),
              const SizedBox(width: 100)
            ]
        )
    );
    timeClockColumn.add(const Divider(thickness: 0.5, color: Colors.black));
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => BreakInOutScreen(
                restaurant: widget
                    .restaurantName,
                isOnBreak: _isOnBreak
            )
        )
    );
  }

  void endBreak() {
    setState(() {
      _isOnBreak = false;
      DateTime temp = DateTime.now();
      _endBreak = DateTime(
          temp.year,
          temp.month,
          temp.day,
          temp.hour,
          temp.minute
      );
      _breakToday += _calculateHoursWorked(_startBreak, _endBreak);
    });
    timeClockColumn.add(
        Row(
            children: [
              const SizedBox(width: 100),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Break ended:', style: getRobotoFontStyle(18, false, const Color(0xffff9700))),
              ),
              const Spacer(flex: 1),
              Align(
                alignment: Alignment.centerRight,
                child: Text(DateFormat('h:mm a').format(DateTime.now()), style: getRobotoFontStyle(18, false, textColor)),
              ),
              const SizedBox(width: 100)
            ]
        )
    );
    timeClockColumn.add(const Divider(thickness: 0.5, color: Colors.black));
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => BreakInOutScreen(
                restaurant: widget
                    .restaurantName,
                isOnBreak: _isOnBreak
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Time Clock',
      home: Scaffold(
        appBar: AppBar(
            title: Text('Time Clock', style: getRobotoFontStyle(20, true, textColor)),
            backgroundColor: Theme
                .of(context)
                .colorScheme
                .inversePrimary,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: textColor),
              onPressed: () {
                Navigator.of(context).pop();
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
          child: SafeArea(
            child: Row(
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 20, right:10, top: 20, bottom: 20),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      width: 340,
                      height: 500,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 7),
                          Text(_formattedDate, style: getRobotoFontStyle(22, false, textColor)),
                          const SizedBox(height: 7),
                          Text(_formattedTime, style: getRobotoFontStyle(28, true, textColor)),
                          const SizedBox(height: 15),
                          futureBuilder('', 'icon', ''),
                          const SizedBox(height: 15),
                          futureBuilder('Welcome back, ', 'firstName', '!'),
                          const SizedBox(height: 13),
                          ElevatedButton(
                              style: _isClockedIn
                                  ? ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xfffc0303)
                                  )
                                  : ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff8bc24a)
                                  ),
                              onPressed: () {
                                if (!_isClockedIn) {
                                  clockIn();
                                } else {
                                  clockOut();
                                }
                              },
                              child: Column(
                                  children: [
                                    const SizedBox(height: 8),
                                    const Icon(Icons.hourglass_bottom_outlined, color: Colors.white),
                                    const SizedBox(height: 3),
                                    _isOnBreak
                                    ? const Text('    Clock Out    ', style: TextStyle(color: Colors.white, fontSize: 20))
                                    : const Text('    Clock In     ', style: TextStyle(color: Colors.white, fontSize: 20)),
                                    const SizedBox(height: 8)
                                  ]
                                )
                          ),
                          const SizedBox(height: 25),
                          ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffff9700)),
                              ),
                              onPressed: () {
                                if (!_isOnBreak) {
                                  startBreak();
                                } else {
                                  endBreak();
                                }
                              },
                              child: Column(
                                children: [
                                  const SizedBox(height: 8),
                                  const Icon(Icons.coffee_outlined, color: Colors.white),
                                  const SizedBox(height: 3),
                                  _isOnBreak
                                  ? const Text('   End Break   ', style: TextStyle(color: Colors.white, fontSize: 20))
                                  : const Text('  Start Break  ', style: TextStyle(color: Colors.white, fontSize: 20)),
                                  const SizedBox(height: 8)
                                ],
                              )
                          )
                        ],
                      )
                    )
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 20, top: 20, bottom: 20),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width - 400,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                          children: [
                            Column(
                              children: [
                                _isClockedIn
                                  ? const Icon(Icons.check_circle_outline, color: Color(0xff8bc24a), size: 65)
                                  : const Icon(Icons.cancel_outlined, color: Color(0xfffc0303), size: 65),
                                const SizedBox(height: 8),
                                _isClockedIn
                                    ? Text('You are clocked in!', style: getRobotoFontStyle(32, false, textColor))
                                    : Text('You are clocked out!', style: getRobotoFontStyle(32, false, textColor))
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                  Column(
                                    children: [
                                      Text('Day Total', style: getRobotoFontStyle(23, true, textColor)),
                                      const SizedBox(height: 5),
                                      Text(_getFormattedDuration(_dayTotal), style: getRobotoFontStyle(23, false, textColor)),
                                      const SizedBox(height: 5),
                                      Text('Break: ${_getFormattedDuration(_breakToday)}', style: getRobotoFontStyle(15, false, textColor))
                                    ],
                                  ),
                                  const SizedBox(width: 120),
                                  Column(
                                    children: [
                                      Text('Week Total', style: getRobotoFontStyle(23, true, textColor)),
                                      const SizedBox(height: 5),
                                      Text(_getFormattedDuration(_weekTotal), style: getRobotoFontStyle(23, false, textColor)),
                                      const SizedBox(height: 5),
                                      Text('Break: ${_getFormattedDuration(_breakThisWeek)}', style: getRobotoFontStyle(15, false, textColor))
                                    ],
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Column(
                              children: timeClockColumn.map(
                                  (Widget timeClock) => timeClock
                              ).toList()
                            )
                          ]
                        )
                      )
                    )
                  )
                )
              ],
            )
          )
        ),
      ),
    );
  }
}

Widget futureBuilder(String preText, String data, String postText) {
  return FutureBuilder<Map<String, dynamic>?>(
    future: readDataFromCache(),
    builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        Object? value;
        switch(data) {
          case 'firstName':
            value = MongoDbModel.fromJson(snapshot.data).firstName;
            break;
          case 'lastName':
            value = MongoDbModel.fromJson(snapshot.data).lastName;
            break;
          case 'role':
            value = MongoDbModel.fromJson(snapshot.data).role;
            break;
          case 'icon':
            value = MongoDbModel.fromJson(snapshot.data).icon;
            return iconPicker(value as int?);
          case 'clockEntries':
            value = MongoDbModel.fromJson(snapshot.data).dailyClockEntries;
            break;
        }
        return Text('$preText$value$postText',
          style: getRobotoFontStyle(20, true, textColor),);
      }
    },
  );
}

Widget iconPicker(int? choice) {
  Image selectedIcon = Image.asset('assets/images/icons/wired-flat-16-avatar-woman-nodding.gif');
  switch (choice) {
    case 0:
      selectedIcon = Image.asset('assets/images/icons/wired-flat-16-avatar-woman-nodding.gif');
      break;
    case 1:
      selectedIcon = Image.asset('assets/images/icons/wired-flat-17-avatar-man-nodding.gif');
      break;
    case 2:
      selectedIcon = Image.asset('assets/images/icons/wired-flat-269-avatar-female.gif');
      break;
    case 3:
      selectedIcon = Image.asset('assets/images/icons/wired-flat-268-avatar-man.gif');
      break;
    case 4:
      selectedIcon = Image.asset('assets/images/icons/icons8-beth-smith-100.png');
      break;
    case 5:
      selectedIcon = Image.asset('assets/images/icons/icons8-jerry-smith-100.png');
      break;
    case 6:
      selectedIcon = Image.asset('assets/images/icons/icons8-summer-smith-100.png');
      break;
    case 7:
      selectedIcon = Image.asset('assets/images/icons/icons8-rick-sanchez-100.png');
      break;
    case 8:
      selectedIcon = Image.asset('assets/images/icons/icons8-morty-smith-100.png');
      break;
    case 9:
      selectedIcon = Image.asset('assets/images/icons/icons8-homer-simpson-96.png');
      break;
    case 10:
      selectedIcon = Image.asset('assets/images/icons/icons8-super-mario-100.png');
      break;
    case 11:
      selectedIcon = Image.asset('assets/images/icons/icons8-kawaii-cupcake-100.png');
      break;
    case 12:
      selectedIcon = Image.asset('assets/images/icons/icons8-kawaii-french-fries-100.png');
      break;
    case 13:
      selectedIcon = Image.asset('assets/images/icons/icons8-kawaii-ice-cream-100.png');
      break;
    case 14:
      selectedIcon = Image.asset('assets/images/icons/icons8-cow-100.png');
      break;
    case 15:
      selectedIcon = Image.asset('assets/images/icons/icons8-bear-100.png');
      break;
    case 16:
      selectedIcon = Image.asset('assets/images/icons/icons8-panda-100.png');
      break;
    case 17:
      selectedIcon = Image.asset('assets/images/icons/icons8-whale-100.png');
      break;
    case 18:
      selectedIcon = Image.asset('assets/images/icons/icons8-penguin-100.png');
      break;
  }
  return Container(
      width: 65,
      height: 65,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: choice == null ? Image.asset('assets/images/icons/loading.gif') : selectedIcon
  );
}

Future<Map<String, dynamic>?> readDataFromCache() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? value = prefs.getString('staffInfo');
  Map<String, dynamic>? result = value != null ? jsonDecode(value): null;
  return result;
}

Duration _calculateHoursWorked(DateTime clockedIn, DateTime clockedOut) {
  return clockedOut.difference(clockedIn);
}

String _getFormattedDuration(Duration time) {
  return '${time.inHours}:${(time.inMinutes % 60).toString().padLeft(2, '0')}';
}

class ClockInOutScreen extends StatefulWidget {
  const ClockInOutScreen({super.key, required this.restaurant, required this.isClockedIn});
  final String restaurant;
  final bool isClockedIn;

  @override
  State<ClockInOutScreen> createState() => _ClockInOutScreenState();
}

class _ClockInOutScreenState extends State<ClockInOutScreen> {
  late Timer timer;

  @override
  void initState() {
    timer = Timer(const Duration(seconds: 5), () {
      Navigator.pop(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: widget.isClockedIn ? const Color(0xff8bc24a) : const Color(0xfffc0303),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(135),
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: ClipOval(
                    child: Image.asset('assets/images/icons/wired-lineal-45-clock-time.gif')
                  )
                ),
                widget.isClockedIn
                    ? Text('You are clocked in!', style: getRobotoFontStyle(50, false, Colors.white))
                    : Text('You are clocked out!', style: getRobotoFontStyle(50, false, Colors.white)),
                const SizedBox(height: 8),
                Text('At ${widget.restaurant} at ${DateFormat('h:mm a').format(DateTime.now())}', style: getRobotoFontStyle(25, false, Colors.white)),
                const SizedBox(height: 35),
                Text('This screen will close in 5 seconds!', style: getRobotoFontStyle(20, false, Colors.white))
              ],
            )
          )
        )
      ),
    );
  }
}

class BreakInOutScreen extends StatefulWidget {
  const BreakInOutScreen({super.key, required this.restaurant, required this.isOnBreak});
  final String restaurant;
  final bool isOnBreak;

  @override
  State<BreakInOutScreen> createState() => _BreakInOutScreenState();
}

class _BreakInOutScreenState extends State<BreakInOutScreen> {
  late Timer timer;

  @override
  void initState() {
    timer = Timer(const Duration(seconds: 5), () {
      Navigator.pop(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xffff9700),
      body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Navigator.pop(context);
          },
          child: Center(
              child: Container(
                  padding: const EdgeInsets.all(135),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      SizedBox(
                          height: 100,
                          width: 100,
                          child: ClipOval(
                              child: Image.asset('assets/images/icons/wired-lineal-567-french-fries-chips.gif')
                          )
                      ),
                      widget.isOnBreak
                          ? Text('Break started!', style: getRobotoFontStyle(50, false, Colors.white))
                          : Text('Break ended!', style: getRobotoFontStyle(50, false, Colors.white)),
                      const SizedBox(height: 8),
                      Text('At ${widget.restaurant} at ${DateFormat('h:mm a').format(DateTime.now())}', style: getRobotoFontStyle(25, false, Colors.white)),
                      const SizedBox(height: 35),
                      Text('This screen will close in 5 seconds!', style: getRobotoFontStyle(20, false, Colors.white))
                    ],
                  )
              )
          )
      ),
    );
  }
}
