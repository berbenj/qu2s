import 'package:flutter/material.dart';
import '../../core/content.dart';
import '../../core/ioc.dart';
import 'task_details.dart';
import 'task_tree_controller.dart';
import '../../services/page_service.dart';
import '../../types/task.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button.dart';

import '../../widgets/day_selector.dart';

class TaskEdit extends StatelessWidget {
  final Task task;

  TaskEdit({super.key, required this.task});

  final PageService pageService = IoC.get<PageService>();
  final TasksTreeController tasksTreeController = IoC.get<TasksTreeController>();

  @override
  Widget build(BuildContext context) {
    final TextEditingController title = TextEditingController(text: task.title);
    final TextEditingController description = TextEditingController(text: task.description);
    Duration d = task.duration;
    final TextEditingController hour = TextEditingController(text: d.inHours.toString());
    d -= Duration(hours: d.inHours);
    final TextEditingController minute = TextEditingController(text: d.inMinutes.toString());
    d -= Duration(minutes: d.inMinutes);
    final TextEditingController second = TextEditingController(text: d.inSeconds.toString());
    final Content<DateTime> startDate = Content(task.startDate);
    final Content<DateTime> endDate = Content(task.endDate);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: title,
            decoration: const InputDecoration(label: Text('Title')),
          ),
          TextField(
            controller: description,
            decoration: const InputDecoration(label: Text('Description')),
            minLines: 1,
            maxLines: 20,
          ),
          Row(
            children: [
              const Text('Duration: '),
              Expanded(
                child: TextField(
                  controller: hour,
                  decoration: const InputDecoration(label: Text('hour')),
                  minLines: 1,
                  maxLines: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: minute,
                  decoration: const InputDecoration(label: Text('minute')),
                  minLines: 1,
                  maxLines: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: second,
                  decoration: const InputDecoration(label: Text('second')),
                  minLines: 1,
                  maxLines: 20,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              children: [
                const Text('Start Date: '),
                DaySelector(date: startDate),
                const Text('End Date: '),
                DaySelector(date: endDate),
              ],
            ),
          ),
          Row(
            children: [
              PrimaryButton(
                onPressed: () async {
                  // todo: set loading overlay
                  task.title = title.text;
                  task.description = description.text;
                  task.startDate = DateTime(startDate.value.year, startDate.value.month, startDate.value.day);
                  task.endDate = DateTime(endDate.value.year, endDate.value.month, endDate.value.day + 1);
                  task.duration = Duration(
                    hours: int.parse('0${hour.text}'),
                    minutes: int.parse('0${minute.text}'),
                    seconds: int.parse('0${second.text}'),
                  );
                  await Task.edit(task: task);
                  await tasksTreeController.updateTreeFromDatabase();
                  pageService.taskScreenIndex.value = 1;
                  pageService.taskScreenRightWidget.value = TaskDetails(task: task);
                },
                label: 'Edit',
              ),
              const SizedBox(width: 20),
              SecondaryButton(
                onPressed: () {
                  pageService.taskScreenIndex.value = 1;
                  pageService.taskScreenRightWidget.value = TaskDetails(task: task);
                },
                label: 'Cancel',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
