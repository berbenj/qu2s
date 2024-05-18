import 'dart:io';

import 'package:flutter/foundation.dart';

class Q2Platform {
  // note(7g94): ALWAYS check `kIsWeb` first!!

  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  static bool get isntAndroid => kIsWeb || !Platform.isAndroid;

  static bool get isWeb => kIsWeb;
  static bool get isntWeb => !kIsWeb;

  static bool get isWindows => !kIsWeb && Platform.isWindows;
  static bool get isntWindows => kIsWeb || !Platform.isWindows;
}
