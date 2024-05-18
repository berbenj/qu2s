import 'package:flutter/material.dart';
import '../../core/content.dart';
import '../../core/ioc.dart';
import '../../services/page_service.dart';
import '../../types/task.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button.dart';
import '../../widgets/day_selector.dart';
import 'task_tree_controller.dart';

class TaskAdd extends StatelessWidget {
  final List<String> parents;
  final int depth;

  TaskAdd({super.key, required this.parents, required this.depth});

  final PageService pageService = IoC.get<PageService>();
  final TasksTreeController tasksTreeController = IoC.get<TasksTreeController>();

  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController hour = TextEditingController();
  final TextEditingController minute = TextEditingController();
  final TextEditingController second = TextEditingController();
  final Content<DateTime> startDate = Content(DateTime.now());
  final Content<DateTime> endDate = Content(DateTime.now());

  @override
  Widget build(BuildContext context) {
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
                label: 'Add',
                onPressed: () async {
                  // todo: set loading overlay
                  await Task.add(
                    title: title.text,
                    description: description.text,
                    startDate: DateTime(startDate.value.year, startDate.value.month, startDate.value.day),
                    endDate: DateTime(endDate.value.year, endDate.value.month, endDate.value.day + 1),
                    duration: Duration(
                      hours: int.parse('0${hour.text}'),
                      minutes: int.parse('0${minute.text}'),
                      seconds: int.parse('0${second.text}'),
                    ),
                    depth: depth,
                    parents: parents,
                  );
                  await tasksTreeController.updateTreeFromDatabase();
                  pageService.taskScreenIndex.value = 0;
                  pageService.taskScreenRightWidget.value = const SizedBox();
                },
              ),
              const SizedBox(width: 20),
              SecondaryButton(
                label: 'Cancel',
                onPressed: () {
                  pageService.taskScreenIndex.value = 0;
                  pageService.taskScreenRightWidget.value = const SizedBox();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
