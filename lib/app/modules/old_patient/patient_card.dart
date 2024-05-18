import 'package:doctor/app/core/shared/utils/app_colors.dart';
import 'package:doctor/app/data/models/patient_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/shared/widgets/app_text.dart';

class PatientCardServer extends StatelessWidget {
  final PatientModel patient;
  // final Record patient;
  final int index;
  final bool isDay;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  const PatientCardServer({
    Key? key,
    required this.patient,
    this.index = 0,
    this.isDay = false,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 12.r, right: 9.r, left: 9.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.r),
          topRight: Radius.circular(25.r),
          bottomLeft: Radius.circular(index.isEven ? 25.r : 0),
          bottomRight: Radius.circular(index.isOdd ? 25.r : 0),
        ),
        border: Border.all(
            color: index.isEven ? AppColors.kTeal3 : AppColors.kTeal5),
        color: index.isEven
            ? AppColors.kTeal2.withOpacity(.3)
            : AppColors.kTeal4.withOpacity(.1),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                App_Text(
                  data: "معلومات الحالة : \n${patient.name}",
                  size: 14,
                  maxLine: 3,
                  color: AppColors.kTeal4,
                ),
                App_Text(
                  data: "التشخيص : \n${patient.details}",
                  // data: "التشخيص : \n${patient.description}",
                  size: 12,
                  maxLine: 6,
                ),
                const SizedBox(height: 5),
                App_Text(
                  data: "تاريخ الكشف : ${patient.date}",
                  size: 12,
                  color: AppColors.kTeal,
                  maxLine: 5,
                ),
                const SizedBox(height: 5),
                /* isDay
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          App_Text(
                            data:
                                "نوع الحجز  :: ${patient.status ?? "لا يوجد"}",
                            size: 12,
                            color: AppColors.kTeal4,
                            maxLine: 5,
                          ),
                          App_Text(
                            data:
                                "ميعاد الحجز  : ${DateFormat('h:mm a', 'ar').format(patient.createdAt!.toLocal())}",
                            size: 12,
                            color: AppColors.kTeal3,
                            maxLine: 5,
                          ),
                        ],
                      )
                    : const SizedBox(), */
              ],
            ),
          ),
          Positioned(
            top: Get.height * .01,
            // left: -3,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // IconButton(
                //   icon: const Icon(Icons.edit),
                //   onPressed: onEdit,
                //   color: AppColors.kTeal,
                //   tooltip: 'Edit',
                // ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onDelete,
                  color: AppColors.kTeal3,
                  tooltip: 'Delete',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
