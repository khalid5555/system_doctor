// ignore_for_file: camel_case_types
import 'package:doctor/app/core/shared/utils/app_colors.dart';
import 'package:doctor/app/core/shared/utils/show_loading.dart';
import 'package:doctor/app/modules/old_patient/old_patientSearch.dart';
import 'package:doctor/app/modules/old_patient/patient_card.dart';
import 'package:doctor/app/modules/patient/patient_controller_server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../core/shared/utils/app_images.dart';
import '../../core/shared/widgets/app_text.dart';
import 'old_patient_details.dart';

class OldPatientScreen extends StatefulWidget {
  const OldPatientScreen({super.key});
  @override
  State<OldPatientScreen> createState() => _OldPatientScreenState();
}

class _OldPatientScreenState extends State<OldPatientScreen> {
  final PatientControllerServer patientController =
      Get.put(PatientControllerServer());
  // final PatientControllerServer patientController =
  @override
  Widget build(BuildContext context) {
    patientController.getPatientOldData();
    // patientFirebase.getPatientData();
    // Get.put(PatientControllerServer()).getPatientOldData();
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      appBar: _buildAppBar(context),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.old),
            opacity: .03,
            fit: BoxFit.fill,
          ),
        ),
        child: GetBuilder(
          // init: PatientController(),
          init: PatientControllerServer(),
          builder: (ctrl) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ctrl.allPatientOld.isEmpty
                    //     ? const SizedBox()
                    //     : Obx(() {
                    //         return App_Text(
                    //           data:
                    //               'اجمالي عدد الحالات :  ${patientController.allPatientList.length}',
                    //           color: AppColors.kTeal5,
                    //         );
                    //       }),
                    // patientController.allPatientTest.isEmpty
                    // patientFirebase.allPatientList.isEmpty
                    ? const SizedBox()
                    : App_Text(
                        data:
                            'اجمالي عدد الحالات :  ${ctrl.allPatientOld.length}',
                        color: AppColors.kTeal5,
                      ),
                Expanded(
                  child: Obx(
                    () {
                      if (ctrl.isLoading.value) {
                        
                        return const ShowLoading();
                      } else {
                        return ctrl.allPatientOld.isNotEmpty
                            // return patientFirebase.allPatientList.isNotEmpty
                            ? LiquidPullToRefresh(
                                color: AppColors.kTeal,
                                backgroundColor: AppColors.kWhite,
                                showChildOpacityTransition: false,
                                // onRefresh: patientController.getPatientData,
                                onRefresh: ctrl.getPatientOldData,
                                // onRefresh: patientFirebase.getPatientData,
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: ctrl.allPatientOld.length,
                                  // patientFirebase.allPatientList.length,
                                  itemBuilder: (context, index) {
                                    final student = ctrl.allPatientOld[index];
                                    var date =
                                        PatientControllerServer.formatDate(
                                            student.createdAt!.toDate());
                                    bool isNewDay = index == 0 ||
                                        student.createdAt!.toDate().day !=
                                            ctrl
                                                .allPatientOld[index - 1]
                                                // patientFirebase
                                                //     .allPatientList[index - 1]
                                                .createdAt!
                                                .toDate()
                                                .day;
                                    return GestureDetector(
                                      onDoubleTap: () => Get.to(
                                        () =>
                                            OldPatientDetails(patient: student),
                                      ),
                                      child: ctrl.allPatientOld.isEmpty
                                          // child: patientFirebase
                                          //         .allPatientList.isEmpty
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
                                                PatientCardServer(
                                                  patient: student,
                                                  index: index,
                                                  onDelete: () {
                                                    // Delete the client
                                                    Get.defaultDialog(
                                                        onConfirm: () async {
                                                          await ctrl.deleteFromOld(
                                                              student.id!
                                                                  .toString());
                                                          Get.until((route) =>
                                                              !Get.isDialogOpen!);
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
    elevation: 0,
    automaticallyImplyLeading: false,
    backgroundColor: AppColors.kTeal,
    title: App_Text(
      data: " الحالات القديمة",
      size: 17.sp,
      color: AppColors.kWhite,
    ),
    leadingWidth: 100,
    leading: Image.asset(
      AppImages.old_icon,
      fit: BoxFit.contain,
    ),
    actions: [
      Padding(
        padding: EdgeInsets.only(right: 20.r),
        child: GestureDetector(
          onTap: () {
            showSearch(context: context, delegate: OldPatientSearch());
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
