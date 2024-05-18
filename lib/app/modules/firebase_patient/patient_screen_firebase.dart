/* // ignore_for_file: camel_case_types
import 'package:doctor/app/core/shared/utils/app_colors.dart';
import 'package:doctor/app/core/shared/utils/show_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../core/shared/utils/app_images.dart';
import '../../core/shared/widgets/app_text.dart';
import '../patient/patient_controller.dart';
import 'patientSearch.dart';
import 'patient_card_firebase.dart';
import 'patient_details_firebase.dart';

class PatientScreenFirebase extends StatelessWidget {
  // final PatientController patientController = Get.put(PatientController());
  final PatientController patientFirebase = Get.put(PatientController());
  PatientScreenFirebase({super.key});
  @override
  Widget build(BuildContext context) {
    patientFirebase.getPatientData();
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      appBar: _buildAppBar(context),
      body: GetBuilder(
        init: PatientController(),
        // init: PatientControllerServer(),
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // patientController.allPatientList.isEmpty
              //     ? const SizedBox()
              //     : Obx(() {
              //         return App_Text(
              //           data:
              //               'اجمالي عدد الحالات :  ${patientController.allPatientList.length}',
              //           color: AppColors.kTeal5,
              //         );
              //       }),
              // patientController.allPatientTest.isEmpty
              patientFirebase.allPatientList.isEmpty
                  ? const SizedBox()
                  : App_Text(
                      data:
                          // 'اجمالي عدد الحالات :  ${patientController.allPatientTest.length}',
                          'اجمالي عدد الحالات :  ${patientFirebase.allPatientList.length}',
                      color: AppColors.kTeal5,
                    ),
              Expanded(
                child: Obx(
                  () {
                    // if (patientController.isLoading.value) {
                    if (patientFirebase.isLoading.value) {
                      return const ShowLoading();
                    } else {
                      // return patientController.allPatientTest.isNotEmpty
                      return patientFirebase.allPatientList.isNotEmpty
                          ? LiquidPullToRefresh(
                              color: AppColors.kTeal,
                              backgroundColor: AppColors.kWhite,
                              showChildOpacityTransition: false,
                              // onRefresh: patientController.getPatientData,
                              // onRefresh: patientController
                              //     .getPatientDataFromLocaleServer,
                              onRefresh: patientFirebase.getPatientData,
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount:
                                    // patientController.allPatientTest.length,
                                    patientFirebase.allPatientList.length,
                                itemBuilder: (context, index) {
                                  final student =
                                      // patientController.allPatientTest[index];
                                      patientFirebase.allPatientList[index];
                                  var date = PatientController.formatDate(
                                      student.createdAt!.toDate());
                                  bool isNewDay = index == 0 ||
                                      student.createdAt!.toDate().day !=
                                          // patientController
                                          //     .allPatientTest[index - 1]
                                          patientFirebase
                                              .allPatientList[index - 1]
                                              .createdAt!
                                              .toDate()
                                              .day;
                                  return GestureDetector(
                                    onDoubleTap: () => Get.to(
                                      () => PatientDetailFirebase(
                                          patient: student),
                                    ),
                                    // child: patientController
                                    //         .allPatientTest.isEmpty
                                    child: patientFirebase
                                            .allPatientList.isEmpty
                                        ? const ShowLoading()
                                        : Column(
                                            children: [
                                              if (isNewDay)
                                                Column(
                                                  children: [
                                                    const SizedBox(height: 10),
                                                    DecoratedBox(
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: AppColors.kTeal4,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  20),
                                                          topLeft:
                                                              Radius.circular(
                                                                  20),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  20),
                                                        ),
                                                      ),
                                                      child: App_Text(
                                                        data: date,
                                                        paddingHorizontal:
                                                            10.sp,
                                                        paddingVertical: 7.sp,
                                                        size: 15.sp,
                                                        color: AppColors.kWhite,
                                                      ),
                                                    ),
                                                    const Divider(
                                                      thickness: 3,
                                                      endIndent: 30,
                                                      indent: 30,
                                                      color: AppColors.kTeal,
                                                    ),
                                                  ],
                                                ),
                                              PatientCardFirebase(
                                                patient: student,
                                                index: index,
                                                onDelete: () {
                                                  // Delete the client
                                                  Get.defaultDialog(
                                                      onConfirm: () async {
                                                        await patientFirebase
                                                            .deleteDocumentAndImage(
                                                                student.id!
                                                                    .toString());
                                                        Get.back(
                                                            closeOverlays:
                                                                true);
                                                      },
                                                      onCancel: () =>
                                                          Get.back(),
                                                      middleText:
                                                          "هل تريد حذف هذه الحالة",
                                                      title: 'انتبة');
                                                },
                                                onEdit: () {
                                                  // showDialog(
                                                  //   context: context,
                                                  //   builder: (_) =>
                                                  //       EditPatientDialog(
                                                  //           patient: student),
                                                  // );
                                                },
                                              ),
                                            ],
                                          ),
                                  );
                                },
                              ),
                            )
                          : const _buildNoData();
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _buildNoData extends StatelessWidget {
  const _buildNoData({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            height: Get.height * .6,
            decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage(AppImages.noData))),
          ),
          const App_Text(
            data: 'لا يوجد لديك حالات حتى الان',
            size: 18,
            color: AppColors.kTeal,
          ),
        ],
      ),
    );
  }
}

AppBar _buildAppBar(BuildContext context) {
  return AppBar(
    centerTitle: true,
    automaticallyImplyLeading: false,
    backgroundColor: AppColors.kTeal,
    title: const App_Text(
      data: " الحالات القديمة",
      size: 20,
      color: AppColors.kWhite,
    ),
    actions: [
      Padding(
        padding: EdgeInsets.only(right: 20.r),
        child: GestureDetector(
          onTap: () {
            showSearch(context: context, delegate: PatientSearchFirebase());
          },
          child: Image.asset(
            AppImages.iconSearch,
            fit: BoxFit.fitHeight,
            color: AppColors.kWhite,
            // height: 280,
          ),
        ),
      )
    ],
  );
}
 */