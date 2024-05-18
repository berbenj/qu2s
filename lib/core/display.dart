import 'package:flutter/material.dart';
import 'content.dart';

typedef DisplayCondition = bool Function();

class Display extends StatelessWidget {
  final List<Content<dynamic>> contents;
  final DisplayCondition? condition;
  final TransitionBuilder builder;

  const Display({
    super.key,
    required this.contents,
    this.condition,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(contents),
      builder: (context, child) {
        Widget widget = buildWidget(context, child);
        return AnimatedSwitcher(
          duration: const Duration(seconds: 3),
          transitionBuilder: (child, animation) {
            if (condition?.call() == false) {
              return const SizedBox();
            }
            return builder(context, child);
          },
          child: widget,
        );
      },
    );
  }

  Widget buildWidget(BuildContext context, Widget? child) {
    if (condition?.call() == false) {
      return const SizedBox();
    }
    return builder(context, child);
  }
}
