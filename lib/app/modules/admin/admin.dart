import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/shared/utils/app_colors.dart';
import '../../core/shared/utils/app_images.dart';
import '../../core/shared/utils/show_loading.dart';
import '../../core/shared/widgets/app_text.dart';
import '../old_patient/old_patient_view.dart';
import '../patient/patient_controller_server.dart';
import '../patient/patient_view.dart';
import '../patient/patient_view_day.dart';
import 'add_patient_to_server.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    // var ctrl = Get.put(PatientControllerServer());
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      appBar: AppBar(
        /*  actions: [
          OutlinedButton(
            child: const App_Text(
              data: 'خروج',
              color: AppColors.kLIGHTGreen,
            ),
            onPressed: () {
              // Get.find<LoginController>().box.remove('login_employee');
              // Get.find<LoginController>().box.remove('email');
              // Get.find<LoginController>().box.remove('login_admin');
              // Get.find<EmployeeController>().box.remove('Email_employee');
              // Get.off(() => const AuthPage());
            },
          ),
        ], */
        centerTitle: true,
        title: const App_Text(
          data: 'لوحة تحكم ',
          size: 20,
          color: AppColors.kWhite,
        ),
        backgroundColor: AppColors.kTeal,
      ),
      body: Container(
        height: Get.height.h,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.old),
            opacity: .07,
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _BuildIcon(
                  text: 'حالات اليوم',
                  image: AppImages.day,
                  onTap: () {
                    Get.to(() => const PatientScreenDay());
                  },
                ),
                _BuildIcon(
                  text: 'الصفحة الرئيسية',
                  image: AppImages.home_day,
                  onTap: () {
                    Get.to(() => PatientScreen());
                  },
                ),
              ],
            ),
            _BuildIcon(
                text: "اضافة حالة",
                image: AppImages.add1,
                onTap: () {
                  Get.to(() => const AddPatientToServer());
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _BuildIcon(
                  text: 'الحالات قديمة',
                  image: AppImages.old,
                  onTap: () {
                    Get.to(() => const OldPatientScreen());
                  },
                ),
                GetBuilder(
                    init: PatientControllerServer(),
                    builder: (ctrl) {
                      return _BuildIcon(
                        text: 'تقارير',
                        image: AppImages.report,
                        onTap: () {
                          ctrl.getRecordCount();
                          Get.dialog(
                            AlertDialog(
                              backgroundColor: AppColors.kWhite,
                              title: const Center(
                                child: App_Text(
                                  data: 'تقارير الحالات',
                                  size: 15,
                                ),
                              ),
                              content: ctrl.allPatientOld.isEmpty
                                  ? const ShowLoading()
                                  : Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        FittedBox(
                                          child: App_Text(
                                            size: 15,
                                            data:
                                                ' عدد الحالات الجديدة :        ${ctrl.allCountList.first['data_new']}',
                                            color: AppColors.kTeal,
                                          ),
                                        ),
                                        FittedBox(
                                          child: App_Text(
                                            size: 15,
                                            data:
                                                ' عدد الحالات القديمة :        ${ctrl.allCountList.first['data_old']}',
                                            color: AppColors.kTeal3,
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        const Divider(
                                          thickness: 2,
                                          color: AppColors.kTeal,
                                        ),
                                        FittedBox(
                                          child: App_Text(
                                            size: 15,
                                            data:
                                                ' عدد جميع الحالات :           ${ctrl.allCountList.first['alldata']}',
                                            color: AppColors.kTeal4,
                                          ),
                                        ),
                                      ],
                                    ),
                              actions: <Widget>[
                                OutlinedButton(
                                  child: const App_Text(
                                    size: 15,
                                    data: 'أغلق',
                                    color: AppColors.kTeal3,
                                  ),
                                  onPressed: () {
                                    Get.back(closeOverlays: true);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
              ],
            ),
            /*  OutlinedButton.icon(
              icon: const Icon(Icons.home_filled),
              label: const App_Text(
                data: 'الصفحة الرئيسية',
                color: AppColors.kTeal,
              ),
              onPressed: () {
                Get.to(() => PatientScreen());
              },
            ), 
            OutlinedButton.icon(
              icon: const Icon(Icons.calendar_month_outlined),
              label: const App_Text(
                data: 'حالات اليوم',
                color: AppColors.kGreen,
              ),
              onPressed: () {
                Get.to(() => PatientScreenDay());
              },
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.add_comment_outlined),
              label: const App_Text(
                data: "اضافة حالة",
                color: AppColors.kTeal3,
              ),
              onPressed: () {
                // Get.to(() => const AddPatient());
                Get.to(() => const AddPatientToServer());
              },
            ),*/ /*   OutlinedButton.icon(
              icon: const Icon(Icons.calendar_month_outlined),
              label: const App_Text(
                data: 'حالات LocalServer',
                color: AppColors.kGreen,
              ),
              onPressed: () {
                Get.to(() => PatientScreenLocalServer());
              },
            ), */
            /* OutlinedButton.icon(
              icon: const Icon(Icons.receipt_outlined),
              label: const App_Text(
                data: ' تقارير  ',
                color: AppColors.kTeal4,
              ),
              onPressed: () async {
                var count = await ctrl.getRecordCount();
                Get.dialog(
                  AlertDialog(
                    backgroundColor: AppColors.kWhite,
                    title: const Center(
                      child: App_Text(
                        data: 'تقارير الحالات',
                        size: 15,
                      ),
                    ),
                    content: ctrl.allPatientList.isEmpty
                        ? const ShowLoading()
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              App_Text(
                                size: 15,
                                data:
                                    ' عدد الحالات الجديدة :        ${count['data_new']}',
                                color: AppColors.kTeal,
                              ),
                              App_Text(
                                size: 15,
                                data:
                                    ' عدد الحالات القديمة :        ${count['data_old']}',
                                color: AppColors.kTeal3,
                              ),
                              const SizedBox(height: 15),
                              const Divider(
                                thickness: 2,
                                color: AppColors.kTeal,
                              ),
                              App_Text(
                                size: 15,
                                data:
                                    ' عدد جميع الحالات :           ${count['alldata']}',
                                color: AppColors.kTeal4,
                              ),
                            ],
                          ),
                    actions: <Widget>[
                      OutlinedButton(
                        child: const App_Text(
                          size: 15,
                          data: 'أغلق',
                          color: AppColors.kTeal3,
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.add_comment_outlined),
              label: const App_Text(
                data: "الحالات قديمة",
                color: AppColors.kTeal5,
              ),
              onPressed: () {
                // Get.to(() => const AddPatient());
                Get.to(() => const PatientScreenLocalServer());
              },
            ),
         */
          ],
        ),
      ),
    );
  }
}

class _BuildIcon extends StatelessWidget {
  final String text, image;
  final Function() onTap;
  const _BuildIcon({
    Key? key,
    required this.text,
    required this.image,
    required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: Get.width / 2.6,
            height: 105,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(25),
                bottomLeft: text != "اضافة حالة"
                    ? const Radius.circular(25)
                    : const Radius.circular(0),
                topRight: const Radius.circular(25),
              ),
              color: AppColors.kTeal,
              border: Border.all(color: AppColors.kTeal, width: 2),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        App_Text(
          data: text,
          color: AppColors.kTeal,
        ),
      ],
    );
  }
}
