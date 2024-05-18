import 'package:flutter/material.dart';
import '../config/theme_config.dart';

class PrimaryButton extends StatelessWidget {
  final Function() onPressed;
  final String label;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(ThemeConfig.color.accent),
        foregroundColor: MaterialStatePropertyAll(ThemeConfig.color.onAccent),
        shadowColor: const MaterialStatePropertyAll(Colors.black),
        elevation: const MaterialStatePropertyAll(5),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
