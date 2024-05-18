import 'package:get_it/get_it.dart';
import '../pages/tasks/task_tree_controller.dart';
import '../services/database_service.dart';
import '../services/page_service.dart';
import '../services/user_service.dart';

class IoC {
  IoC._();

  static final GetIt get = GetIt.I;

  static void init() {
    /// controllers
    get.registerSingleton(TasksTreeController());

    /// services
    get.registerSingleton(DatabaseService());
    get.registerSingleton(UserService(databaseService: get(), tasksController: get()));
    get.registerSingleton(PageService());
  }
}
