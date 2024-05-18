import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';
import '../../core/display.dart';
import '../../core/ioc.dart';
import '../../services/scheduler.dart';
import 'task_add.dart';
import 'task_tree_controller.dart';
import 'task_details.dart';
import '../../services/page_service.dart';
import '../../types/task.dart';
import '../../utils/platform.dart';
import '../../widgets/secondary_button.dart';

class TaskList extends StatelessWidget {
  TaskList({
    super.key,
  });

  final PageService pageService = IoC.get<PageService>();
  final TasksTreeController tasksTreeController = IoC.get<TasksTreeController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SecondaryButton(
                label: 'Add root task',
                onPressed: () {
                  pageService.taskScreenIndex.value = 1;
                  pageService.taskScreenRightWidget.value = TaskAdd(parents: const [], depth: 0);
                  tasksTreeController.updateTreeFromDatabase();
                },
              ),
              const SizedBox(width: 10),
              SecondaryButton(
                label: 'Generate events',
                onPressed: () {
                  schedule();
                },
              ),
              const Expanded(child: SizedBox(width: 10)),
              SecondaryButton(
                label: 'Refresh',
                onPressed: () {
                  tasksTreeController.clearTree();
                  tasksTreeController.updateTreeFromDatabase();
                },
              ),
            ],
          ),
        ),
        const Divider(thickness: 1, height: 1),
        Expanded(
          child: Display(
            contents: [tasksTreeController.root],
            builder: (__, _) => TreeView.simple(
              padding: const EdgeInsets.all(20),
              showRootNode: false,
              indentation: Indentation(
                style: Q2Platform.isWeb ? IndentStyle.scopingLine : IndentStyle.squareJoint,
                color: Colors.grey.shade600,
              ),
              expansionIndicatorBuilder: noExpansionIndicatorBuilder,
              expansionBehavior: ExpansionBehavior.snapToTop,
              tree: tasksTreeController.root.value,
              builder: (context, node) {
                final task = (node.data as Task);
                return Card(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: (!node.isLeaf)
                            ? ChevronIndicator.rightDown(
                                tree: node,
                                color: Colors.grey.shade600,
                              )
                            : Icon(
                                Icons.remove,
                                color: Colors.grey.shade600,
                              ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            pageService.taskScreenIndex.value = 1;
                            pageService.taskScreenRightWidget.value = TaskDetails(task: task);
                          },
                          child: Text(task.title),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              pageService.taskScreenIndex.value = 1;
                              pageService.taskScreenRightWidget.value =
                                  TaskAdd(parents: [...task.parents, task.id], depth: task.depth + 1);
                              tasksTreeController.updateTreeFromDatabase();
                            },
                            icon: Icon(Icons.add, color: Colors.grey.shade800),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
