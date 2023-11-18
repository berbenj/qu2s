import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firedart/firedart.dart' as firedart;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter/foundation.dart';

const String version = 'v0.0.0::01';

void main() {
  connectToDatabase();
  runApp(const MainApp());
}

void connectToDatabase() async {
  if (kIsWeb) {
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } else if (defaultTargetPlatform == TargetPlatform.windows) {
    firedart.Firestore.initialize('qu2s-596fc');
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String seconds = '';

  Timer? _clockTimer;

  void _setSecond() {
    setState(() {
      seconds = DateTime.now().second.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) => _setSecond());
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(seconds),
        ),
      ),
    );
  }
}
