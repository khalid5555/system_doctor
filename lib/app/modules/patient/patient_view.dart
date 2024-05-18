import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../core/shared/utils/app_colors.dart';
import '../../core/shared/utils/app_images.dart';
import '../../core/shared/utils/show_loading.dart';
import '../../core/shared/widgets/app_text.dart';
import '../../core/widgets/patient_card.dart';
import 'edit_patient_page.dart';
import 'patientSearchDelegate.dart';
import 'patient_controller_server.dart';
import 'patient_details.dart';

class PatientScreen extends StatelessWidget {
  // final PatientController patientController = Get.put(PatientController());
  final PatientControllerServer patientController =
      Get.put(PatientControllerServer());
  PatientScreen({super.key});
  @override
  Widget build(BuildContext context) {
    patientController.getPatientDataServer();
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      /*     floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.kTeal,
          onPressed: () {
            // Show dialog to add a client
            Get.to(() => const AddPatient());
          },
          label: const App_Text(
            data: "اضافة حالة",
            color: AppColors.kWhite,
          )), */
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.kTeal,
        title: const App_Text(
          data: "بيانات الحالات",
          size: 20,
          color: AppColors.kWhite,
        ),
        leadingWidth: 100,
        leading: Image.asset(
          AppImages.home_icon,
          fit: BoxFit.contain,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.r),
            child: GestureDetector(
              onTap: () {
                showSearch(context: context, delegate: PatientSearchDelegate());
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
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.home_day),
            opacity: .06,
            fit: BoxFit.fill,
          ),
        ),
        child: GetBuilder(
          // init: PatientController(),
          init: PatientControllerServer(),
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
                patientController.allPatientList.isEmpty
                    ? const SizedBox()
                    : App_Text(
                        data:
                            'اجمالي عدد الحالات :  ${patientController.allPatientList.length}',
                        color: AppColors.kTeal5,
                      ),
                Expanded(
                  child: Obx(
                    () {
                      if (patientController.isLoading.value) {
                        return const ShowLoading();
                      } else {
                        return patientController.allPatientList.isNotEmpty
                            ? LiquidPullToRefresh(
                                color: AppColors.kTeal,
                                backgroundColor: AppColors.kWhite,
                                showChildOpacityTransition: false,
                                // onRefresh: patientController.getPatientData,
                                onRefresh:
                                    patientController.getPatientDataServer,
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount:
                                      patientController.allPatientList.length,
                                  itemBuilder: (context, index) {
                                    final student =
                                        patientController.allPatientList[index];
                                    var date =
                                        PatientControllerServer.formatDate(
                                            student.createdAt!);
                                    bool isNewDay = index == 0 ||
                                        student.createdAt!.day !=
                                            patientController
                                                .allPatientList[index - 1]
                                                .createdAt!
                                                // .toDate()
                                                .day;
                                    return GestureDetector(
                                      onDoubleTap: () => Get.to(
                                        () =>
                                            PatientDetailPage(patient: student),
                                      ),
                                      child: patientController
                                              .allPatientList.isEmpty
                                          ? const ShowLoading()
                                          : Column(
                                              children: [
                                                if (isNewDay)
                                                  Column(
                                                    children: [
                                                      const SizedBox(
                                                          height: 10),
                                                      DecoratedBox(
                                                        decoration:
                                                            const BoxDecoration(
                                                          color:
                                                              AppColors.kTeal4,
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
                                                          data: date.toString(),
                                                          paddingHorizontal:
                                                              10.sp,
                                                          paddingVertical: 7.sp,
                                                          size: 15.sp,
                                                          color:
                                                              AppColors.kWhite,
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
                                                PatientCard(
                                                  patient: student,
                                                  index: index,
                                                  onDelete: () {
                                                    // Delete the client
                                                    Get.defaultDialog(
                                                        onConfirm: () async {
                                                          await patientController
                                                              .deleteDocumentAndImage(
                                                                  student.id!
                                                                      .toString());
                                                          Get.until((route) =>
                                                              !Get.isDialogOpen!);
                                                        },
                                                        onCancel: () => Get.until(
                                                            (route) => !Get
                                                                .isOverlaysClosed),
                                                        middleText:
                                                            "هل تريد حذف هذه الحالة",
                                                        title: 'انتبة');
                                                  },
                                                  onEdit: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (_) =>
                                                          EditPatientDialog(
                                                              patient: student),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                    );
                                  },
                                ),
                              )
                            : Align(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Container(
                                      height: Get.height * .6,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  AppImages.noData))),
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
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
