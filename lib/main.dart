import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firedart/firedart.dart' as firedart;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter/foundation.dart';

const String version = 'v0.0.0::03';

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
    if (kIsWeb || defaultTargetPlatform == TargetPlatform.android) {
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      debugPrint('Connected to Database');
      setState(() {
        isLoaded = true;
      });
    } else if (defaultTargetPlatform == TargetPlatform.windows) {
      firedart.Firestore.initialize('qu2s-596fc');
      debugPrint('Connected to Database');
      setState(() {
        isLoaded = true;
      });
    } else {
      debugPrint('NOT Connected to Database');
    }
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
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text(seconds),
          ),
        ),
      );
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
