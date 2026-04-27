import 'package:cosmetics/core/logic/helpers/app_navigator.dart';
import 'package:cosmetics/core/ui/theme/app_colors/light_app_colors.dart';
import 'package:cosmetics/core/logic/helpers/common_imports.dart';

class SnackbarHelper {
  static void showSuccessSnackbar(String message, {VoidCallback? onDismissed}) {
    final context = AppNavigator.context;
    if (context == null) return;
    final snackBar = SnackBar(
      content: Text(message, style: TextStyle(color: LightAppColors.grey0)),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(vertical: 28.h, horizontal: 16.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(500.r)),
      backgroundColor: LightAppColors.primary800,
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((_) {
      if (onDismissed != null) {
        onDismissed();
      }
    });
  }

  static void showErrorSnackbar(String message) {
    final context = AppNavigator.context;
    if (context == null) return;
    final snackBar = SnackBar(
      content: Text(message, style: TextStyle(color: LightAppColors.grey0)),
      backgroundColor: LightAppColors.error900,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(vertical: 28.h, horizontal: 16.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(500.r)),
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
