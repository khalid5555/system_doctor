// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'dart:io';

import 'package:doctor/app/core/shared/utils/app_colors.dart';
import 'package:doctor/app/core/shared/widgets/app_text.dart';
import 'package:doctor/app/modules/patient/patient_controller_server.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

// import 'package:path/path.dart' as path;
import '../../core/shared/utils/show_loading.dart';
import '../../core/shared/widgets/app_text_field.dart';
import '../../data/models/patient_model.dart';
import '../patient/patient_details.dart';

class AddPatientToServer extends StatefulWidget {
  const AddPatientToServer({super.key});
  @override
  State<AddPatientToServer> createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatientToServer> {
  final TextEditingController details = TextEditingController();
  final TextEditingController description = TextEditingController();
  final GlobalKey<FormState> _kyForm = GlobalKey<FormState>();
  PatientControllerServer controller = Get.find<PatientControllerServer>();
  List<File>? imageFiles = [];
  bool get hasImages => imageFiles!.isNotEmpty;
  String? nowDate = PatientControllerServer.formatDate(DateTime.now());
  String? status = 'كشف';
  var selected = [
    'كشف',
    'أعادة',
  ];
  Widget selectCategory() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: DropdownButton(
          alignment: AlignmentDirectional.center,
          icon: const Icon(Icons.arrow_drop_down_circle_outlined),
          hint: Text(
            selected[0],
            style: const TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          items: selected
              .map(
                (value) => DropdownMenuItem(
                  alignment: AlignmentDirectional.centerEnd,
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.purple,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
              .toList(),
          onChanged: (myValue) {
            // == '  ' حالة العميل''
            if (myValue == 'نوع الحالة') {
              Get.snackbar('انتبة', 'الرجاء اختيار نوع الحالة');
            } else {
              setState(() {
                status = myValue;
              });
            }
          },
          value: status),
    );
  }

  Future<void> _getImageFromCamera(ImageSource source) async {
    final pickedFile =
        await ImagePicker().pickImage(source: source, imageQuality: 20);
    if (pickedFile != null) {
      setState(() {
        imageFiles!.add(File(pickedFile.path));
      });
    }
  }

  Widget _displayChild1() {
    return Column(
      children: [
        OutlinedButton(
          onPressed: () {
            _getImageFromCamera(ImageSource.camera);
          },
          child: const Icon(
            Icons.camera_alt_sharp,
            color: AppColors.kTeal,
            size: 55,
          ),
        ),
        SizedBox(height: 20.h),
        OutlinedButton(
          onPressed: () {
            _getImageFromCamera(ImageSource.gallery);
          },
          child: const Icon(
            Icons.photo_size_select_actual_outlined,
            color: AppColors.kRED,
            size: 55,
          ),
        ),
        const Spacer(),
        const App_Text(
          data: 'اضافة الصور 📸',
          color: AppColors.kTeal,
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  Widget _displayChild2() {
    setState(() {});
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: imageFiles!.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 5),
                height: 160.h,
                width: 165.w,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.kTeal,
                      offset: Offset(0, 5),
                    )
                  ],
                  border: Border.all(color: AppColors.kTeal),
                  borderRadius: const BorderRadius.all(Radius.circular(22)),
                  color: AppColors.kBlue,
                ),
                child: InkWell(
                  onTap: () {
                    Get.to(() => ImageZoomScreen(
                          isFile: false,
                          imageUrl: imageFiles![index].path,
                        ));
                  },
                  child: Image.file(
                    imageFiles![index],
                    fit: BoxFit.fill,
                    width: double.infinity,
                  ),
                  /* mageZoomOnMove(
                      cursor: SystemMouseCursors.grab,
                      image: Image.file(
                        imageFiles![index],
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error),
                      ),
                    ), */
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            OutlinedButton(
              onPressed: () {
                _getImageFromCamera(ImageSource.camera);
              },
              child: const Icon(
                Icons.camera_alt_sharp,
                color: AppColors.kTeal,
                size: 45,
              ),
            ),
            OutlinedButton(
              onPressed: () {
                _getImageFromCamera(ImageSource.gallery);
              },
              child: const Icon(
                Icons.photo_size_select_actual_outlined,
                color: AppColors.kRED,
                size: 45,
              ),
            ),
          ],
        ),
      ],
    );
  }

  ListTile Date_pick() {
    return ListTile(
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: controller.selectDate,
          firstDate: DateTime(DateTime.now().year - 300, 12, 31),
          lastDate: DateTime(DateTime.now().year + 300, 12, 31),
          builder: (context, child) {
            return StatefulBuilder(
              builder: (context, setState) {
                return Theme(
                  data: ThemeData().copyWith(
                    colorScheme: const ColorScheme.light().copyWith(
                      primary: AppColors.kTeal,
                    ),
                  ),
                  child: child!,
                );
              },
            );
          },
        );
        if (pickedDate != null && pickedDate != controller.selectDate) {
          setState(
            () {
              controller.selectDate = pickedDate;
              controller.dueDate =
                  PatientControllerServer.formatDate(controller.selectDate);
            },
          );
        }
      },
      horizontalTitleGap: 0,
      contentPadding: const EdgeInsets.only(left: 8),
      // leading: const Icon(
      //   Icons.calendar_month_rounded,
      //   size: 30,
      //   color: AppColors.kTeal,
      // ),
      trailing: const App_Text(
        size: 14,
        data: 'تاريخ الكشف',
        color: AppColors.kTeal,
        paddingHorizontal: 8,
      ),
      title: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            AppColors.kTeal,
          ),
        ),
        onPressed: null,
        child: App_Text(
          size: 14,
          data: controller.dueDate ?? nowDate!,
          color: AppColors.kWhite,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // printInfo(info: controller.dueDate ?? nowDate.toString());
    return Scaffold(
      // floatingActionButton: const FloatingActionButton.extended(
      //     onPressed: null, label: App_Text(data: 'حفظ الحالة')),
      appBar: AppBar(
        backgroundColor: AppColors.kTeal,
        title: const App_Text(
          data: 'اضافة حالة جديدة',
          size: 20,
          color: AppColors.kWhite,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _kyForm,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: hasImages ? 250.h : 190.h,
                  width: Get.width,
                  child: Padding(
                      padding:
                          const EdgeInsets.only(right: 5, left: 8, top: 15),
                      child: hasImages ? _displayChild2() : _displayChild1()),
                ),
                Date_pick(),
                SizedBox(height: 10.h),
                AppTextField(
                  myController: details,
                  // hint: ' اسم الحالة',
                  icon: Icons.person_2_outlined,
                  color: AppColors.kTeal,
                  lab: 'الاسم العنوان العمر',
                  min: 3,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  myController: description,
                  lab: " وصف الحالة او التشخيص",
                  min: 6,
                  color: AppColors.kTeal,
                  icon: Icons.receipt_outlined,
                ),
                selectCategory(),
                const SizedBox(height: 20),
                Obx(
                  () {
                    return controller.isLoading.value == true
                        ? const ShowLoading()
                        : OutlinedButton(
                            onPressed: () async {
                              if (_kyForm.currentState!.validate()) {
                                List<File> selectedImages = [];
                                if (imageFiles != null) {
                                  selectedImages.addAll(imageFiles!);
                                  print("Selected Images $selectedImages");
                                }
                                controller.isLoading.value = true;
                                print("Selected cat $status");
                                await controller
                                    .addPatientServer(
                                      Record(
                                        details: details.text.trim(),
                                        date: controller.dueDate ??
                                            nowDate!.toString(),
                                        description: description.text.trim(),
                                        state: status,
                                        createdAt: DateTime.now(),
                                      ),
                                      selectedImages,
                                    )
                                    .then((value) =>
                                        Get.back(closeOverlays: true));
                                setState(() {
                                  _kyForm.currentState!.reset();
                                  imageFiles = [];
                                  description.clear();
                                  controller.dueDate = nowDate;
                                  details.clear();
                                });
                                controller.isLoading.value = false;
                              } else {
                                controller.isLoading.value = false;
                                printInfo(info: " Error ");
                              }
                            },
                            child: const Text(
                              'حفظ الحالة',
                              style: TextStyle(
                                fontSize: 20,
                                color: AppColors.kTeal,
                              ),
                            ),
                          );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    description.dispose();
    details.dispose();
  }
}
