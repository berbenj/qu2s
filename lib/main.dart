import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// Firebase
import 'package:firedart/firedart.dart' as firedart; // for windows
import 'package:firebase_core/firebase_core.dart' as firebase; // for web and android
import 'package:firedart/auth/firebase_auth.dart' as firebase; // for web and android
import 'firebase_options.dart';

// the version of the whole application qu2s
// {major}.{minor}.{patch}::{development}
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
      firebase.Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      firebase.FirebaseAuth.initialize('AIzaSyCFfMcpev4TWt3yst8pNID9Qicu6vX8Q9E', firedart.VolatileStore());
      debugPrint('Connected to Firebase Database and Authentication');
      setState(() {
        isLoaded = true;
      });
    } else if (defaultTargetPlatform == TargetPlatform.windows) {
      firedart.Firestore.initialize('qu2s-596fc');
      firedart.FirebaseAuth.initialize('AIzaSyCFfMcpev4TWt3yst8pNID9Qicu6vX8Q9E', firedart.VolatileStore());
      debugPrint('Connected to Firebase Database and Authentication');
      setState(() {
        isLoaded = true;
      });
    } else {
      debugPrint('NOT Connected to Firebase Database and Authentication');
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
