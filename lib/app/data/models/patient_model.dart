import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PatientModel {
  int? id;
  final String? name;
  final String? date;
  // final String? age;
  final String? details; //التشخيص
  // final String? phone;
  // final String? address;
  // final String? therapy; //العلاج
  final List<String>? rays; //الاشعة
  // final String? analysis; // التحليل
  final Timestamp? createdAt;
  // final Timestamp? createAt;
  PatientModel({
    this.id,
    this.name,
    this.date,
    this.details,
    this.rays,
    this.createdAt,
  });
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    if (id != null) {
      result.addAll({'id': id});
    }
    if (name != null) {
      result.addAll({'name': name});
    }
    if (date != null) {
      result.addAll({'date': date});
    }
    if (details != null) {
      result.addAll({'details': details});
    }
    if (rays != null) {
      result.addAll({'rays': rays});
    }
    if (createdAt != null) {
      result.addAll({'createAt': createdAt});
    }
    return result;
  }

  factory PatientModel.fromMap(Map<String, dynamic> map) {
    return PatientModel(
      id: map['id'],
      name: map['name'],
      date: map['date'],
      details: map['details'],
      rays: map['rays'] is List ? List<String>.from(map['rays']) : [],
      // rays: List<String>.from(map['rays']),
      // createAt: map['createAt'],
      createdAt: map['createdAt'] != null ? _parseDate(map['createdAt']) : null,
    );
  }
  static Timestamp? _parseDate(String? date) {
    if (date != null) {
      try {
        return Timestamp.fromDate(DateFormat("MM/dd/yyyy HH:mm").parse(date));
      } catch (e) {
        print("Error parsing date: $e");
      }
    }
    return null;
  }
}

////////////////////////////////////////////
// To parse this JSON data, do
//     final records = recordsFromJson(jsonString);
Records recordsFromJson(String str) => Records.fromJson(json.decode(str));
String recordsToJson(Records data) => json.encode(data.toJson());

class Records {
  bool success;
  Data data;
  Records({
    required this.success,
    required this.data,
  });
  factory Records.fromJson(Map<String, dynamic> json) => Records(
        success: json["success"],
        data: Data.fromJson(json["data"]),
      );
  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class Data {
  List<Record> records;
  int nums;
  Data({
    required this.records,
    required this.nums,
  });
  factory Data.fromJson(Map<String, dynamic> json) => Data(
        records:
            List<Record>.from(json["records"].map((x) => Record.fromJson(x))),
        nums: json["nums"],
      );
  Map<String, dynamic> toJson() => {
        "records": List<dynamic>.from(records.map((x) => x.toJson())),
        "nums": nums,
      };
}

class Record {
  int? id;
  String details;
  String description;
  String? date;
  String? state;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<ImageOne>? images;
  Record({
    this.id,
    required this.details,
    required this.description,
    this.date,
    this.createdAt,
    this.state,
    this.updatedAt,
    this.images,
  });
  factory Record.fromJson(Map<String, dynamic> json) => Record(
        id: json["id"],
        details: json["details"],
        description: json["description"],
        date: json["date"],
        state: json["state"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        images: json["images"] == null
            ? null
            : List<ImageOne>.from(
                json["images"].map((x) => ImageOne.fromJson(x))),
      );
/*   Map<String, dynamic> toJson() => {
        "id": id,
        "details": details,
        "description": description,
        "date": date,
        "created_at": createAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "images": List<dynamic>.from(images!.map((x) => x.toJson())),
      }; */
  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    if (id != null) {
      // result.addAll({'id': id.toString()});
      result['id'] = id.toString();
    }
    result['details'] = details;
    if (state != null) {
      result['state'] = state;
    }
    // result.addAll({'details': details});
    if (date != null) {
      // result.addAll({'date': date});
      result['date'] = date;
    }
    // result.addAll({'description': description});
    result['description'] = description;
    if (images != null) {
      // result.addAll({'images': images});
      result['images'] = images!.map((image) => image.toJson()).toList();
    }
    if (createdAt != null) {
      result['created_at'] = createdAt!.toIso8601String();
      // result.addAll({'created_at': createAt!.toIso8601String()});
    }
    if (updatedAt != null) {
      // result.addAll({'updated_at': updatedAt!.toIso8601String()});
      result['updated_at'] = updatedAt!.toIso8601String();
    }
    return result;
  }
}

class ImageOne {
  int? id;
  String img;
  int recordId;
  DateTime createdAt;
  DateTime updatedAt;
  ImageOne({
    this.id,
    required this.img,
    required this.recordId,
    required this.createdAt,
    required this.updatedAt,
  });
  factory ImageOne.fromJson(Map<String, dynamic> json) => ImageOne(
        id: json["id"],
        img: json["img"],
        recordId: json["record_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "img": img,
        "record_id": recordId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
