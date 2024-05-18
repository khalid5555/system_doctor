import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/shared/utils/app_colors.dart';
import '../../core/shared/utils/app_images.dart';
import '../../core/shared/widgets/app_text.dart';
import '../patient/patient_controller_server.dart';
import 'old_patient_details.dart';
import 'patient_card.dart';

class OldPatientSearch extends SearchDelegate {
  final PatientControllerServer patientCtrl =
      Get.find<PatientControllerServer>();
  // final PatientControllerServer patientCtrl =
  //     Get.find<PatientControllerServer>();
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
    final searchAdmin = patientCtrl.allPatientOld;
    final List searchResults = searchAdmin
        .where((student) =>
            student.name!.toLowerCase().contains(query.toLowerCase().trim()) ||
            student.details!.toLowerCase().contains(query.toLowerCase().trim()))
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
                        Get.to(() => OldPatientDetails(patient: patientSearch));
                      },
                      child: PatientCardServer(
                        patient: patientSearch,
                        index: index,
                        onDelete: () {
                          // Delete the client
                          // patientCtrl.deleteDocumentAndImage(patientSearch.id!);
                          Get.defaultDialog(
                              onConfirm: () async {
                                await patientCtrl.deleteDocumentAndImage(
                                    patientSearch.id!.toString());
                                Get.back(closeOverlays: true);
                              },
                              onCancel: () => Get.back(),
                              middleText: "هل تريد حذف هذه الحالة",
                              title: 'انتبة');
                        },
                        onEdit: () {
                          // Delete the client
                          /* showDialog(
                            context: context,
                            builder: (_) =>
                                EditPatientDialog(patient: patientSearch),
                          ); */
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
      body: query.trim().isEmpty
          ? Image.asset(
              AppImages.searchPic,
              fit: BoxFit.contain,
              // height: AppConst().getScreenSize().height,
            )
          : const SizedBox(),
    );
    /*  query.trim() == '' ? const ShowLoading(show: true) : const SizedBox(); */
  }
}
