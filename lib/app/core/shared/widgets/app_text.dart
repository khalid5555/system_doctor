// ignore_for_file: non_constant_identifier_names, camel_case_types
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class App_Text extends StatelessWidget {
  final String data;
  final Color? color;
  final double? size;
  final double? height;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final int? maxLine;
  final TextDecoration? decoration;
  final TextOverflow? overflow;
  final TextDirection? direction;
  final double paddingHorizontal;
  final double paddingVertical;
  const App_Text({
    Key? key,
    required this.data,
    this.color,
    this.size = 14,
    this.fontWeight = FontWeight.bold,
    this.fontFamily,
    this.maxLine,
    this.decoration,
    this.overflow = TextOverflow.ellipsis,
    this.direction = TextDirection.rtl,
    this.paddingHorizontal = 0,
    this.paddingVertical = 0,
    this.height,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: paddingHorizontal, vertical: paddingVertical),
      child: Text(
        maxLines: maxLine,
        data,
        textDirection: direction,
        selectionColor: Colors.tealAccent,
        style: TextStyle(
          decoration: decoration,
          overflow: overflow,
          color: color,
          fontSize: size!.sp,
          height: height,
          fontWeight: fontWeight,
          fontFamily: fontFamily,
        ),
      ),
    );
  }
}
