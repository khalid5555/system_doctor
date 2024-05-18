import 'package:doctor/app/modules/patient/patient_controller_server.dart';
import 'package:get/get.dart';

class AppBindings implements Bindings {
  @override
  void dependencies() {
    // Get.put(LoginController());
    // Get.lazyPut<LoginController>(() => LoginController());
    // Get.lazyPut<HomeController>(() => HomeController());
    // Get.put(PatientController());
    Get.put(PatientControllerServer());
  }
}
