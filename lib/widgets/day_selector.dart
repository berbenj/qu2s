import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import '../config/theme_config.dart';
import '../core/content.dart';
import '../core/display.dart';
import 'primary_button.dart';
import 'secondary_button.dart';

class DaySelector extends StatelessWidget {
  final Content<DateTime> date;

  const DaySelector({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) {
            return Display(
              contents: [date],
              builder: (_, __) => Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DayPicker.single(
                        selectedDate: date.value,
                        initiallyShowDate: date.value,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2099),
                        onChanged: (newDateTime) {
                          date.value = newDateTime;
                        },
                        datePickerStyles: DatePickerRangeStyles(
                          selectedDateStyle: TextStyle(
                            color: ThemeConfig.color.onAccent,
                            fontWeight: FontWeight.bold,
                          ),
                          selectedSingleDateDecoration: BoxDecoration(
                            color: ThemeConfig.color.accent,
                            borderRadius: const BorderRadiusDirectional.all(Radius.circular(10.0)),
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
                              date.value = DateTime.now();
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
      child: const Text('Today'),
    );
  }
}
