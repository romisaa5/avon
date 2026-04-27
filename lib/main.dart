import 'package:cosmetics/core/helpers/app_navigator.dart';
import 'package:cosmetics/core/helpers/shared_pref_helper.dart';
import 'package:cosmetics/core/network/dio_helper.dart';
import 'package:cosmetics/core/theme/app_colors/light_theme_data.dart';
import 'package:cosmetics/views/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefHelper.init();
  await DioHelper.init();
  await ScreenUtil.ensureScreenSize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          navigatorKey: AppNavigator.navigatorKey,
          home: const SplashView(),
          debugShowCheckedModeBanner: false,
          theme: getLightTheme(context),
        );
      },
    );
  }
}
