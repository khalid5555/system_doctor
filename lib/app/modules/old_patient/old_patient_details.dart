// ignore_for_file: must_be_immutable
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor/app/core/shared/utils/show_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_zoom_on_move/image_zoom_on_move.dart';

import '../../core/shared/utils/app_colors.dart';
import '../../core/shared/utils/constants.dart';
import '../../core/shared/widgets/app_text.dart';
import '../../data/models/patient_model.dart';

class OldPatientDetails extends StatelessWidget {
  final PatientModel patient;
  // final Record patient;
  const OldPatientDetails({Key? key, required this.patient}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConst.recolor(),
        centerTitle: true,
        title: const Text('تفاصيل الحالة'),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              App_Text(
                data: 'رقم الحالة : ${patient.id /* .substring(0, 12) */}',
                size: 12,
                direction: TextDirection.rtl,
              ),
              App_Text(
                data:
                    'تاريخ الاضافة : ${'${patient.createdAt!.toDate().day} : ${patient.createdAt!.toDate().month} : ${patient.createdAt!.toDate().year}'} ',
                size: 12,
                maxLine: 2,
              ),
              App_Text(
                data: "تاريخ الكشف : ${patient.date}",
                size: 13,
                color: AppColors.kTeal,
                maxLine: 2,
              ),
              SizedBox(height: 5.h),
              (patient.rays == null /* && patient.analysis == null */)
                  ? const SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /*  patient.analysis == ""
                            ? const SizedBox()
                            : InkWell(
                                onTap: () {
                                  Get.to(() => ImageZoomScreen(
                                      imageUrl: '${patient.analysis}'));
                                },
                                child: /*  patient.analysis == ""
                              ? const ShowLoading()
                              : */
                                    Container(
                                  height: 170.h,
                                  width: 165.w,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                        color: AppColors.kTeal,
                                        offset: Offset(0, 2),
                                      )
                                    ],
                                    border: Border.all(color: AppColors.kTeal),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(22)),
                                    color: AppColors.kBlue,
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: '${patient.analysis}',
                                    fit: BoxFit.fill,
                                    fadeInCurve: Curves.bounceOut,
                                    placeholder: (context, url) =>
                                        const ShowLoading(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                        SizedBox(width: 5.w), */
                        patient.rays!.isEmpty
                            ? const SizedBox()
                            : SizedBox(
                                height: 180.h,
                                width: Get.width - 25,
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: patient.rays!.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Get.to(() => ImageZoomScreen(
                                            isFile: true,
                                            imageUrl: patient.rays![index]));
                                      },
                                      child: Container(
                                        height: 170.h,
                                        width: 165.w,
                                        margin: const EdgeInsets.only(right: 8),
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          boxShadow: const [
                                            BoxShadow(
                                              color: AppColors.kTeal,
                                              offset: Offset(0, 5),
                                            )
                                          ],
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(22)),
                                          color: AppColors.kBlue,
                                          border: Border.all(
                                              color: AppColors.kTeal),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: patient.rays![index],
                                          fit: BoxFit.fill,
                                          fadeInCurve: Curves.bounceOut,
                                          placeholder: (context, url) =>
                                              const ShowLoading(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ],
                    ),
              const Divider(
                indent: 80,
                height: 14,
                endIndent: 80,
                color: Colors.teal,
              ),
              App_Text(
                data: 'معلومات الحالة: \n${patient.name}',
                color: Colors.redAccent,
                maxLine: 50,
                size: 16,
                direction: TextDirection.rtl,
              ),
              // const Divider(
              //   // indent: 10,
              //   height: 12,
              //   thickness: 2,
              //   endIndent: 50,
              //   color: AppColors.kWeatherBG,
              // ),
              // App_Text(
              //   data: 'العنوان : ${patient.name!.split(' ')[2]}',
              //   size: 12,
              //   maxLine: 4,
              // ),
              // App_Text(
              //   data: 'سن الحالة: ${patient.name!.split(' ')[1]}',
              //   size: 12,
              //   maxLine: 2,
              // ),
              /*  App_Text(
                data: 'رقم الهاتف: ${patient.phone}',
                size: 12,
                maxLine: 2,
              ), */
              Divider(
                // indent: 80,
                // height: 12,
                thickness: 4,
                endIndent: 50,
                color: AppConst.recolor(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      App_Text(
                        data: 'التشخيص : \n${patient.details}',
                        size: 16,
                        maxLine: 1000000000000,
                        color: AppColors.kTheFirstAPP,
                        direction: TextDirection.rtl,
                      ),
                      /*  const Divider(
                        indent: 80,
                        height: 12,
                        thickness: 2,
                        endIndent: 90,
                        color: AppColors.kWeatherBG,
                      ),
                      App_Text(
                        data: 'العلاج : \n${patient.therapy}',
                        size: 14,
                        maxLine: 1000000000000,
                        color: AppColors.kTeal,
                        direction: TextDirection.rtl,
                      ), */
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageZoomScreen extends StatefulWidget {
  String imageUrl;
  bool? isFile = true;
  ImageZoomScreen({super.key, required this.imageUrl, this.isFile});
  @override
  _ImageZoomScreenState createState() => _ImageZoomScreenState();
}

class _ImageZoomScreenState extends State<ImageZoomScreen> {
  bool isZoomed = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.kBlACK,
        body: GestureDetector(
          onTap: () {
            setState(() {
              isZoomed = !isZoomed;
            });
          },
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(12),
              height: Get.height,
              width: Get.width,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.kTeal,
                    offset: Offset(0, 5),
                  )
                ],
                borderRadius: const BorderRadius.all(Radius.circular(22)),
                color: AppColors.kBlue,
                border: Border.all(color: AppColors.kTeal),
              ),
              child: widget.imageUrl.isEmpty
                  ? const ShowLoading()
                  : (widget.isFile!
                      ? ImageZoomOnMove(
                          cursor: SystemMouseCursors.grab,
                          image: Image.network(
                            // "https://fagaskwt.com/public/${widget.imageUrl}",
                            widget.imageUrl,
                            fit: BoxFit.fill,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return const ShowLoading();
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error),
                          ),
                        )
                      : ImageZoomOnMove(
                          cursor: SystemMouseCursors.grab,
                          image: Image.file(
                            File(widget.imageUrl),
                            fit: BoxFit.fill,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error),
                          ),
                        )),
            ),
          ),
        ),
      ),
    );
  }
}
