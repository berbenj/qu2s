import 'dart:async';
import 'dart:io';
// import 'package:ntp/ntp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:dart_date/dart_date.dart';
import 'package:firedart/firedart.dart' as fd;

import 'q2_date.dart';
import 'q2_platform.dart';

Q2Platform q2Platform = Q2Platform();

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final auth = fd.FirebaseAuth.instance;
  String _b36Date = '';
  String _qdArton = '';
  String _qdJitt = '';
  String _gregorianYear = '';
  String _gregorianMonth = '';
  String _gregorianMonthName = '';
  String _gregorianDay = '';
  String _gregorianHour = '';
  String _gregorianMinute = '';
  String _gregorianSecond = '';
  String _amp = '';
  String _12h = '';
  String _weekday = '';
  String _weeknum = '';
  Timer? _clockTimer;
  Timer? _aNTPTimer;
  int offset = 0;

  void _setCurrentDate([DateTime? date_]) {
    setState(() {
      // if no date is provided use the current time
      date_ ??= DateTime.now().toLocalTime;
      DateTime date = date_!;
      date = date.addMilliseconds(offset);

      var qdt = Q2Date(date);

      _b36Date = '|${qdt.b36Year}/${qdt.b36Pernor}${qdt.b36Scrop}-${qdt.b36Day}';
      _qdArton = "${qdt.qdArton}'";
      _qdJitt = '${qdt.qdJitt}"';

      _gregorianYear = qdt.grYear;
      _gregorianMonth = qdt.grMonth;
      const monthNames = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec'];
      _gregorianMonthName = monthNames[int.parse(qdt.grMonth) - 1];

      _gregorianDay = qdt.grDay;
      _gregorianHour = qdt.sdHour;
      _gregorianMinute = ':${qdt.sdMinute}';
      _gregorianSecond = ':${qdt.sdSecond}';
      _amp = (int.parse(qdt.sdHour) < 12) ? 'AM' : 'PM';
      _12h = (((int.parse(qdt.sdHour) + 11) % 12) + 1).toString().padLeft(2, '0');
      const weekDayNames = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
      _weekday = weekDayNames[date.weekday - 1];
      _weeknum = date.getWeek.toString().padLeft(2, '0');
    });
  }

  @override
  void initState() {
    super.initState();
    _getTime(DateTime.now());
    _clockTimer = Timer.periodic(const Duration(milliseconds: 10), (Timer t) => _setCurrentDate());
    _aNTPTimer = Timer.periodic(const Duration(seconds: 10), (Timer t) => _getTime(DateTime.now()));
  }

  @override
  void dispose() {
    _clockTimer!.cancel();
    _aNTPTimer!.cancel();
    super.dispose();
  }

  Future<void> _getTime(DateTime time) async {
    // question: how much does this cost?
    // offset = await NTP.getNtpOffset(localTime: time);
  }

  addPost(String title, List<String> content) async {
    await fd.Firestore.instance.collection('blog_posts').add({
      'title': title,
      'content': content,
    });
    // todo: return if it is successful or not! display error to user.
  }

  @override
  Widget build(BuildContext context) {
    _setCurrentDate();

    // todo: if height ; width
    if (!kIsWeb && Platform.isAndroid) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          gregorianClock(),
          const SizedBox(height: 50),
          b36Clock(),
        ],
      );
    } else {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            gregorianClock(),
            const SizedBox(width: 100),
            b36Clock(),
          ],
        ),
      );
    }
  }

  Column b36Clock() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          _b36Date,
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w300),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _qdArton,
                style: const TextStyle(fontSize: 68, fontWeight: FontWeight.w900),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _qdJitt,
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w300, height: 1.4),
                  ),
                  const Text(
                    '═══╛',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w300, height: 0.6),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget gregorianClock() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  '$_gregorianYear-|',
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w300),
                ),
                Column(
                  children: [
                    Text(
                      _gregorianMonth,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w300),
                    ),
                    Text(
                      _gregorianMonthName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
                Text(
                  '|-$_gregorianDay',
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            const SizedBox(width: 15),
            Column(
              children: [
                Text(
                  'w$_weeknum',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                ),
                Text(
                  _weekday,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                const SizedBox(height: 5),
                Text(
                  _amp,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w300),
                ),
                Text(
                  _12h,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Text(
              _gregorianHour,
              style: const TextStyle(fontSize: 68, fontWeight: FontWeight.w900),
            ),
            Text(
              _gregorianMinute,
              style: const TextStyle(fontSize: 68, fontWeight: FontWeight.w300),
            ),
            Column(
              children: [
                Text(
                  _gregorianSecond,
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w300, height: 1.4),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 0),
                  child: Text(
                    '╺══',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w300, height: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget post(String title, List<String> content) {
    Column c = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [postTitle(title)],
    );
    for (var par in content) {
      c.children.add(postParagraph(par));
    }

    return Center(
      child: Container(
        width: 700,
        padding: const EdgeInsets.all(20),
        child: c,
      ),
    );
  }

  Text postParagraph(String par) {
    return Text(
      '\n$par',
      style: const TextStyle(fontSize: 14, fontFamily: 'Fira code', height: 1.5),
    );
  }

  Text postTitle(String title) {
    return Text(
      " $title \n${"-" * (title.length + 2)}",
      style: const TextStyle(fontSize: 18, fontFamily: 'Fira code', fontWeight: FontWeight.bold),
    );
  }
}
