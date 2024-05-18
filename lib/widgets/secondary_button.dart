import 'package:flutter/material.dart';
import '../config/theme_config.dart';

class SecondaryButton extends StatelessWidget {
  final String label;
  final void Function() onPressed;
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: const ButtonStyle(
        shadowColor: MaterialStatePropertyAll(Colors.black),
        elevation: MaterialStatePropertyAll(2),
      ),
      child: Text(
        label,
        style: TextStyle(color: ThemeConfig.color.accent),
      ),
    );
  }
}
