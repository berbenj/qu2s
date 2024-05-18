import 'package:firedart/auth/firebase_auth.dart';
import 'package:firedart/auth/user_gateway.dart';
import '../core/content.dart';
import '../pages/tasks/task_tree_controller.dart';
import 'database_service.dart';

class UserService {
  final Content<bool> _isLoggedIn = Content(false);
  Content<bool> get isLoggedIn => _isLoggedIn;
  final Content<User?> user = Content(null);

  final DatabaseService databaseService;
  final TasksTreeController tasksController;

  UserService({required this.databaseService, required this.tasksController});

  login() async {
    await databaseService.login();
    user.value = await FirebaseAuth.instance.getUser();
    _isLoggedIn.value = true;

    tasksController.updateTreeFromDatabase();
  }

  regist() {
    _isLoggedIn.value = true;

    tasksController.updateTreeFromDatabase();
  }

  logout() async {
    await databaseService.logout();
    _isLoggedIn.value = false;
  }
}
