import 'package:flutter/material.dart';
import 'core/display.dart';
import 'config/theme_config.dart';
import 'core/ioc.dart';
import 'services/database_service.dart';
import 'services/page_service.dart';
import 'services/user_service.dart';
import 'pages/events/events_screen.dart';
import 'pages/tasks/task_screen.dart';
import 'pages/user/user_screen.dart';

void main() async {
  await DatabaseService.init();
  IoC.init();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final userService = IoC.get<UserService>();
  final pageService = IoC.get<PageService>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'qu2s',
      theme: ThemeData.dark(),
      home: Display(
        contents: [pageService.mainScreenIndex, userService.isLoggedIn],
        builder: (_, __) {
          if (userService.isLoggedIn.value) {
            return Scaffold(
              bottomNavigationBar: NavigationBar(
                indicatorColor: ThemeConfig.color.accent,
                selectedIndex: pageService.mainScreenIndex.value,
                onDestinationSelected: (value) {
                  pageService.mainScreenIndex.value = value;
                },
                destinations: [
                  if (userService.isLoggedIn.value) ...[
                    NavigationDestination(
                      icon: const Icon(Icons.task_alt),
                      selectedIcon: Icon(Icons.task_alt, color: ThemeConfig.color.onAccent),
                      label: 'Tasks',
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.calendar_month),
                      selectedIcon: Icon(Icons.calendar_month, color: ThemeConfig.color.onAccent),
                      label: 'Events',
                    ),
                  ],
                  NavigationDestination(
                    icon: const Icon(Icons.settings),
                    selectedIcon: Icon(Icons.settings, color: ThemeConfig.color.onAccent),
                    label: 'Options',
                  ),
                ],
              ),
              body: Padding(
                padding: MediaQuery.viewPaddingOf(context),
                child: [
                  // todo: dont rebuild pages on page change, use the same one every time, so that in progress stuff stays
                  TaskScreen(),
                  EventsScreen(),
                  UserScreen(),
                  // todo: add download page on web
                ][pageService.mainScreenIndex.value],
              ),
            );
          } else {
            return Scaffold(
              body: UserScreen(),
            );
          }
        },
      ),
    );
  }
}
