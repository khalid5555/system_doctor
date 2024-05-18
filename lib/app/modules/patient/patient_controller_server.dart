import 'dart:convert';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../data/models/patient_model.dart';

class PatientControllerServer extends GetxController {
  GetStorage box = GetStorage();
  static const baseUrl = 'https://fagaskwt.com/api';
  static const baseUrl2 = 'http://192.168.1.3:/doctor';
  RxBool isLoading = false.obs;
  List allPatientList = [].obs;
  List allCountList = [].obs;
  List<PatientModel> allPatientOld = <PatientModel>[].obs;
  Rx<DateTime> time = DateTime.now().obs;
  DateTime selectDate = DateTime.now();
  String? dueDate;
  @override
  void onInit() {
    super.onInit();
    getPatientDataServer();
    getPatientOldData();
    getRecordCount();
  }

  var headersList = {'Content-Type': "application/json"};
  Future<File?> compressImage2(File file) async {
    // Get file path
    final filePath = file.absolute.path;
    // Create output file path with "_out.jpg" suffix
    final lastIndex = filePath.lastIndexOf('.');
    if (lastIndex == -1) {
      throw Exception('No file extension found in the file path');
    }
    final splitted = filePath.substring(0, lastIndex);
    final outPath = "${splitted}_out.jpg"; // Always use .jpg for the output
    // Compress the image
    final compressedImage = await FlutterImageCompress.compressAndGetFile(
      filePath,
      outPath,
      quality: 20,
      format: CompressFormat.jpeg, // Specify the output format as JPEG
    );
    // Check if the compression was successful
    if (compressedImage == null) {
      throw Exception('Failed to compress image');
    }
    return File(compressedImage.path);
  }

  /* Future<File?> compressImage2(File file) async {
    // Get file path
    // eg:- "Volume/VM/abcd.jpeg"
    final filePath = file.absolute.path;
    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
    final lastIndex = filePath.lastIndexOf(RegExp(r'\.'));
    if (lastIndex == -1) {
      throw Exception('No file extension found in the file path');
    }
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    final compressedImage = await FlutterImageCompress.compressAndGetFile(
      filePath,
      outPath,
      quality: 20,
    );
    return File(compressedImage!.path);
  }
 */
  Future<void> getRecordCount() async {
    isLoading.value = true;
    update();
    try {
      final response = await http.get(Uri.parse("$baseUrl/records/count"));
      if (response.statusCode == 200) {
        final count = jsonDecode(response.body);
        final Map<String, dynamic> data = count['data'];
        // printInfo(info: 'Record $data');
        allCountList.assign(data);
        isLoading.value = false;
        printInfo(info: 'getRecordCount(): ${allPatientList.length}');
        update();
      } else {
        throw Exception('Failed to get record count: ${response.body}');
      }
    } catch (e) {
      printError(info: 'Error getting patient data: $e');
      Get.snackbar('انتبه', 'هناك خطاء قد يكون بسبب مشكلة في أتصال الانترنت');
      isLoading.value = false;
    }
  }

