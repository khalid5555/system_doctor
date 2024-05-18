import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/modules/login/app_bindings.dart';
import 'app/routes/admin_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // await FirebaseAppCheck.instance.activate();
  await GetStorage.init();
  await initializeDateFormatting();
  // FirebaseFirestore.instance.settings =
  //     const Settings(persistenceEnabled: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // Get.put(LoginController());
    // SystemChrome.setSystemUIOverlayStyle(
    //     const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return ScreenUtilInit(
        designSize: const Size(360.0, 729.3333333333334),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Doctor',
            theme: ThemeData(useMaterial3: true),
            initialBinding: AppBindings(),
            enableLog: true,
            defaultTransition: Transition.size,
            initialRoute: AdminRoutes.splashPage,
            getPages: AdminRoutes.routes,
            // home: StudentScreen(),
          );
        });
  }
}
