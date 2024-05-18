import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/app_text.dart';
import 'app_colors.dart';

class ShowLoading extends StatelessWidget {
  final bool show;
  const ShowLoading({
    Key? key,
    this.show = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        App_Text(
          data: show ? 'اكتب ما تريد البحث عنه' : "الرجاء الإنتظار ",
          color: Get.isDarkMode ? AppColors.kWhite : AppColors.kTeal,
        ),
        const SizedBox(height: 15),
        Center(
          child: CircularProgressIndicator(
            color: Get.isDarkMode ? AppColors.kCyan : AppColors.kbiNK,
          ),
        ),
      ],
    );
  }
}
/* Widget buildProgressIndicator(DownloadProgress downloadProgress) {
  double progressPercent =
      downloadProgress.progress != null ? downloadProgress.progress! * 100 : 0;
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const App_Text(data: "الرجاء الإنتظار "),
      const SizedBox(height: 10),
      CircularProgressIndicator(
        value: downloadProgress.progress,
        color: AppColors.kScColor,
        backgroundColor: AppColors.kWhite,
      ),
      const SizedBox(height: 10),
      App_Text(
        size: 9,
        data: "${progressPercent.toStringAsFixed(0)} %",
      ),
    ],
  );
} */
