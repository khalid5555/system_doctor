/* import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/app/data/models/patient_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
class PatientController extends GetxController {
  GetStorage box = GetStorage();
  // static const patientCollection = 'patient';
  // final _firestore = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;
  // RxList<EmployeeModel> employees = <EmployeeModel>[].obs;
  // RxList<PatientModel> adminAttendanceList = <PatientModel>[].obs;
  List<PatientModel> allPatientList = <PatientModel>[].obs;
  Rx<DateTime> time = DateTime.now().obs;
  DateTime selectDate = DateTime.now();
  String? dueDate;
/*   Future<File?> compressImage(File file) async {
    final filePath = file.path;
    final fileToCompress = File(filePath);
    final compressedImage = await FlutterImageCompress.compressAndGetFile(
      fileToCompress.path,
      fileToCompress.path,
      quality: 20, // Adjust the quality as per your requirements (0-100)
    );
    return File(compressedImage!.path);
  } */
  Future<File?> compressImage2(File file) async {
    // Get file path
    // eg:- "Volume/VM/abcd.jpeg"
    final filePath = file.absolute.path;
    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
    final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    final compressedImage = await FlutterImageCompress.compressAndGetFile(
        filePath, outPath,
        quality: 20);
    return File(compressedImage!.path);
  }
  Future<List<dynamic>> uploadImages(List<File>? files) async {
    if (files == null) {
      return [];
    }
    isLoading.value = true;
    final storageRef = FirebaseStorage.instance.ref('patient');
    List<dynamic> imageUrls = [];
    for (var file in files) {
      final fileName = path.basename(file.path);
      final storageFileRef = storageRef.child(fileName);
// Compress the image file
      final fileToUpload = File(file.path);
      final compressedImage = await compressImage2(fileToUpload);
      if (compressedImage != null) {
        final uploadTask = storageFileRef.putFile(compressedImage);
        final uploadResult = await uploadTask;
        final imageUrl = await uploadResult.ref.getDownloadURL();
        imageUrls.add(imageUrl);
      }
    }
    isLoading.value = false;
    update();
    // if (imageUrls.length == 1) {
    //   imageUrls.add("");
    // }
    print('Images uploaded and URLs saved to Firestore');
    // print('Images url $imageUrls');
    return imageUrls;
  }
  Future<void> addPatient(PatientModel patientModel) async {
    try {
      isLoading.value = true;
      final docUser = _firestore.collection(patientCollection).doc();
      // patientModel.id = int.parse(docUser.id);
      // patientModel.id = docUser.id;
      await docUser.set(patientModel.toMap(), SetOptions(merge: true));
      await getPatientData();
      isLoading.value = false;
      update();
    } catch (e) {
      printError(info: 'Error adding user: $e');
      // isLoading.value = false;
      Get.snackbar('انتبه', e.toString());
    }
  }
  Future<void> getPatientData() async {
    isLoading.value = true;
    return await _firestore
        .collection(patientCollection)
        .orderBy("createAt", descending: true)
        .get()
        .then((snapshot) async {
      allPatientList.assignAll(snapshot.docs.map((doc) {
        // update();
        return PatientModel.fromMap(doc.data());
      }));
      isLoading.value = false;
      printInfo(info: 'getPatientToAdminAllDay(): ${allPatientList.length}');
      update();
    }).catchError((error) {
      print(error.toString());
      Get.snackbar('انتبه', error.toString());
    });
  }
  Future<void> deleteImageFromStorage(String imageUrl) async {
    if (imageUrl.isNotEmpty) {
      final firebase_storage.Reference storageRef =
          firebase_storage.FirebaseStorage.instance.refFromURL(imageUrl);
      try {
        await storageRef.delete();
        print('Image deleted from Firebase Storage');
      } catch (e) {
        print('Error deleting image from Firebase Storage: $e');
      }
    } else {
      print('Invalid URL format: $imageUrl');
    }
  }
  Future<void> deleteDocumentAndImage(String documentId) async {
    isLoading.value = true;
    final DocumentReference documentRef =
        _firestore.collection(patientCollection).doc(documentId);
    final DocumentSnapshot documentSnapshot = await documentRef.get();
    if (documentSnapshot.exists) {
      final Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      final List<dynamic> raysImageUrl = data['rays'];
      // final String analysisImageUrl = data['analysis'];
      if (raysImageUrl.isNotEmpty) {
        for (var img in raysImageUrl) {
          await deleteImageFromStorage(img);
        }
      }
      // if (analysisImageUrl.isNotEmpty) {
      //   await deleteImageFromStorage(analysisImageUrl);
      // }
      await documentRef.delete();
      await getPatientData();
      update();
      isLoading.value = false;
      Get.snackbar('انتبه', 'تم الحذف بنجاح');
      print('Document deleted from Firestore');
    }
  }
  /* Future<void> deletePatientData(String id) async {
    try {
      await _firestore.collection(patientCollection).doc(id).delete();
      await getPatientData();
// حذف الصورة من Firebase Storage
      final storageRef =
          FirebaseStorage.instance.ref('patient').child('path_to_image');
      await storageRef.delete();
      update();
    } catch (e) {
      printError(info: 'Error deleting employee: $e');
    }
  } */
  /*  Future<void> updateDatabaseWithImageUrls(
      List<String> urls, PatientModel patientModel) async {
    isLoading.value = true;
    await _firestore
        .collection(patientCollection)
        .doc(patientModel.id)
        .set(patientModel.toMap(), SetOptions(merge: true));
    // Update the document with the new list of URLs
    // await docRef.update({
    //   'urls': urls,
    // });
  }
 */
  Future<void> updatePatientData(PatientModel patientModel) async {
    try {
      isLoading.value = true;
      await _firestore
          .collection(patientCollection)
          .doc(patientModel.id.toString())
          .set(patientModel.toMap(), SetOptions(merge: true));
      await getPatientData();
      update();
      isLoading.value = false;
    } catch (e) {
      print('Error deleting employee: $e');
      Get.snackbar('انتبه', e.toString());
    }
  }
  static String formatDate(DateTime date) {
    DateFormat dateFormat = DateFormat.yMMMEd('ar');
    String formattedDate = dateFormat.format(date);
    return formattedDate;
  }
}
 */