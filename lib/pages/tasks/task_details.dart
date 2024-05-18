import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../core/ioc.dart';
import 'task_edit.dart';
import 'task_tree_controller.dart';
import '../../services/page_service.dart';
import '../../types/task.dart';
import '../../utils/platform.dart';
import '../../widgets/secondary_button.dart';

class TaskDetails extends StatelessWidget {
  final Task task;

  TaskDetails({
    super.key,
    required this.task,
  });

  final PageService pageService = IoC.get<PageService>();
  final TasksTreeController tasksTreeController = IoC.get<TasksTreeController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SecondaryButton(
                label: 'Edit',
                onPressed: () {
                  pageService.taskScreenIndex.value = 1;
                  pageService.taskScreenRightWidget.value = TaskEdit(task: task);
                },
              ),
              const SizedBox(width: 8),
              SecondaryButton(
                label: 'Delete',
                onPressed: () async {
                  await Task.delete(id: task.id);
                  pageService.taskScreenIndex.value = 0;
                  pageService.taskScreenRightWidget.value = const SizedBox();
                  tasksTreeController.clearTree();
                  tasksTreeController.updateTreeFromDatabase();
                },
              ),
              const SizedBox(width: 8),
              if (Q2Platform.isAndroid)
                TextButton.icon(
                  style: ButtonStyle(foregroundColor: MaterialStatePropertyAll(Colors.grey.shade800)),
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    pageService.taskScreenIndex.value = 0;
                    pageService.taskScreenRightWidget.value = const SizedBox();
                  },
                  label: const Text('Back'),
                )
              else
                TextButton.icon(
                  style: ButtonStyle(foregroundColor: MaterialStatePropertyAll(Colors.grey.shade800)),
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    pageService.taskScreenIndex.value = 0;
                    pageService.taskScreenRightWidget.value = const SizedBox();
                  },
                  label: const Text('Close'),
                ),
            ],
          ),
          MarkdownBody(data: '# ${task.title}'),
          const SizedBox(height: 8),
          MarkdownBody(data: task.description ?? ''),
          const SizedBox(height: 20),
          MarkdownBody(data: '**Start date**: ${task.startDate.toString().substring(0, 16)}'),
          MarkdownBody(data: '**End date**: ${task.endDate.toString().substring(0, 16)}'),
          const SizedBox(height: 8),
          MarkdownBody(data: '**Duration**: ${task.durationAsString}'),
          const SizedBox(height: 8),
          MarkdownBody(data: '**Status**: ${task.status}'),
        ],
      ),
    );
  }
}
