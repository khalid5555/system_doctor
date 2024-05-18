// ignore_for_file: constant_identifier_names, deprecated_member_use

import 'dart:math';

import 'package:flutter/material.dart';

class AppConst {
  static const double defaultPadding = 16.0;
  static const Duration defaultDuration = Duration(milliseconds: 400);
  static final color = Random();
  static int colors = 0xff000000;
  static const String font_family = 'molham_bold';
  static Color recolor() {
    return Color(color.nextInt(colors));
  }

  Size getScreenSize() {
    return MediaQueryData.fromView(WidgetsBinding.instance.window).size;
  }
}
