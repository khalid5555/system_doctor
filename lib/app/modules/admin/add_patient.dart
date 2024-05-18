/* // ignore_for_file: library_private_types_in_public_api
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/app/core/shared/utils/app_colors.dart';
import 'package:doctor/app/core/shared/widgets/app_text.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart' as path;
import '../../core/shared/utils/show_loading.dart';
import '../../core/shared/widgets/app_text_field.dart';
import '../../data/models/patient_model.dart';
import '../patient/patient_controller.dart';
import '../patient/patient_details.dart';
class AddPatient extends StatefulWidget {
  const AddPatient({super.key});
  @override
  State<AddPatient> createState() => _AddPatientState();
}
class _AddPatientState extends State<AddPatient> {
  final TextEditingController name = TextEditingController();
  // final TextEditingController age = TextEditingController();
  // final TextEditingController phone = TextEditingController();
  // final TextEditingController address = TextEditingController();
  final TextEditingController details = TextEditingController();
  // final TextEditingController therapy = TextEditingController();
  final GlobalKey<FormState> _kyForm = GlobalKey<FormState>();
  PatientController controller = Get.find<PatientController>();
  List<File>? imageFiles = [];
  bool get hasImages => imageFiles!.isNotEmpty;
  String? nowDate = PatientController.formatDate(DateTime.now());
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
                  PatientController.formatDate(controller.selectDate);
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
  /*  Future<void> _getImageFromCamera(ImageSource pic) async {
    try {
      final image =
          await ImagePicker().pickImage(source: pic, imageQuality: 20);
      setState(() {
        imageFile1 = image;
      });
    } catch (e) {
      printError(info: "error in _getImageFromCamera   $e");
    }
  }
  Future<void> _getImageFromCamera2(ImageSource pic) async {
    try {
      final image2 =
          await ImagePicker().pickImage(source: pic, imageQuality: 20);
      setState(() {
        imageFile2 = image2;
      });
    } catch (e) {
      printError(info: "error in _getImageFromCamera   $e");
    }
  } */
