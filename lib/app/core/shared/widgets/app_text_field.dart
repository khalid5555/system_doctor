// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, use_key_in_widget_constructors
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class AppTextField extends StatelessWidget {
  final String? hint;
  final String? lab;
  final bool obscureText;
  final Color? color;
  final int? min;
  final FocusNode? focusNode;
  final IconData? icon;
  final TextEditingController? myController;
  final TextInputType? textInputType;
  final Function(String?)? onClick;
  final Function(String?)? onChange;
  final Function(String?)? onSubmit;
  AppTextField({
    Key? key,
    this.hint,
    this.lab,
    this.obscureText = false,
    this.color = AppColors.kWhite,
    this.min = 1,
    required this.icon,
    this.myController,
    this.textInputType,
    this.onClick,
    this.onChange,
    this.onSubmit,
    this.focusNode,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: myController,
      maxLines: min,
      // ignore: missing_return
      validator: (value) {
        if (value!.isEmpty) {
          return 'الرجاء ملىء الحقل';
        }
        return null;
      },
      onSaved: onClick,
      onEditingComplete: () {
        FocusScope.of(context).nextFocus(); // انتقل إلى الحقل التالي
      },
      onFieldSubmitted: onSubmit,
      // onChanged: (value) => onChange!(value),
      keyboardType: textInputType,
      textAlign: TextAlign.end,
      style: TextStyle(fontSize: 13, color: AppColors.kBlACK),
      cursorColor: AppColors.kbiNK,
      obscureText: obscureText,
      focusNode: focusNode,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.kTheFirstAPP),
        filled: true,
        labelText: lab,
        labelStyle: TextStyle(
          color: AppColors.kTeal,
        ),
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14, color: color),
        fillColor: Colors.grey[200],
        enabledBorder: OutlineInputBorder(
          gapPadding: 0,
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.kTeal),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.kbiNK,
          ),
        ),
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(10),
        //   borderSide: BorderSide(
        //     color: Colors.white,
        //   ),
        // ),
      ),
    );
  }
}
