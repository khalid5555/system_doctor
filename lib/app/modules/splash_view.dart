import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../core/shared/utils/app_colors.dart';
import '../core/shared/utils/app_images.dart';
import '../core/shared/utils/constants.dart';
import 'admin/admin.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  late Animation<double> _scaleAnimation;
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation =
        Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ))
          ..addListener(() {
            setState(() {});
          });
    _scaleAnimation = Tween<double>(
      begin: 0.5, // Start with 50% scale
      end: 1.0, // End with 100% scale
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward().then((value) {
      // navigationToPage();
      // Get.off(() => PatientScreen());
      Get.off(() => const Admin());
    });
  }

  /* void navigationToPage() async {
    final GetStorage box = GetStorage();
    // box.remove('login_employee');
    // box.remove('email');
    // box.remove('login_admin');
    bool isLogin = box.read("login_employee") ?? false;
    bool loginAdmin = box.read("login_admin") ?? false;
    String isAdmin = box.read('email') ?? '';
    if (isAdmin == 'mahmoud_admin_logeen_attendance@gmail.com' ||
        loginAdmin == true) {
      Get.off(() => const Admin(), transition: Transition.size);
    } else if (isLogin == true) {
      // Get.off(() => const HomePage(), transition: Transition.size);
    } else {
      Get.off(() => const AuthPage());
    }
    printInfo(info: " splash= ${box.read('email') ?? ""}");
    printInfo(info: " login_employee= $isLogin");
  } */
  /* void navigationToPage() async {
    final GetStorage box = GetStorage();
    // box.remove('login_employee');
    // box.remove('email');
    // box.remove('Email_employee');
    bool isLogin = box.read("login_employee") ?? false;
    String isAdmin = box.read('email') ?? '';
    if (isAdmin == 'mahmoudadmin_employee@gmail.com') {
      Get.off(() => const Admin());
    } else if (isLogin == true) {
      Get.off(() => ClientScreen());
    } else {
      Get.off(() => const LoginEmployee());
    }
    printInfo(info: box.read('email'));
  } */
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FractionalTranslation(
                translation: _animation.value,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    );
                  },
                  child: child,
                ),
              );
            },
            child: Center(
              child: Image.asset(
                AppImages.old,
                // AppImages.logeen_logo2,
                fit: BoxFit.contain,
                width: 250.w,
                height: 280.h,
              ),
            ),
          ),
          // const Spacer(),
          Positioned(
            bottom: AppConst().getScreenSize().height * .02,
            left: 0,
            right: 0,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const App_Text(
                  //   data: 'By : ',
                  //   size: 14,
                  //   color: AppColors.kbiColor,
                  //   direction: TextDirection.ltr,
                  // ),
                  Image.asset(
                    AppImages.khalid2,
                    fit: BoxFit.contain,
                    width: 210.w,
                  ),
                  /*  App_Text(
                    data: 'Khalid Gamal',
                    size: 11,
                    color: AppColors.kBG,
                  ), */
                ],
              ),
            ),
          ),
          // SizedBox(height: AppConst().getScreenSize().height * .01),
        ],
      ),
    );
  }
}
/* 
class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}
class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late Animation<double> opacity;
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(milliseconds: 600), vsync: this);
    opacity = Tween<double>(begin: 1.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.forward().then((_) {
      // setState(() {});
      navigationToPage();
    });
  }
  void navigationToPage() async {
    final GetStorage box = GetStorage();
    // box.remove('login_employee');
    // box.remove('email');
    // box.remove('Email_employee');
    bool isLogin = box.read("login_employee") ?? false;
    String isAdmin = box.read('email') ?? '';
    if (isAdmin == 'admin_employee@gmail.com') {
      Get.off(() => const Admin());
    } else if (isLogin == true) {
      Get.off(() => ClientScreen());
    } else {
      Get.off(() => const LoginEmployee());
    }
    printInfo(info: box.read('email'));
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Column(
        children: [
          Spacer(flex: 1),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 200,
              height: 200,
              clipBehavior: Clip.hardEdge,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(200)),
              child: SizedBox(
                child: Image.asset(
                  "assets/img/Fb.jpg",
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Spacer(flex: 2)
        ],
      ),
    );
  }
}
 */