  Future<void> addPatientServer(Record record, List<File> images) async {
    try {
      final request =
          http.MultipartRequest('POST', Uri.parse("$baseUrl/records/store"));
      request.fields['details'] = record.details;
      request.fields['description'] = record.description;
      request.fields['date'] = record.date!;
      request.fields['state'] = record.state!;
      for (var i = 0; i < images.length; i++) {
        final compressedImage =
            await compressImage2(images[i]); // Compress the image
        request.files.add(http.MultipartFile(
          'images$i',
          compressedImage!.readAsBytes().asStream(),
          compressedImage.lengthSync(),
          filename: compressedImage.path.split('/').last,
        ));
      }
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        // The request was successful
        getPatientDataServer();
        getRecordCount();
        printInfo(info: 'Record added successfully');
        Get.snackbar('انتبه', ' تم الاضافة بنجاح....');
      } else {
        // Handle error
        throw Exception('Failed to add record');
      }
    } catch (e) {
      printInfo(info: 'Record Failed to add');
      Get.snackbar('انتبه', ' $e');
    }
  }

  Future<void> updateRecordWithImages(Record record, List<File> images) async {
    final request = http.MultipartRequest(
        'POST', Uri.parse('$baseUrl/records/update/${record.id}'));
    request.fields['details'] = record.details;
    request.fields['description'] = record.description;
    request.fields['date'] = record.date!;
    request.fields['state'] = record.state!;
    for (var i = 0; i < images.length; i++) {
      final compressedImage =
          await compressImage2(images[i]); // Compress the image
      request.files.add(http.MultipartFile(
        'images$i',
        compressedImage!.readAsBytes().asStream(),
        compressedImage.lengthSync(),
        filename: compressedImage.path.split('/').last,
      ));
    }
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      // Record updated successfully
      printInfo(info: 'Record updated successfully');
      await getPatientDataServer();
      update();
      isLoading.value = false;
      Get.snackbar('done', 'تم التعديل بنجاح');
    } else {
      // Handle error
      printError(info: 'Failed to update record');
      update();
      isLoading.value = false;
    }
  }

  Future<void> getPatientDataServer() async {
    try {
      isLoading.value = true;
      update();
      final response = await http.get(
        // Uri.parse(baseUrl),
        Uri.parse("$baseUrl/records"),
        // headers: headersList,
      );
      if (response.statusCode == 200) {
        // final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final jsonResponse = json.decode(response.body);
        final data = jsonResponse['data']['records'];
        // printInfo(info: 'data(): $data');
        printInfo(info: 'getPatientDataServer(): ${data.length}');
        allPatientList = data.map((item) => Record.fromJson(item)).toList()
          ..sort((a, b) =>
              (b.createdAt as DateTime).compareTo(a.createdAt as DateTime));
        isLoading.value = false;
        printInfo(info: 'getPatientDataServer(): ${allPatientList.length}');
        update();
      } else {
        throw Exception('Failed to get patient data: ${response.body}');
      }
    } catch (e) {
      printError(info: 'Error getting patient data: $e');
      Get.snackbar('انتبه', 'هناك خطاء قد يكون بسبب مشكلة في أتصال الانترنت');
      isLoading.value = false;
    }
  }

  Future<void> getPatientOldData() async {
    try {
      isLoading.value = true;
      update();
      final response = await http.get(
        // Uri.parse(baseUrl),
        Uri.parse("$baseUrl/records/olddate"),
        // headers: headersList,
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final data = jsonResponse['data']['records'];
        printInfo(info: 'getPatientOldData(): ${data.length}');
        if (data is List) {
          List<PatientModel> patientList =
              data.map((e) => PatientModel.fromMap(e)).toList()
                ..sort((a, b) {
                  if (a.createdAt == null && b.createdAt == null) {
                    return 0; // Consider them equal if both are null
                  } else if (a.createdAt == null) {
                    return 1; // Consider a greater than b if a is null
                  } else if (b.createdAt == null) {
                    return -1; // Consider b greater than a if b is null
                  } else {
                    // If neither is null, proceed with the comparison
                    return b.createdAt!.compareTo(a.createdAt!);
                  }
                  // return (b.createdAt!).compareTo(a.createdAt!);
                });
          allPatientOld.assignAll(patientList);
          isLoading.value = false;
          update();
        } else {
          throw Exception('Response data is not a List');
        }
        isLoading.value = false;
        update();
      } else {
        throw Exception('Failed to get patient data2222: ${response.body}');
      }
    } catch (e) {
      printError(info: 'Error getting patient data222: $e');
      Get.snackbar('انتبه',
          'هناك خطاء في جلب البيانات قد يكون بسبب مشكلة في أتصال الانترنت');
      isLoading.value = false;
      update();
    }
  }

  Future<void> deleteImageFromStorage(String imageUrl) async {
    if (imageUrl.isNotEmpty) {
      try {
        final response = await http
            .delete(Uri.parse('$baseUrl/deleteImage?imageUrl=$imageUrl'));
        if (response.statusCode == 200) {
          print('Image deleted from server');
        } else {
          throw Exception('Failed to delete image: ${response.body}');
        }
      } catch (e) {
        print('Error deleting image from server: $e');
      }
    } else {
      print('Invalid URL format: $imageUrl');
    }
  }

  Future<void> deleteDocumentAndImage(String documentId) async {
    isLoading.value = true;
    try {
      final response =
          await http.delete(Uri.parse('$baseUrl/records/destroy/$documentId'));
      if (response.statusCode == 200) {
        await getPatientDataServer();
        await getRecordCount();
        update();
        isLoading.value = false;
        Get.snackbar('انتبه', 'تم الحذف بنجاح');
      } else {
        throw Exception('Failed to delete document: ${response.body}');
      }
    } catch (e) {
      print('Error deleting document from server: $e');
    }
  }

  Future<void> deleteFromOld(String documentId) async {
    isLoading.value = true;
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/records/destroyold/$documentId'));
      if (response.statusCode == 200) {
        await getPatientOldData();
        await getRecordCount();
        update();
        isLoading.value = false;
        Get.snackbar('انتبه', 'تم الحذف بنجاح');
      } else {
        throw Exception('Failed to delete document: ${response.body}');
      }
    } catch (e) {
      print('Error deleting document from old patient: $e');
    }
  }

  static String formatDate(DateTime date) {
    DateFormat dateFormat = DateFormat.yMMMEd('ar');
    String formattedDate = dateFormat.format(date);
    return formattedDate;
  }
}
/*   Future<void> updatePatientDataServer(Record patientModel) async {
    try {
      isLoading.value = true;
      final response = await http.put(
        Uri.parse('$baseUrl/records/update/${patientModel.id}'),
        body: json.encode(patientModel.toJson()),
        // body: patientModel.toJson(),
      );
      if (response.statusCode == 200) {
        await getPatientDataServer();
        update();
        isLoading.value = false;
        Get.snackbar('done', 'تم التعديل بنجاح');
      } else {
        throw Exception('Failed to update patient data: ${response.body}');
      }
    } catch (e) {
      print('Error updating patient data: $e');
      Get.snackbar('انتبه', e.toString());
      isLoading.value = false;
    }
  }
 */
  /*  Future<List<dynamic>> uploadImagesServer(List<File>? files) async {
    if (files == null) {
      return [];
    }
    try {
      isLoading.value = true;
      const storageUrl = '$baseUrl/records/store'; //records/store
      List<ImageOne> imageUrls = [];
      for (var file in files) {
        final fileName = path.basename(file.path);
        final mimeType = lookupMimeType(file.path);
        // Compress the image file
        final compressedImage = await compressImage2(file);
        if (compressedImage != null) {
          final multipartFile = http.MultipartFile(
            'images',
            compressedImage.readAsBytes().asStream(),
            compressedImage.lengthSync(),
            filename: fileName,
            contentType: MediaType.parse(mimeType!),
          );
          final request = http.MultipartRequest('POST', Uri.parse(storageUrl));
          request.files.add(multipartFile);
          final response = await request.send();
          if (response.statusCode == 200) {
            final imageUrl = await response.stream.bytesToString();
            imageUrls.add(imageUrl as ImageOne);
            print('Images uploaded and URLs saved to server');
            update();
          } else {
            throw Exception('Failed to upload image: ${response.reasonPhrase}');
          }
        }
      }
      isLoading.value = false;
      update();
      return imageUrls;
    } catch (e) {
      print('Error uploading images: $e');
      Get.snackbar('انتبه', e.toString());
      return [];
    }
  }
 */