/*   Widget _displayChild1() {
    if (imageFile1 == null) {
      return Column(
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
          SizedBox(height: 20.h),
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
          const Spacer(),
          const App_Text(
            data: 'صورة التحليل',
            color: AppColors.kTeal,
          ),
          SizedBox(height: 20.h),
        ],
      );
    } else {
      return Container(
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
          borderRadius: const BorderRadius.all(Radius.circular(22)),
          color: AppColors.kBlue,
        ),
        child: Image.file(
          File(imageFile1!.path),
          fit: BoxFit.fill,
          width: double.infinity,
        ),
      );
    }
  }
 */
  /*  Widget _displayChild2() {
    if (imageFile2 == null) {
      return Column(
        children: [
          OutlinedButton(
            onPressed: () {
              _getImageFromCamera2(ImageSource.camera);
            },
            child: const Icon(
              Icons.camera_alt_rounded,
              color: AppColors.kBlACK,
              size: 45,
            ),
          ),
          SizedBox(height: 20.h),
          OutlinedButton(
            onPressed: () {
              _getImageFromCamera2(ImageSource.gallery);
            },
            child: const Icon(
              Icons.photo_camera_back,
              color: AppColors.kbiNK,
              size: 45,
            ),
          ),
          const Spacer(),
          const App_Text(
            data: 'صورة الاشعة',
            color: AppColors.kRED,
          ),
          SizedBox(height: 20.h),
        ],
      );
    } else {
      return Container(
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
          borderRadius: const BorderRadius.all(Radius.circular(22)),
          color: AppColors.kBlue,
        ),
        child: Image.file(
          File(imageFile2!.path),
          fit: BoxFit.fill,
          width: double.infinity,
        ),
      );
    }
  }
  */ /*  Future<List<String>> uploadImages(List<XFile> files) async {
    final storageRef = FirebaseStorage.instance.ref('patient');
    List<String> imageUrls = [];
    for (var file in files) {
      final fileName = path.basename(file.path);
      final storageFileRef = storageRef.child(fileName);
      final uploadTask = storageFileRef.putFile(File(file.path));
      final uploadResult = await uploadTask;
      final imageUrl = await uploadResult.ref.getDownloadURL();
      imageUrls.add(imageUrl);
    }
    if (imageUrls.length == 1) {
      imageUrls.add("");
    }
    print('Images uploaded and URLs saved to Firestore');
    return imageUrls;
  } */
  @override
  Widget build(BuildContext context) {
    printInfo(info: controller.dueDate ?? nowDate.toString());
    return Scaffold(
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
                /*   Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 250.h,
                              width: Get.width / 2.1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 5, left: 8, top: 15),
                                child: _displayChildList(),
                                // child: _displayChild1(),
                              ),
                            ),
                            SizedBox(
                              height: 255.h,
                              width: Get.width / 2.1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 8, left: 5, top: 15),
                                child: _displayChild2(),
                              ),
                            ),
                          ],
                        ),
                        */
                SizedBox(
                  height: hasImages ? 250.h : 190.h,
                  width: Get.width,
                  child: Padding(
                      padding:
                          const EdgeInsets.only(right: 5, left: 8, top: 15),
                      child: hasImages ? _displayChild2() : _displayChild1()
                      /*  ImageWidget(
                      imageFiles:
                          imageFiles?.map((xFile) => File(xFile.path)).toList(),
                    ), */
                      // child: _displayChild1(),
                      ),
                ),
                // SizedBox(height: 20.h),
                Date_pick(),
                SizedBox(height: 10.h),
                AppTextField(
                  myController: name,
                  // hint: ' اسم الحالة',
                  icon: Icons.person_2_outlined,
                  color: AppColors.kTeal,
                  lab: 'الاسم العنوان العمر',
                  min: 3,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  myController: details,
                  lab: " وصف الحالة او التشخيص",
                  min: 6,
                  color: AppColors.kTeal,
                  icon: Icons.receipt_outlined,
                ),
                const SizedBox(height: 20),
                Obx(() {
                  return controller.isLoading.value == true
                      ? const ShowLoading()
                      : OutlinedButton(
                          onPressed: () async {
                            await addToServer();
                            /*    if (_kyForm.currentState!.validate()) {
                              try {
                                setState(() {
                                  controller.isLoading.value = true;
                                });
                                List<XFile> selectedImages = [];
                                if (imageFiles != null) {
                                  selectedImages.addAll(imageFiles!);
                                }
                                final img = await controller
                                    .uploadImages(selectedImages);
                                await controller.addPatient(
                                  PatientModel(
                                    name: name.text.trim(), // اسم المريض
                                    details: details.text.trim(), // التشخيص
                                    // rays: img.isNotEmpty ? img! : '',
                                    rays: img.isNotEmpty ? img : null,
                                    createAt: Timestamp.now(),
                                  ),
                                );
                                Get.snackbar('انتبه', ' تم الاضافة بنجاح....');
                                setState(() {
                                  _kyForm.currentState!.reset();
                                  imageFiles = null;
                                  // imageFile2 = null;
                                  controller.isLoading.value = false;
                                  name.clear();
                                  age.clear();
                                  // phone.clear();
                                  // therapy.clear();
                                  details.clear();
                                });
                                Get.snackbar('انتبه', ' تم الاضافة بنجاح....');
                                Get.back(closeOverlays: true);
                              } catch (e) {
                                setState(() {
                                  controller.isLoading.value = false;
                                });
                                printInfo(info: " Error to save data $e ");
                              }
                            } else {
                              setState(() {
                                controller.isLoading.value = false;
                              });
                              printInfo(info: " Error   ");
                            } */
                          },
                          child: const Text(
                            'حفظ الحالة',
                            style: TextStyle(
                              fontSize: 20,
                              color: AppColors.kTeal,
                            ),
                          ),
                        );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> addToServer() async {
     if (_kyForm.currentState!.validate()) {
      controller.isLoading.value = true;
      try {
        List<File> selectedImages = [];
        if (imageFiles != null) {
          selectedImages.addAll(imageFiles!);
          print("Selected Images $selectedImages");
        }
        final imgUrls = await controller
            .uploadImages(selectedImages);
        await controller.addPatient(
          PatientModel(
            name: name.text.trim(),
            date: controller.dueDate ?? nowDate,
            details: details.text.trim(),
            rays: imgUrls.isNotEmpty
                ? imgUrls.cast<String>()
                : [],
            createdAt: Timestamp.now(),
          ),
        );
        // Get.snackbar('انتبه', ' تم الاضافة بنجاح....');
        setState(() {
          _kyForm.currentState!.reset();
          imageFiles = [];
          name.clear();
          controller.dueDate = nowDate;
          details.clear();
        });
        Get.snackbar('انتبه', ' تم الاضافة بنجاح....');
        controller.isLoading.value = false;
        Get.back(closeOverlays: true);
      } catch (e) {
        controller.isLoading.value = false;
        printInfo(info: " Error to save data $e ");
        Get.snackbar('انتبه', e.toString());
      }
    } else {
      controller.isLoading.value = false;
      printInfo(info: " Error ");
    }
  }
  @override
  void dispose() {
    super.dispose();
    name.dispose();
    // age.dispose();
    details.dispose();
    // therapy.dispose();
    // phone.dispose();
  }
}
/* 
class MyFormWidget extends StatefulWidget {
  const MyFormWidget({super.key});
  @override
  _MyFormWidgetState createState() => _MyFormWidgetState();
}
class _MyFormWidgetState extends State<MyFormWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  String name = '';
  String age = '';
  String address = '';
  @override
  void initState() {
    super.initState();
    _textEditingController.text = "$name\n$age\n$address";
  }
  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
  void _submitForm() {
    final text = _textEditingController.text;
    final values = text.split('\n');
    if (values.length >= 3) {
      setState(() {
        name = values[0];
        age = values[1];
        address = values[2];
      });
      _textEditingController.clear();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _textEditingController,
          maxLines: null,
          onFieldSubmitted: (value) {
            _submitForm();
          },
          decoration: const InputDecoration(
            labelText: 'Enter Text',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
} */
/* 
class ImageWidget extends StatefulWidget {
  List<File>? imageFiles;
  ImageWidget({super.key, this.imageFiles});
  @override
  _ImageWidgetState createState() => _ImageWidgetState();
}
class _ImageWidgetState extends State<ImageWidget> {
  // List<File> imageFiles = [];
  bool get hasImages => widget.imageFiles!.isNotEmpty;
  Future<void> _getImageFromCamera(ImageSource source) async {
    final pickedFile =
        await ImagePicker().pickImage(source: source, imageQuality: 20);
    if (pickedFile != null) {
      setState(() {
        widget.imageFiles!.add(File(pickedFile.path));
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return hasImages ? _displayChild2() : _displayChild1();
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
            size: 45,
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
            size: 45,
          ),
        ),
        const Spacer(),
        const App_Text(
          data: 'صورة التحليل',
          color: AppColors.kTeal,
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
  Widget _displayChild2() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: widget.imageFiles!.length,
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
                child: Image.file(
                  widget.imageFiles![index],
                  fit: BoxFit.fill,
                  width: double.infinity,
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
}
 *//* class ImageListWidget extends StatelessWidget {
  final List<File>? imageFiles;
  final Function(ImageSource) getImageFromCamera;
  const ImageListWidget({
    Key? key,
    this.imageFiles,
    required this.getImageFromCamera,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: imageFiles?.length ?? 3,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final imageFile = imageFiles?[index];
        return _displayChild(imageFile);
      },
    );
  }
  Widget _displayChild(File? imageFile) {
    if (imageFile == null) {
      return Column(
        children: [
          OutlinedButton(
            onPressed: () {
              getImageFromCamera(ImageSource.camera);
            },
            child: const Icon(
              Icons.camera_alt_sharp,
              color: AppColors.kTeal,
              size: 45,
            ),
          ),
          SizedBox(height: 20.h),
          OutlinedButton(
            onPressed: () {
              getImageFromCamera(ImageSource.gallery);
            },
            child: const Icon(
              Icons.photo_size_select_actual_outlined,
              color: AppColors.kRED,
              size: 45,
            ),
          ),
          const Spacer(),
          const App_Text(
            data: 'صورة التحليل',
            color: AppColors.kTeal,
          ),
          SizedBox(height: 20.h),
        ],
      );
    } else {
      return Container(
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
          borderRadius: const BorderRadius.all(Radius.circular(22)),
          color: AppColors.kBlue,
        ),
        child: Image.file(
          imageFile,
          fit: BoxFit.fill,
          width: double.infinity,
        ),
      );
    }
  }
} */
/* class _MyFormWidgetState extends State<MyFormWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  String name = '';
  String age = '';
  String address = '';
  @override
  void initState() {
    super.initState();
    // _textEditingController.text = "$name\n$age\n$address";
    _textEditingController.text = "اسم:$name \nعمر:$age \nعنوان:$address ";
  }
  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
  void saveData() {
    final text = _textEditingController.text;
    final values = text.split('\n');
    if (values.length >= 3) {
      name = values[0];
      age = values[1];
      address = values[2];
    }
  }
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _textEditingController,
      maxLines: null, // يسمح بعدة أسطر من النص
      onEditingComplete: () {
        FocusScope.of(context).parent; // انتقل إلى الحقل التالي
      },
      decoration: const InputDecoration(
        labelText: 'أدخل النص',
        border: OutlineInputBorder(),
      ),
      textDirection: TextDirection.rtl,
    );
  }
}
 *//* class _MyFormWidgetState extends State<MyFormWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  List<String> names = [];
  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
  void addName(String name) {
    names = [];
    setState(() {
      names.add(name);
      _textEditingController.text = names.join(", ");
      debugPrint('v: $names');
      // _textEditingController.clear();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _textEditingController,
          // onChanged: addName,
          onFieldSubmitted: (v) {
            addName(v);
            debugPrint('addName: $names');
          },
          // maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'name/age/address',
            // hintText: 'name\nage\naddress',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          itemCount: names.length,
          itemBuilder: (context, index) {
            return Text(names[index]);
          },
        ),
      ],
    );
  }
}
 *//*   Future uploadImage(context) async {
    int id = Random().nextInt(100000000);
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref('patient').child('pic $id.jpg');
      UploadTask storageUploadTask = ref.putFile(File(imageFile1!.path));
      TaskSnapshot taskSnapshot = await storageUploadTask.whenComplete(
        () {},
      );
      String url = await taskSnapshot.ref.getDownloadURL();
      printInfo(info: 'url $url');
      setState(() {
        _url = url;
      });
      Get.snackbar('Hi', 'تم الحفظ');
    } catch (ex) {
      Get.snackbar('$ex', ex.toString());
    }
  } */
/*   Future<void> uploadImages(List<XFile> files) async {
    final storageRef = FirebaseStorage.instance.ref('patient');
    final uploadTasks = files.map((file) {
      final fileName = path.basename(file.path);
      final storageFileRef = storageRef.child(fileName);
      return storageFileRef.putFile(File(file.path));
    }).toList();
    final uploadResults = await Future.wait(uploadTasks);
    /*  final imageUrls = */ await Future.wait(uploadResults.map((result) {
      return result.ref.getDownloadURL();
    })).then((value) {
      value.first = raysImg!;
      value.last = analysisImg!;
    });
    // final imageUrlsMap = Map<String, String>.fromIterables(
    //   files.map((file) => path.basename(file.path)),
    //   imageUrls,
    // );
    print('Images uploaded and URLs saved to Firestore');
  } */
  /* Future<List<String>> uploadImages(List<XFile> files) async {
    final storageRef = FirebaseStorage.instance.ref('patient');
    final uploadTasks = files.map((file) {
      final fileName = path.basename(file.path);
      final storageFileRef = storageRef.child(fileName);
      return storageFileRef.putFile(File(file.path));
    }).toList();
    final uploadResults = await Future.wait(uploadTasks);
    final imageUrls = await Future.wait(uploadResults.map((result) {
      return result.ref.getDownloadURL();
    }));
    print('Images uploaded and URLs saved to Firestore');
    return imageUrls;
  }
 */
 */