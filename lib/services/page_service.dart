import 'package:flutter/material.dart';
import '../core/content.dart';

class PageService {
  final Content<int> mainScreenIndex = Content(1);

  final Content<int> userScreenIndex = Content(0);

  final Content<int> taskScreenIndex = Content(0);
  final Content<Widget> taskScreenRightWidget = Content(const SizedBox());
}
