import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/shared/utils/app_colors.dart';
import '../../core/shared/utils/show_loading.dart';
import '../../core/shared/widgets/app_text.dart';
import '../../core/shared/widgets/app_text_field.dart';
import '../../data/models/patient_model.dart';
import 'patient_controller_server.dart';
import 'patient_details.dart';

class EditPatientDialog extends StatefulWidget {
  // final PatientModel patient;
  final Record patient;
  const EditPatientDialog({super.key, required this.patient});
  @override
  State<EditPatientDialog> createState() => _EditClientDialogState();
}

class _EditClientDialogState extends State<EditPatientDialog> {
  final TextEditingController details = TextEditingController();
  // final TextEditingController phone = TextEditingController();
  final TextEditingController description = TextEditingController();
  // final TextEditingController address = TextEditingController();
  // final TextEditingController age = TextEditingController();
  // final TextEditingController therapy = TextEditingController();
  final PatientControllerServer patientController = Get.find();
  // final PatientController patientController = Get.find();
  List<ImageOne> imageUrls = [];
  // List<String> imageUrls = [];
  List<File> imagePick = [];
  late int id;
  late var date;
  late var state;
  bool get hasImages => imagePick.isNotEmpty;
  @override
  void initState() {
    id = widget.patient.id!;
    details.text = widget.patient.details;
    date = widget.patient.date;
    state = widget.patient.state;
    description.text = widget.patient.description;
    imageUrls = widget.patient.images!;
    super.initState();
  }

  Future<void> _getImageFromCamera(ImageSource source) async {
    final pickedFile =
        await ImagePicker().pickImage(source: source, imageQuality: 20);
    if (pickedFile != null) {
      setState(() {
        imagePick.add(File(pickedFile.path));
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
            size: 65,
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
            size: 65,
          ),
        ),
        const Spacer(),
        const App_Text(
          data: 'اضافة الصور 📸',
          color: AppColors.kTeal,
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  /*  Widget _displayChild2() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: imageUrls.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final plusImage = imageUrls[index];
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
                child: CachedNetworkImage(
                  imageUrl: plusImage,
                  // imageUrl: widget.student.rays![index],
                  fit: BoxFit.fill,
                  fadeInCurve: Curves.bounceOut,
                  placeholder: (context, url) => const ShowLoading(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                /*  Image.file(
                  imageFiles[index],
                  fit: BoxFit.fill,
                  width: double.infinity,
                ), */
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
 */
  Widget _displayChild2() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: imageUrls.length + imagePick.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              if (index < imageUrls.length) {
                final plusImage = imageUrls[index];
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
                            isFile: true,
                            imageUrl: plusImage.img,
                          ));
                    },
                    child: Image.network(
                      "https://fagaskwt.com/public/${plusImage.img}",
                      fit: BoxFit.fill,
                      width: double.infinity,
                    ),
                    /* CachedNetworkImage(
                    imageUrl: plusImage,
                    fit: BoxFit.fill,
                    fadeInCurve: Curves.bounceOut,
                    placeholder: (context, url) => const ShowLoading(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ), */
                  ),
                );
              } else {
                final pickedImage = imagePick[index - imageUrls.length];
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
                            imageUrl: pickedImage.path,
                          ));
                    },
                    child: Image.file(
                      pickedImage,
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
                  /* Image.file(
                    pickedImage,
                    fit: BoxFit.fill,
                    width: double.infinity,
                  ), */
                );
              }
            },
          ),
        ),
        SizedBox(height: 15.h),
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

  @override
  Widget build(BuildContext context) {
    printInfo(info: "documents id ${widget.patient.id}");
    return Scaffold(
      appBar: AppBar(
        title: const App_Text(
          data: 'التعديل علي الحالات',
          color: AppColors.kCyan,
          size: 16,
        ),
        centerTitle: true,
        backgroundColor: AppColors.kTheFirstAPP,
      ),
      backgroundColor: AppColors.kTheFirstAPP,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(right: 12, left: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: (imageUrls.isNotEmpty || hasImages) ? 280.h : 150.h,
                width: Get.width,
                child: Padding(
                  padding: const EdgeInsets.only(right: 5, left: 8),
                  child: _displayChild2(),
                ),
                // child: hasImages ? _displayChild2() : _displayChild1()),
              ),
              SizedBox(height: 8.h),
              AppTextField(
                myController: details,
                hint: ' اسم  الحالة ',
                icon: Icons.perm_identity,
                min: 3,
              ),
              SizedBox(height: 8.h),
              AppTextField(
                myController: description,
                hint: "التشخيص",
                min: 6,
                icon: Icons.description_outlined,
              ),
              SizedBox(height: 12.h),
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    patientController.isLoading.value == true
                        ? const ShowLoading()
                        : OutlinedButton(
                            clipBehavior: Clip.hardEdge,
                            onPressed: () async {
                              // Update the client
                              patientController.isLoading.value = true;
                              List<File> selectedImages = [];
                              selectedImages.addAll(imagePick);
                              printInfo(
                                  info:
                                      'selectedImages update: $selectedImages');
                              // final imgUrls = await patientController
                              //     .uploadImagesServer(selectedImages);
                              // List<ImageOne> imageUrls = imgUrls
                              //     .map((url) => url.img)
                              //     .toList()
                              //     .cast<ImageOne>();
                              List<ImageOne> finalImageUrls = [];
                              finalImageUrls.addAll(imageUrls);
                              // List<ImageOne>? imageUrls2 = [];
                              // await patientController.updatePatientDataServer(
                              await patientController.updateRecordWithImages(
                                Record(
                                  id: id,
                                  details: details.text.trim(),
                                  date: date,
                                  description: description.text.trim(),
                                  images: imageUrls,
                                  state: state,
                                  updatedAt: DateTime.now(),
                                ),
                                selectedImages,
                              );
                              /* await patientController.updatePatientData(
                                  // PatientModel(
                                  //   id: widget.patient.id,
                                  //   name: name.text.trim(),
                                  //   details: details.text.trim(),
                                  //   rays: imageUrls += (imgUrls.isNotEmpty
                                  //       ? imgUrls.cast<String>()
                                  //       : []),
                                  // ),
                                ); */
                              patientController.isLoading.value = false;
                              Get.back(closeOverlays: true);
                              /*  patientController.isLoading.value = true;
                              try {
                                List<File> selectedImages = [];
                                selectedImages.addAll(imagePick);
                                debugPrint('selectedImages: $selectedImages');
                                final imgUrls = await patientController
                                    .uploadImages(selectedImages);
                                // selectedImages.addAll(imagePick);
                                // print("Selected Images $selectedImages");
                                await patientController.updatePatientData(
                                  PatientModel(
                                    id: widget.student.id,
                                    name: name.text.trim(), // اسم المريض
                                    details: details.text.trim(), // التشخيص
                                    rays: imageUrls +=
                                        (imgUrls.isNotEmpty ? imgUrls : []),
                                    // createAt: Timestamp.now(),
                                  ),
                                );
                                Get.snackbar('done', 'تم التعديل بنجاح');
                                patientController.isLoading.value = false;
                                Get.back(closeOverlays: true);
                              } catch (e) {
                                patientController.isLoading.value = false;
                                printInfo(info: " Error to save data $e ");
                              } */
                            },
                            child: const App_Text(
                              data: "تعديل",
                              color: AppColors.kCyan,
                            ),
                          ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const App_Text(
                        data: "Cancel",
                        color: AppColors.kCyan,
                      ),
                    )
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    details.dispose();
    // phone.dispose();
    // address.dispose();
    // age.dispose();
    // therapy.dispose();
    description.dispose();
  }
}
