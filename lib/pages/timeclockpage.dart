import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zest_front_house/constants/styles.dart';
import 'package:intl/intl.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class TimeClockPage extends StatefulWidget {

  const TimeClockPage({super.key, required this.employeeName, required this.restaurantName});
  final String employeeName;
  final String restaurantName;
  
  @override
  _TimeClockPageState createState() => _TimeClockPageState();
}

class _TimeClockPageState extends State<TimeClockPage> {
  late Timer timer;
  String _formattedTime = _getCurrentTime();
  final String _formattedDate = DateFormat('EEEE, MMMM d').format(DateTime.now());
  bool _isClockedIn = false;
  List<DateTime> _clockedIn = [];
  List<DateTime> _clockedOut = [];
  Duration _dayTotal = Duration(hours: 0);
  Duration _weekTotal = Duration(hours: 0);
  Duration _breakToday = Duration(hours: 0);
  Duration _breakThisWeek = Duration(hours: 0);
  Duration _workToday = Duration(hours: 0);
  Duration _workThisWeek = Duration(hours: 0);

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(minutes: 1), (Timer t) {
      if (mounted) {
        setState(() {
          _formattedTime = _getCurrentTime();
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
    _clockedIn.add(DateTime.now());
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
    });
    _clockedOut.add(DateTime.now());
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
            )
        ),
        body: Center(
          child: SafeArea(
            child: Row(
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 20, right:10, top: 20, bottom: 20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
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
                          const SizedBox(height: 20),
                          Container(
                            width: 65,
                            height: 65,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Image.asset('assets/images/icons/wired-flat-16-avatar-woman-nodding.gif')
                          ),
                          const SizedBox(height: 10),
                          Text('Welcome back, ${widget.employeeName}!', style: getRobotoFontStyle(22, true, textColor)),
                          const SizedBox(height: 35),
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
                              child: _isClockedIn
                              ? const Column(
                                  children: [
                                    SizedBox(height: 8),
                                    Icon(Icons.hourglass_bottom_outlined, color: Colors.white),
                                    Text('    Clock Out    ', style: TextStyle(color: Colors.white, fontSize: 20)),
                                    SizedBox(height: 8)
                                  ]
                                )
                              : const Column(
                                  children: [
                                    SizedBox(height: 8),
                                    Icon(Icons.hourglass_bottom_outlined, color: Colors.white),
                                    Text('    Clock In     ', style: TextStyle(color: Colors.white, fontSize: 20)),
                                    SizedBox(height: 8)
                                  ]
                              )
                          ),
                          const SizedBox(height: 25),
                          ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Color(0xffff9700)),
                              ),
                              onPressed: () {},
                              child: const Column(
                                children: [
                                  SizedBox(height: 8),
                                  Icon(Icons.coffee_outlined, color: Colors.white),
                                  Text('  Start Break  ', style: TextStyle(color: Colors.white, fontSize: 20)),
                                  SizedBox(height: 8)
                                ],
                              )
                          )
                        ],
                      )
                    )
                ),
                //const VerticalDivider(thickness: 1, color: Colors.black),
                Padding(
                    padding: const EdgeInsets.only(left: 10, right: 20, top: 20, bottom: 20),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                        child: Container(
                        padding: const EdgeInsets.all(20),
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width - 400,
                        height: 500,
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
                                      Text('Break: ${_getFormattedDuration(_breakToday)}', style: getRobotoFontStyle(15, false, textColor)),
                                      const SizedBox(height: 5),
                                      Text('Work: ${_getFormattedDuration(_workToday)}', style: getRobotoFontStyle(15, false, textColor))
                                    ],
                                  ),
                                  const SizedBox(width: 120),
                                  Column(
                                    children: [
                                      Text('Week Total', style: getRobotoFontStyle(23, true, textColor)),
                                      const SizedBox(height: 5),
                                      Text(_getFormattedDuration(_weekTotal), style: getRobotoFontStyle(23, false, textColor)),
                                      const SizedBox(height: 5),
                                      Text('Break: ${_getFormattedDuration(_breakThisWeek)}', style: getRobotoFontStyle(15, false, textColor)),
                                      const SizedBox(height: 5),
                                      Text('Work: ${_getFormattedDuration(_workThisWeek)}', style: getRobotoFontStyle(15, false, textColor))
                                    ],
                                  ),
                              ],
                            )
                          ]
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

String _getCurrentTime() {
  DateTime currentTime = DateTime.now();
  int hour = 0;
  String minute = '';
  String amPm = currentTime.hour >= 12 ? 'PM' : 'AM';
  if (currentTime.hour >= 12) {
    hour = currentTime.hour - 12;
  } else if (currentTime.hour == 0) {
    hour = 12;
  } else {
    hour = currentTime.hour;
  }
  if (currentTime.minute < 10) {
    minute = '0${currentTime.minute}';
  } else {
    minute = '${currentTime.minute}';
  }
  String formattedTime = '$hour:$minute $amPm';
  return formattedTime;
}

String _calculateHoursWorked(DateTime clockedIn, DateTime clockedOut) {
  return _getFormattedDuration(clockedOut.difference(clockedIn));
}

String _getFormattedDuration(Duration time) {
  return '${time.inHours}:${(time.inMinutes % 60).toString().padLeft(2, '0')}';
}

class ClockInOutScreen extends StatefulWidget {
  const ClockInOutScreen({super.key, required this.restaurant, required this.isClockedIn});
  final String restaurant;
  final bool isClockedIn;

  @override
  _ClockInOutScreenState createState() => _ClockInOutScreenState();
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
                Text('At ${widget.restaurant} at ${_getCurrentTime()}', style: getRobotoFontStyle(25, false, Colors.white)),
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
