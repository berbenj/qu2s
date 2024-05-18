import 'package:flutter/material.dart';
import '../../config/theme_config.dart';
import '../../core/display.dart';
import '../../core/ioc.dart';
import '../../services/page_service.dart';
import '../../services/user_service.dart';
import '../../utils/platform.dart';

import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button.dart';

class UserScreen extends StatelessWidget {
  UserScreen({
    super.key,
  });

  final userService = IoC.get<UserService>();
  final pageService = IoC.get<PageService>();

  @override
  Widget build(BuildContext context) {
    return Display(
      contents: [userService.isLoggedIn],
      builder: (_, __) {
        if (userService.isLoggedIn.value) {
          return LoggedInScreen();
        } else {
          if (Q2Platform.isAndroid) {
            return Display(
              contents: [pageService.userScreenIndex],
              builder: (_, __) => Center(
                child: [
                  LoginForm(),
                  RegistForm(),
                ][pageService.userScreenIndex.value],
              ),
            );
          } else {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RegistForm(),
                  const SizedBox(width: 50),
                  LoginForm(),
                ],
              ),
            );
          }
        }
      },
    );
  }
}

class LoggedInScreen extends StatelessWidget {
  LoggedInScreen({
    super.key,
  });

  final userService = IoC.get<UserService>();

  @override
  Widget build(BuildContext context) {
    return Display(
      contents: [userService.user],
      builder: (_, __) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You are logged in as ${userService.user.value?.email ?? '???'}!'),
            const SizedBox(height: 30),
            PrimaryButton(
              onPressed: () {
                userService.logout();
              },
              label: 'Logout',
            ),
            const SizedBox(height: 30),
            SecondaryButton(
              onPressed: () {},
              label: 'Export events as iCalendar',
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  LoginForm({
    super.key,
  });

  final userService = IoC.get<UserService>();
  final pageService = IoC.get<PageService>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Login',
            style: ThemeConfig.textStyle.sectionHeader,
          ),
          const TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(label: Text('  Username')),
          ),
          const TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(label: Text('  Password')),
            obscureText: true,
          ),
          const SizedBox(height: 30),
          if (Q2Platform.isAndroid) ...[
            TextButton(
              onPressed: () {
                pageService.userScreenIndex.value = 1;
              },
              child: Text(
                'go to registration instead',
                style: TextStyle(color: ThemeConfig.color.accent),
              ),
            ),
          ],
          PrimaryButton(
            onPressed: () {
              userService.login();
              pageService.mainScreenIndex.value = 1;
            },
            label: 'Login',
          ),
        ],
      ),
    );
  }
}

class RegistForm extends StatelessWidget {
  RegistForm({
    super.key,
  });

  final userService = IoC.get<UserService>();
  final pageService = IoC.get<PageService>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Regist',
            style: ThemeConfig.textStyle.sectionHeader,
          ),
          const TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(label: Text('  Username')),
          ),
          const TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(label: Text('  Password')),
            obscureText: true,
          ),
          const TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(label: Text('  Password again')),
            obscureText: true,
          ),
          const SizedBox(height: 30),
          if (Q2Platform.isAndroid) ...[
            TextButton(
              onPressed: () {
                pageService.userScreenIndex.value = 0;
              },
              child: Text(
                'go to login instead',
                style: TextStyle(color: ThemeConfig.color.accent),
              ),
            ),
          ],
          PrimaryButton(
            onPressed: () {
              userService.regist();
              pageService.mainScreenIndex.value = 1;
              pageService.userScreenIndex.value = 1;
            },
            label: 'Regist',
          ),
        ],
      ),
    );
  }
}
