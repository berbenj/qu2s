import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../config/theme_config.dart';
import '../../core/content.dart';
import '../../core/display.dart';
import '../../types/event.dart';
import '../../utils/platform.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button.dart';

class EventsScreen extends StatelessWidget {
  EventsScreen({
    super.key,
  });

  final Content<DateTime> pageDate = Content(DateTime.now());

  @override
  Widget build(BuildContext context) {
    if (Q2Platform.isAndroid) {
      pageDate.value = DateTime.now();
    } else {
      pageDate.value = DateTime.now().subtract(Duration(days: DateTime.now().weekday));
    }

    return Stack(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Display(
                  contents: [pageDate],
                  builder: (_, __) => Row(
                    children: [
                      const HourNumbers(),
                      for (var i in [
                        0,
                        if (Q2Platform.isntAndroid) ...[1, 2, 3, 4, 5, 6],
                      ])
                        EventsDay(day: pageDate.value.add(Duration(days: i))),
                      if (Q2Platform.isntAndroid) const HourNumbers(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: Colors.grey.shade900,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 35.6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (Q2Platform.isAndroid) {
                            pageDate.value = pageDate.value.subtract(const Duration(days: 1));
                          } else {
                            pageDate.value = pageDate.value.subtract(const Duration(days: 7));
                          }
                        },
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return Display(
                                contents: [pageDate],
                                builder: (_, __) => Dialog(
                                  child: (Q2Platform.isAndroid)
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              DayPicker.single(
                                                selectedDate: pageDate.value,
                                                initiallyShowDate: pageDate.value,
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2099),
                                                onChanged: (newDateTime) {
                                                  pageDate.value = newDateTime;
                                                },
                                                datePickerStyles: DatePickerRangeStyles(
                                                  selectedDateStyle: TextStyle(
                                                    color: ThemeConfig.color.onAccent,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  selectedSingleDateDecoration: BoxDecoration(
                                                    color: ThemeConfig.color.accent,
                                                    borderRadius:
                                                        const BorderRadiusDirectional.all(Radius.circular(10.0)),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SecondaryButton(
                                                    label: 'Today',
                                                    onPressed: () {
                                                      pageDate.value = DateTime.now();
                                                    },
                                                  ),
                                                  const SizedBox(width: 16),
                                                  PrimaryButton(
                                                    label: 'Ok',
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              WeekPicker(
                                                selectedDate: pageDate.value,
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2099),
                                                onChanged: (newDateTime) {
                                                  pageDate.value = newDateTime.start;
                                                },
                                                datePickerStyles: DatePickerRangeStyles(
                                                  selectedDateStyle: TextStyle(
                                                    color: ThemeConfig.color.onAccent,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  selectedPeriodStartDecoration: BoxDecoration(
                                                    color: ThemeConfig.color.accent,
                                                    borderRadius: const BorderRadiusDirectional.horizontal(
                                                      start: Radius.circular(10.0),
                                                    ),
                                                  ),
                                                  selectedPeriodMiddleDecoration: BoxDecoration(
                                                    color: ThemeConfig.color.accent,
                                                    borderRadius: const BorderRadiusDirectional.all(Radius.zero),
                                                  ),
                                                  selectedPeriodLastDecoration: BoxDecoration(
                                                    color: ThemeConfig.color.accent,
                                                    borderRadius: const BorderRadiusDirectional.horizontal(
                                                      end: Radius.circular(10.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SecondaryButton(
                                                    label: 'This week',
                                                    onPressed: () {
                                                      pageDate.value = DateTime.now();
                                                    },
                                                  ),
                                                  const SizedBox(width: 16),
                                                  PrimaryButton(
                                                    label: 'Ok',
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                              );
                            },
                          );
                        },
                        style: ButtonStyle(foregroundColor: MaterialStatePropertyAll(ThemeConfig.color.accent)),
                        child: Display(
                          contents: [pageDate],
                          builder: (_, __) => (Q2Platform.isAndroid)
                              ? Text(pageDate.value.toString().substring(0, 10))
                              : Text(
                                  '${pageDate.value.toString().substring(0, 10)} - ${pageDate.value.add(const Duration(days: 6)).toString().substring(0, 10)}',
                                ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (Q2Platform.isAndroid) {
                            pageDate.value = pageDate.value.add(const Duration(days: 1));
                          } else {
                            pageDate.value = pageDate.value.add(const Duration(days: 7));
                          }
                        },
                        icon: const Icon(Icons.arrow_forward_ios_rounded),
                      ),
                    ],
                  ),
                ),
                if (Q2Platform.isntAndroid)
                  Row(
                    children: [
                      for (var weekday in [
                        'Sunday',
                        'Monday',
                        'Tuesday',
                        'Wednesday',
                        'Thursday',
                        'Friday',
                        'Saturday',
                      ])
                        Expanded(child: Center(child: Text(weekday))),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class EventsDay extends StatelessWidget {
  final DateTime day;

  EventsDay({
    super.key,
    required this.day,
  });

  final Content<List<Event>> events = Content([]);

  updateEvents() async {
    events.value =
        await Event.getByDate(DateTime(day.year, day.month, day.day), DateTime(day.year, day.month, day.day + 1));
  }

  @override
  Widget build(BuildContext context) {
    updateEvents();

    return Expanded(
      child: Display(
        contents: [events],
        builder: (_, __) => Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 40),
                const SizedBox(height: 50),
                for (var hour in [1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, -1])
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      border: BorderDirectional(
                        top: (hour == 1)
                            ? BorderSide(color: Colors.grey.shade700)
                            : BorderSide(color: Colors.grey.shade800),
                        // start: BorderSide(color: Colors.grey.shade800),
                        bottom: (hour == -1) ? BorderSide(color: Colors.grey.shade700) : BorderSide.none,
                        // end: (day == 7) ? BorderSide(color: Colors.grey.shade800) : BorderSide.none,
                      ),
                    ),
                  ),
                const SizedBox(height: 50),
              ],
            ),
            for (var event in events.value)
              Positioned(
                top: 50 + 40 + (event.start.hour * 100.0) + (event.start.minute / 60.0 * 100.0),
                height: (event.duration.inMinutes / 60.0 * 100.0) + 3, // todo: remove this `3` and find a real solution
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 66, 63, 71),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(event.title, textAlign: TextAlign.center),
                          Text(
                            '${event.start.hour}:${event.start.minute.toString().padLeft(2, '0')} - ${event.end.hour}:${event.end.minute.toString().padLeft(2, '0')}',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class HourNumbers extends StatelessWidget {
  const HourNumbers({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const SizedBox(height: 40),
          for (var hour in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24])
            SizedBox(
              height: 100,
              child: Center(child: MarkdownBody(data: '$hour')),
            ),
        ],
      ),
    );
  }
}
