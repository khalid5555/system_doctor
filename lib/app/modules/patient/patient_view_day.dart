import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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

class PatientScreenDay extends StatefulWidget {
  const PatientScreenDay({super.key});
  @override
  State<PatientScreenDay> createState() => _PatientScreenDayState();
}

class _PatientScreenDayState extends State<PatientScreenDay> {
  final PatientControllerServer patientController =
      Get.put(PatientControllerServer());
  List lengthOfItemsEqualToNow = [];
  late List<dynamic> completedIds;
  void afterFirstLayout(BuildContext context) async {
    // Get the shared preferences instance
    // patientController.box.remove('seen');
    bool seen = (patientController.box.read('seen') ?? false);
    debugPrint('seen: $seen');
    // If the flag is false, show the dialog
    if (!seen) {
      setState(() {
        patientController.box.write('seen', true);
      });
      // Show the dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Center(child: App_Text(data: 'لتحديد اكتمال الكشف ✔️')),
          content: const App_Text(
            data:
                'يمكنك ان تسحب الي الشمال لو اردت ان تحدد  بانك اتممت الكشف علي هذاالمريض  ✅',
            color: AppColors.kTeal,
            overflow: TextOverflow.clip,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(Durations.extralong3, () {
      afterFirstLayout(context);
    });
    // patientController.getPatientDataServer();
    //
    // patientController.box.remove('completedIds');
    completedIds = patientController.box.read('completedIds') ?? [];
    _filterTodayPatients();
  }

  Future<void> _filterTodayPatients() async {
    await patientController.getPatientDataServer();
    DateTime now = DateTime.now();
    lengthOfItemsEqualToNow = patientController.allPatientList.where((item) {
      String arabicDate = item.date;
      DateTime? date;
      // Try parsing with the first format
      try {
        date = DateFormat('yyyy-MM-dd').parse(arabicDate).toLocal();
      } on FormatException {
        // If parsing fails, try the second format
        try {
          date = DateFormat('EEEE، d MMMM y', 'ar')
              .parse(arabicDate, true)
              .toLocal();
        } on FormatException {
          // If both parsing attempts fail, print an error and skip this item
          debugPrint('Error parsing date: $arabicDate');
          return false;
        }
      }
      // If parsing succeeds, check if the date is today and the id is not in completedIds
      return date.day == now.day &&
          date.month == now.month &&
          date.year == now.year &&
          !completedIds.contains(item.id);
    }).toList();
    patientController.update();
    debugPrint('completedIds11111: $completedIds');
  }

/*   Future<void> _filterTodayPatients() async {
    await patientController.getPatientDataServer();
    DateTime now = DateTime.now();
    lengthOfItemsEqualToNow = patientController.allPatientList.where((item) {
      String arabicDate = item.date;
      bool isDifr = arabicDate == DateFormat('yyyy-MM-dd');
      var date = isDifr
          ? DateFormat('yyyy-MM-dd').parse(arabicDate).toLocal()
          : DateFormat('EEEE، d MMMM y', 'ar').parse(arabicDate).toLocal();
      return date.day == now.day && !completedIds.contains(item.id);
    }).toList();
    patientController.update();
    debugPrint('completedIds11111: $completedIds');
  } */
  @override
  Widget build(BuildContext context) {
    // patientController.getPatientDataServer();
    _filterTodayPatients();
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      appBar: _buildAppBar(context),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.day),
            opacity: .03,
            fit: BoxFit.fill,
          ),
        ),
        child: GetBuilder<PatientControllerServer>(
          init: PatientControllerServer(),
          builder: (ctrl) {
            /*  var items = ctrl.allPatientList;
            List lengthOfItemsEqualToNow = items.where((item) {
              String arabicDate = item.date;
              var date = DateFormat('EEEE، d MMMM y', 'ar')
                  .parse(arabicDate)
                  .toLocal();
              return date.day == DateTime.now().day;
            }).toList(); */
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
                lengthOfItemsEqualToNow.isEmpty
                    // ctrl.allPatientList.isEmpty
                    ? const SizedBox()
                    : App_Text(
                        data:
                            'عدد حالات اليوم :  ${lengthOfItemsEqualToNow.length}',
                        // 'اجمالي عدد الحالات :  ${patientController.allPatientList.length}',
                        color: AppColors.kTeal5,
                      ),
                Expanded(
                  child: Obx(
                    () {
                      if (ctrl.isLoading.value) {
                        return const ShowLoading();
                      } else {
                        return lengthOfItemsEqualToNow.isNotEmpty
                            ? LiquidPullToRefresh(
                                color: AppColors.kTeal,
                                backgroundColor: AppColors.kWhite,
                                showChildOpacityTransition: false,
                                // onRefresh: patientController.getPatientData,
                                onRefresh: ctrl.getPatientDataServer,
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: lengthOfItemsEqualToNow.length,
                                  itemBuilder: (context, index) {
                                    final patient =
                                        lengthOfItemsEqualToNow[index];
                                    // final patient = ctrl.allPatientList[index];
                                    var date =
                                        PatientControllerServer.formatDate(
                                            patient.createdAt!);
                                    bool isNewDay = index == 0 ||
                                        patient.createdAt!.day !=
                                            ctrl.allPatientList[index - 1]
                                                .createdAt!.day;
                                    return Dismissible(
                                      key: Key(patient.id.toString()),
                                      direction: DismissDirection.endToStart,
                                      background: Container(
                                        color: AppColors.kTeal,
                                        alignment: Alignment.centerRight,
                                        child: const Padding(
                                          padding: EdgeInsets.only(right: 20),
                                          child: Icon(Icons.delete,
                                              size: 60, color: Colors.white),
                                        ),
                                      ),
                                      onDismissed: (direction) {
                                        final patientId =
                                            lengthOfItemsEqualToNow[index].id;
                                        // final patientIndex = ctrl.allPatientList
                                        //     .indexWhere(
                                        //         (p) => p.id == patientId);
                                        // if (patientIndex != -1) {
                                        //   ctrl.allPatientList
                                        //       .removeAt(patientIndex);
                                        // }
                                        setState(() {
                                          lengthOfItemsEqualToNow
                                              .removeAt(index);
                                          completedIds.add(patientId);
                                          ctrl.box.write(
                                              "completedIds", completedIds);
                                        });
                                        ctrl.update();
                                        Get.snackbar('أنتبة',
                                            'تم اكمال الكشف علي الحالة',
                                            backgroundColor: AppColors.kTeal,
                                            colorText: AppColors.kWhite);
                                      },
                                      child: GestureDetector(
                                        onDoubleTap: () => Get.to(
                                          () => PatientDetailPage(
                                              patient: patient),
                                        ),
                                        child: Column(
                                          children: [
                                            if (isNewDay) _buildDateHeader(date)
                                            /*   Column(
                                                          children: [
                                                            const SizedBox(
                                                                height: 10),
                                                            DecoratedBox(
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: AppColors
                                                                    .kTeal4,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topRight: Radius
                                                                      .circular(20),
                                                                  topLeft: Radius
                                                                      .circular(20),
                                                                  bottomLeft: Radius
                                                                      .circular(20),
                                                                ),
                                                              ),
                                                              child: App_Text(
                                                                data:
                                                                    date.toString(),
                                                                paddingHorizontal:
                                                                    10.sp,
                                                                paddingVertical:
                                                                    7.sp,
                                                                size: 15.sp,
                                                                color: AppColors
                                                                    .kWhite,
                                                              ),
                                                            ),
                                                            const Divider(
                                                              thickness: 3,
                                                              endIndent: 30,
                                                              indent: 30,
                                                              color:
                                                                  AppColors.kTeal,
                                                            ),
                                                          ],
                                                        ) */
                                            ,
                                            PatientCard(
                                              patient: patient,
                                              index: index,
                                              isDay: true,
                                              onDelete: () {
                                                // Delete the client
                                                Get.defaultDialog(
                                                    onConfirm: () async {
                                                      await ctrl
                                                          .deleteDocumentAndImage(
                                                              patient.id!
                                                                  .toString());
                                                      _filterTodayPatients();
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
                                                          patient: patient),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Container(
                                margin: const EdgeInsets.all(30),
                                height: Get.height.h,
                                width: Get.width.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: const DecorationImage(
                                    fit: BoxFit.contain,
                                    image: AssetImage(AppImages.add),
                                  ),
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

AppBar _buildAppBar(BuildContext context) {
  return AppBar(
    centerTitle: true,
    automaticallyImplyLeading: false,
    backgroundColor: AppColors.kTeal,
    title: App_Text(
      data: "حالات اليوم",
      size: 20.sp,
      color: AppColors.kWhite,
    ),
    leadingWidth: 100.w,
    leading: Image.asset(
      AppImages.doctor,
      fit: BoxFit.contain,
    ),
    actions: [
      Padding(
        padding: EdgeInsets.only(right: 15.r),
        child: GestureDetector(
          onTap: () {
            showSearch(context: context, delegate: PatientSearchDelegate());
          },
          child: Image.asset(
            AppImages.iconSearch,
            fit: BoxFit.fitHeight,
            color: AppColors.kYellow,
          ),
        ),
      )
    ],
  );
}

class BuildNoData extends StatelessWidget {
  const BuildNoData({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
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

Widget _buildDateHeader(String date) {
  return Column(
    children: [
      const SizedBox(height: 10),
      DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.kTeal4,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        child: App_Text(
          data: date,
          paddingHorizontal: 10.sp,
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
  );
}
