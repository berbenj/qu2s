import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firedart/auth/user_gateway.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';
import '../utils/log.dart';
import '../utils/platform.dart';

class DatabaseService {
  static String apiKey = 'AIzaSyBkO05UO2PHQvgfAnobGZjmhpa6-yrtm-I';
  static String projectId = 'qu2s-596fc';

  static bool _isInitialized = false;

  static User? user;

  static init() async {
    if (!_isInitialized) {
      /// initialize Firebase Firestore Database
      if (Q2Platform.isWindows) {
        Firestore.initialize(projectId);
      } else {
        WidgetsFlutterBinding.ensureInitialized();
        await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      }

      /// initialize Firebase Auth
      FirebaseAuth.initialize(apiKey, VolatileStore());

      _isInitialized = true;
    }
  }

  get fdUserData => Firestore.instance.collection('users').document(user!.id);
  get fsUserData => FirebaseFirestore.instance.collection('users').doc(user!.id);

  login() async {
    if (_isInitialized) {
      user = await FirebaseAuth.instance.signIn('test@qu2s.com', '123456');
      log('Logged in as ${user!.displayName ?? user!.id}');
    }
  }

  logout() async {
    if (_isInitialized) {
      FirebaseAuth.instance.signOut();
      log('Logged out');
    }
  }
}
