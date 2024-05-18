import 'package:animated_tree_view/tree_view/tree_node.dart';
import '../../core/content.dart';
import '../../types/task.dart';

/// controller for the task tree in task page
class TasksTreeController {
  final Content<TreeNode> root = Content(TreeNode.root());

  Future<void> updateTreeFromDatabase() async {
    final tasks = await Task.getByDepth(0);

    for (var task in tasks.where((element) => element.depth == 0)) {
      if (!root.value.children.containsKey(task.id)) {
        root.value.add(TreeNode(key: task.id, data: task));
      }
      var taskNode = root.value.children[task.id]!;
      for (var subtask in tasks.where((element) => element.depth == 1 && element.parents.contains(task.id))) {
        if (!taskNode.children.containsKey(subtask.id)) {
          taskNode.add(TreeNode(key: subtask.id, data: subtask));
        }
      }
    }
  }

  clearTree() {
    root.value.clear();
  }
}
