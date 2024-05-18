/* // ignore_for_file: camel_case_types
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/shared/utils/app_colors.dart';
import '../../core/shared/utils/show_loading.dart';
import '../../core/shared/widgets/app_text.dart';
import '../../core/shared/widgets/app_text_field.dart';
import '../../data/models/employee_model.dart';
import '../login/login_controller.dart';

class Add_employee extends StatefulWidget {
  const Add_employee({Key? key}) : super(key: key);
  @override
  State<Add_employee> createState() => _Add_employeeState();
}

class _Add_employeeState extends State<Add_employee> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    LoginController employeeController = Get.find<LoginController>();
    // bool isLoading = false;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 197, 197),
      body: Padding(
        padding: const EdgeInsets.only(right: 15, left: 15),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 1),
              const App_Text(
                data: "تسجيل موظف جديد",
                size: 20,
                color: AppColors.kBlACK,
              ),
              const Spacer(flex: 1),
              AppTextField(
                myController: employeeController.name,
                hint: 'ادخل الاسم',
                icon: Icons.person,
                color: AppColors.kBlACK,
              ),
              const SizedBox(height: 15),
              AppTextField(
                  myController: employeeController.email,
                  hint: 'ادخل الايميل',
                  icon: Icons.email,
                  color: AppColors.kBlACK,
                  textInputType: TextInputType.emailAddress),
              const SizedBox(height: 15),
              /* AppTextField(
                myController: password,
                obscureText: true,
                hint: 'أدخل الرقم السري',
                icon: Icons.admin_panel_settings,
                color: AppColors.kBlColor,
                textInputType: TextInputType.number,
              ), */
              const Spacer(flex: 1),
              Obx(() {
                return employeeController.isLoading.value == true
                    ? const ShowLoading()
                    : Container(
                        decoration: const BoxDecoration(
                          color: AppColors.kWhite,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        padding: const EdgeInsets.all(15),
                        child: InkWell(
                          onTap: () async {
                            if (formKey.currentState!.validate() &&
                                !employeeController.employees.any((e) =>
                                    e.email ==
                                    employeeController.email.text.trim())) {
                              try {
                                employeeController.isLoading.value = true;
                                await employeeController.addEmployee(
                                  EmployeeModel(
                                    name: employeeController.name.text.trim(),
                                    email: employeeController.email.text.trim(),
                                    createdAt: Timestamp.now(),
                                  ),
                                );
                                Get.snackbar('انتبه', 'تم اضافة موظف',
                                    colorText: AppColors.kWhite,
                                    backgroundColor: AppColors.signUpBg);
                                employeeController.isLoading.value = false;
                                Get.back(closeOverlays: true);
                                employeeController.name.clear();
                                employeeController.email.clear();
                              } catch (e) {
                                Get.snackbar('error', e.toString());
                                employeeController.isLoading.value = false;
                              }
                            } else {
                              // Get.snackbar('',
                              //     " lat== ${employeeController.latu.toString()} + long== ${employeeController.lonu.toString()} ",
                              //     colorText: AppColors.kWhite,
                              //     backgroundColor: AppColors.kbiColor);
                              Get.snackbar('انتبه',
                                  ' الرجاء ملئ الحقول او ايميل الموظف متكرر',
                                  colorText: AppColors.kWhite,
                                  backgroundColor: AppColors.kbiNK);
                              employeeController.isLoading.value = false;
                            }
                          },
                          child: const App_Text(
                            data: "تسجيل الموظف",
                            size: 14,
                          ),
                        ),
                      );
              }),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
 */