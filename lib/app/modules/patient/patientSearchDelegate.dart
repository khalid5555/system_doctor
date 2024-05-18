import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/shared/utils/app_colors.dart';
import '../../core/shared/utils/app_images.dart';
import '../../core/shared/widgets/app_text.dart';
import '../../core/widgets/patient_card.dart';
import 'edit_patient_page.dart';
import 'patient_controller_server.dart';
import 'patient_details.dart';

class PatientSearchDelegate extends SearchDelegate {
  // final PatientController patientCtrl = Get.find<PatientController>();
  final PatientControllerServer patientCtrl =
      Get.find<PatientControllerServer>();
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        color: AppColors.kRED,
        icon: const Icon(Icons.clear),
        onPressed: () {
          printInfo(info: 'xxx');
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      color: AppColors.kTeal,
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // final String isAdmin = studentController.box.read('email') ?? '';
    final searchAdmin =
        // isAdmin == 'admin_employee@gmail.com'?
        patientCtrl.allPatientList
        // : studentController.filteredCustomers
        ;
    //  'admin_employee@gmail.com'
    // final List<PatientModel> searchResults = searchAdmin
    // final List<PatientModel> searchResults = searchAdmin
    final List searchResults = searchAdmin
        .where((student) =>
            student.details
                .toLowerCase()
                .contains(query.toLowerCase().trim()) ||
            student.description
                .toLowerCase()
                .contains(query.toLowerCase().trim()))
        .toList();
    return searchAdmin.isNotEmpty && query.isNotEmpty
        ? Column(
            children: [
              App_Text(
                data: ' عدد النتائج   ${searchResults.length}',
                size: 18,
              ),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final patientSearch = searchResults[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => PatientDetailPage(patient: patientSearch));
                      },
                      child: PatientCard(
                        patient: patientSearch,
                        index: index,
                        onDelete: () {
                          // Delete the client
                          // patientCtrl.deleteDocumentAndImage(patientSearch.id!);
                          Get.defaultDialog(
                              onConfirm: () async {
                                await patientCtrl.deleteDocumentAndImage(
                                    patientSearch.id!.toString());
                                patientCtrl.getPatientDataServer();
                                Get.until((route) {
                                  query = '';
                                  patientCtrl.update();
                                  return !Get.isDialogOpen!;
                                });
                              },
                              onCancel: () => Get.back(),
                              middleText: "هل تريد حذف هذه الحالة",
                              title: 'انتبة');
                        },
                        onEdit: () {
                          // Delete the client
                          showDialog(
                            context: context,
                            builder: (_) =>
                                EditPatientDialog(patient: patientSearch),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          )
        : Image.asset(
            AppImages.searchPic,
            fit: BoxFit.fitHeight,
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // final List<ProductModel> searchResults = controller.product_list
    //     .where((product) =>
    //         product.pName!.toLowerCase().contains(query.toLowerCase()))
    //     .toList();
    return Scaffold(
      backgroundColor: AppColors.kSearch,
      body: query.trim() == ''
          ? Image.asset(
              AppImages.searchPic,
              fit: BoxFit.fitHeight,
              // height: AppConst().getScreenSize().height,
            )
          : const SizedBox(),
    );
    /*  query.trim() == '' ? const ShowLoading(show: true) : const SizedBox(); */
  }
}