/////////////////////////////////////////////////////////////////////////
  /* Future<void> addPatientServer(Record patientModel) async {
    // Create a multipart request
    var request =
        http.MultipartRequest('POST', Uri.parse("$baseUrl/records/store"));
    // Add the record fields as JSON
    request.fields['record'] = jsonEncode(patientModel.toJson());
    if (patientModel.images != null) {
      for (String imagePath in patientModel.images!.map((image) => image.img)) {
        // Define and assign a value to the imagePath variable here
        var imagePath = "path/to/image.jpg";
        request.files
            .add(await http.MultipartFile.fromPath('images', imagePath));
      }
    }
    // Add the image files as multipart files
    /*  for (String imagePath in patientModel.images) {
    request.files.add(await http.MultipartFile.fromPath('images', imagePath));
  } */
    // Send the request and get the response
    var response = await request.send();
    // Check the status code
    if (response.statusCode == 200) {
      // The request was successful
      print('Record added successfully');
    } else {
      // The request failed
      print('Something went wrong');
    }
  } */
/* 
  Future<List<ImageOne>> uploadImagesServer(List<File> imageFiles) async {
    List<ImageOne> imageUrls = [];
    for (var file in imageFiles) {
      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse("$baseUrl/records/store"),
        );
        var multipartFile =
            await http.MultipartFile.fromPath('images', file.path);
        request.files.add(multipartFile);
        var response = await request.send();
        var responseBody = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          var jsonResponse = json.decode(responseBody);
          List<dynamic> imagesJson = jsonResponse['images'];
          for (var imageJson in imagesJson) {
            ImageOne image = ImageOne.fromJson(imageJson);
            imageUrls.add(image);
          }
        } else {
          throw Exception('Failed to upload image: $responseBody');
        }
      } catch (e) {
        printInfo(info: 'Error uploading image uploadImagesServer: $e');
        isLoading.value = false;
      }
    }
    return imageUrls;
  }
  Future<void> addPatientServer(
      Record patientModel, List<String> imageData) async {
    try {
      isLoading.value = true;
      // Add image data to patientModel
      patientModel.images = imageData
          .map((url) => ImageOne(
                img: url,
                recordId: patientModel.id!,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ))
          .toList();
      final response = await http.post(
        Uri.parse("$baseUrl/records/store"),
        body: json.encode(patientModel.toJson()),
      );
      if (response.statusCode == 200) {
        await getPatientDataServer();
        isLoading.value = false;
        print('POST request successful');
        print(response.body);
        Get.snackbar('انتبه', ' تم الاضافة بنجاح....');
        update();
      } else {
        throw Exception('Failed to add patient: ${response.body}');
      }
    } catch (e) {
      printError(info: 'خطاء في اضافة المريض: $e');
      Get.snackbar('انتبه', e.toString());
      isLoading.value = false;
    }
  }
 */
  /*  Future<List<ImageOne>> uploadImagesServer(List<File> imageFiles) async {
    List<ImageOne> imageUrls = [];
    for (var file in imageFiles) {
      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse("$baseUrl/records/store"),
        );
        var multipartFile =
            await http.MultipartFile.fromPath('public', file.path);
        request.files.add(multipartFile);
        var response = await request.send();
        var responseBody = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          var jsonResponse = json.decode(responseBody);
          // var imageUrl = jsonResponse['images'];
          // imageUrls.add(imageUrl);
          List<dynamic> imagesJson = jsonResponse['images'];
          for (var imageJson in imagesJson) {
            ImageOne image = ImageOne.fromJson(imageJson);
            imageUrls.add(image);
          }
        } else {
          throw Exception('Failed to upload image: $responseBody');
        }
      } catch (e) {
        printInfo(info: 'Error uploading image uploadImagesServer: $e');
        isLoading.value = false;
      }
    }
    return imageUrls;
  }
  Future addPatientServer(Record patientModel, List<String> imageData) async {
    try {
      isLoading.value = true;
      // Add image data to patientModel
      patientModel.images = [
        ImageOne(
          img: imageData.toString(),
          recordId: patientModel.id!,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        )
      ];
      final response = await http.post(
        Uri.parse("$baseUrl/records/store"),
        // headers: headersList,
        body: json.encode(patientModel.toJson()),
      );
      if (response.statusCode == 200) {
        await getPatientDataServer();
        isLoading.value = false;
        print('POST request successful');
        print(response.body);
        Get.snackbar('انتبه', ' تم الاضافة بنجاح....');
        update();
      } else {
        throw Exception('Failed to add patient: ${response.body}');
      }
    } catch (e) {
      printError(info: 'خطاء في اضافة المريض: $e');
      Get.snackbar('انتبه', e.toString());
      isLoading.value = false;
    }
  }
 */
  /* Future<void> addPatientServer(
      Record patientModel, List<File> imageFiles) async {
    try {
      isLoading.value = true;
      // Upload images
      List<ImageOne> imageUrls = await uploadImagesServer(imageFiles);
      // Add image URLs to the patientModel
      patientModel.images = imageUrls;
      final response = await http.post(
        Uri.parse("$baseUrl/records/store"),
        headers: headersList,
        body: json.encode(patientModel.toJson()),
      );
      if (response.statusCode == 200) {
        await getPatientDataServer();
        isLoading.value = false;
        // Request successful
        print('POST request successful');
        print(response.body);
        Get.snackbar('انتبه', ' تم الاضافة بنجاح....');
        update();
      } else {
        throw Exception('Failed to add patient: ${response.body}');
      }
    } catch (e) {
      printError(info: 'Error adding Patient: $e');
      Get.snackbar('انتبه', e.toString());
      isLoading.value = false;
    }
  }
 */
  /*  Future<void> addPatientServer(Record patientModel) async {
    try {
      isLoading.value = true;
      final response = await http.post(Uri.parse("$baseUrl/records/store"),
          headers: headersList, body: json.encode(patientModel.toJson()));
      if (response.statusCode == 200) {
        await getPatientDataServer();
        isLoading.value = false;
        // Request successful
        print('POST request successful');
        print(response.body);
        Get.snackbar('انتبه', ' تم الاضافة بنجاح....');
        update();
      } else {
        throw Exception('Failed to add patient: ${response.body}');
      }
    } catch (e) {
      printError(info: 'Error adding Patient: $e');
      // isLoading.value = false;
      Get.snackbar('انتبه', e.toString());
      isLoading.value = false;
    }
  }
 */
