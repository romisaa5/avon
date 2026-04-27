import 'dart:async';
import 'package:cosmetics/core/ui/widgets/app_images.dart';
import 'package:cosmetics/core/logic/helpers/app_navigator.dart';
import 'package:cosmetics/core/logic/helpers/extensions.dart';
import 'package:cosmetics/core/logic/helpers/shared_pref_helper.dart';
import 'package:cosmetics/core/logic/helpers/common_imports.dart';
import 'package:cosmetics/core/logic/helpers/shared_pref_keys.dart';
import 'package:cosmetics/views/auth/login.dart';
import 'package:cosmetics/views/home/view.dart';
import 'package:cosmetics/views/on_boarding.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() {
    Future.delayed(const Duration(seconds: 5), () {
      final isSeen = SharedPrefHelper.getBool(
        key: SharedPrefKeys.kIsOnBoardingSeen,
      );

      final isRegistered = SharedPrefHelper.getBool(
        key: SharedPrefKeys.kIsRegistered,
      );
      if (isSeen == true && isRegistered != true) {
        AppNavigator.pushAndRemoveUntil(LoginView());
      } else if (isRegistered == true) {
        AppNavigator.pushAndRemoveUntil(HomeView());
      } else {
        AppNavigator.pushAndRemoveUntil(OnBoardingView());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppImages(imagePath: '/app_logo.png', height: 200.h, width: 200.w),
            16.h.ph,
            AppImages(
              imagePath: '/splash_text.png',
              width: 120.w,
              height: 46.h,
            ),
          ],
        ),
      ),
    );
  }
}
