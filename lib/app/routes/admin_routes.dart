import 'package:get/get.dart';

import '../modules/admin/add_patient_to_server.dart';
import '../modules/login/app_bindings.dart';
import '../modules/old_patient/old_patient_view.dart';
import '../modules/patient/patient_view.dart';
import '../modules/patient/patient_view_day.dart';
import '../modules/splash_view.dart';

class AdminRoutes {
  AdminRoutes._();
  // static const screenForAdmin = '/screen-for-admin';
  static const splashPage = '/';
  // static const authPage = '/authPage';
  static const addPatient = '/addPatient';
  static const patientDay = '/patientDay';
  static const patientPage = '/patient';
  static const patientPageServer = '/patientPageServer';
  static final routes = [
    GetPage(
      name: splashPage,
      page: () => const SplashPage(),
      binding: AppBindings(),
    ),
    GetPage(
      name: patientDay,
      page: () => const PatientScreenDay(),
      binding: AppBindings(),
    ),
    GetPage(
      name: patientPage,
      page: () => PatientScreen(),
      binding: AppBindings(),
    ),
    GetPage(
      name: patientPageServer,
      page: () => OldPatientScreen(),
      binding: AppBindings(),
    ),
    GetPage(
      name: addPatient,
      page: () => const AddPatientToServer(),
      binding: AppBindings(),
    ),
  ];
}
