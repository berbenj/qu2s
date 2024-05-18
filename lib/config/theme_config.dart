import 'package:flutter/material.dart';

class ThemeConfig {
  static const _Color _color = _Color();
  static get color => _color;

  static const _TextStyle _textStyle = _TextStyle();
  static get textStyle => _textStyle;
}

class _Color {
  const _Color();
  get accent => Colors.teal.shade300;
  get onAccent => Colors.grey.shade900;
}

class _TextStyle {
  const _TextStyle();
  TextStyle get sectionHeader => const TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
}
