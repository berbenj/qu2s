import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// Firebase
import 'package:firedart/firedart.dart';

import 'download_tab.dart';
import 'user_tab.dart';
import 'version.dart';
import 'home_tab.dart';

const apiKey = 'AIzaSyBkO05UO2PHQvgfAnobGZjmhpa6-yrtm-I';
const projectId = 'qu2s-596fc';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool isLoaded = false;
  String seconds = '';

  Timer? _clockTimer;

  void _setSecond() {
    setState(() {
      seconds = DateTime.now().second.toString();
    });
  }

  void connectToDatabase() async {
    Firestore.initialize(projectId);
    FirebaseAuth.initialize(apiKey, VolatileStore());
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();

    connectToDatabase();

    _clockTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) => _setSecond());
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var themeData = ThemeData(
        brightness: Brightness.dark, colorSchemeSeed: const Color.fromARGB(255, 0, 0, 255), fontFamily: 'Fira Code');

    var pages = <String, Widget>{"Home": const HomeTab(), "User": const UserTab()};
    if (kIsWeb) {
      pages["Download"] = const DownloadTab();
    }

    if (isLoaded) {
      return MaterialApp(
        theme: themeData,
        home: Stack(
          children: [
            DefaultTabController(
              length: pages.length,
              child: Scaffold(
                appBar: AppBar(
                  toolbarHeight: 0,
                  bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(kBottomNavigationBarHeight),
                      child: TabBar(tabs: [for (var pageName in pages.keys) Tab(text: pageName)])),
                ),
                body: TabBarView(
                  children: [for (var page in pages.values) page],
                ),
              ),
            ),
            const Positioned(
                bottom: 0,
                child: Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Text(
                    version,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Fira Code',
                      fontWeight: FontWeight.normal,
                      fontSize: 10,
                      decoration: TextDecoration.none,
                    ),
                  ),
                )),
          ],
        ),
      );
    } else {
      return MaterialApp(
        theme: themeData,
        home: const Scaffold(
          body: Center(
            child: SpinKitDancingSquare(
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }
}
