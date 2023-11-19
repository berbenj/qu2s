import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// Firebase
import 'package:firedart/firedart.dart';

import 'download_page.dart';
import 'version.dart';

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
    Firestore.initialize('qu2s-596fc');
    FirebaseAuth.initialize('AIzaSyCFfMcpev4TWt3yst8pNID9Qicu6vX8Q9E', VolatileStore());
    debugPrint('Connected to Firebase Database and Authentication');
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
    if (isLoaded) {
      if (kIsWeb) {
        return MaterialApp(
          home: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 0,
                bottom: const PreferredSize(
                    preferredSize: Size.fromHeight(kBottomNavigationBarHeight),
                    child: TabBar(tabs: [Tab(text: 'Home'), Tab(text: 'Download')])),
              ),
              body: TabBarView(
                children: [HomePage(seconds: seconds), const DownloadPage()],
              ),
            ),
          ),
        );
      } else {
        return MaterialApp(
          home: DefaultTabController(
            length: 1,
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 0,
                bottom: const PreferredSize(
                    preferredSize: Size.fromHeight(kBottomNavigationBarHeight),
                    child: TabBar(tabs: [Tab(text: 'Home')])),
              ),
              body: TabBarView(
                children: [HomePage(seconds: seconds)],
              ),
            ),
          ),
        );
      }
    } else {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: SpinKitDancingSquare(
              color: Colors.black,
            ),
          ),
        ),
      );
    }
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.seconds,
  });

  final String seconds;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(seconds),
      ),
    );
  }
}
