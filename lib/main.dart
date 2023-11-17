import 'package:flutter/material.dart';
import 'package:firedart/firedart.dart' as firedart;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter/foundation.dart';

const String version = 'v0.0.0::06';

void main() {
  connectToDatabase();
  runApp(const MainApp());
}

void connectToDatabase() async {
  if (kIsWeb) {
    // FirebaseAuth.initialize('AIzaSyBkO05UO2PHQvgfAnobGZjmhpa6-yrtm-I', fd.VolatileStore());

    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } else if (defaultTargetPlatform == TargetPlatform.windows) {
    //   fd.FirebaseAuth.initialize('AIzaSyBkO05UO2PHQvgfAnobGZjmhpa6-yrtm-I', fd.VolatileStore());
    firedart.Firestore.initialize('qu2s-596fc');
    // } else {
    //   // todo: implement for android
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
