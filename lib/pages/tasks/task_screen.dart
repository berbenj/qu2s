import 'package:flutter/material.dart';
import '../../core/display.dart';
import '../../core/ioc.dart';
import '../../services/page_service.dart';
import '../../utils/platform.dart';

import 'task_list.dart';

class TaskScreen extends StatelessWidget {
  TaskScreen({
    super.key,
  });

  final PageService pageService = IoC.get<PageService>();

  @override
  Widget build(BuildContext context) {
    if (Q2Platform.isAndroid) {
      return Display(
        contents: [pageService.taskScreenRightWidget],
        builder: (_, __) => [
          Expanded(child: TaskList()),
          Expanded(child: pageService.taskScreenRightWidget.value),
        ][pageService.taskScreenIndex.value],
      );
    } else {
      return Display(
        contents: [pageService.taskScreenRightWidget],
        builder: (_, __) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: TaskList(),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              flex: 3,
              child: pageService.taskScreenRightWidget.value,
            ),
          ],
        ),
      );
    }
  }
}