/////////////////////////////////////////////////////////////////////////
  /* Future<void> deleteImageFromStorage(String imageUrl) async {
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
  } */
/* 
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
      await getPatientDataServer();
      update();
      isLoading.value = false;
      Get.snackbar('انتبه', 'تم الحذف بنجاح');
      print('Document deleted from Firestore');
    }
  }
 */
/*  Future<List<dynamic>> uploadImages(List<File>? files) async {
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
 */
/*  Future<void> addPatient(PatientModel patientModel) async {
    try {
      isLoading.value = true;
      final docUser = _firestore.collection(patientCollection).doc();
      patientModel.id = docUser.id;
      await docUser.set(patientModel.toMap(), SetOptions(merge: true));
      await getPatientData();
      isLoading.value = false;
      update();
    } catch (e) {
      printError(info: 'Error adding user: $e');
      // isLoading.value = false;
      Get.snackbar('انتبه', e.toString());
    }
  } */
/*  Future<void> getPatientData() async {
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
 */
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
  /*  Future<void> updatePatientData(PatientModel patientModel) async {
    try {
      isLoading.value = true;
      await _firestore
          .collection(patientCollection)
          .doc(patientModel.id)
          .set(patientModel.toMap(), SetOptions(merge: true));
      await getPatientDataServer();
      update();
      isLoading.value = false;
    } catch (e) {
      print('Error deleting employee: $e');
      Get.snackbar('انتبه', e.toString());
    }
  }
 */
