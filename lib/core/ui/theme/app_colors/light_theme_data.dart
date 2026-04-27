import 'package:cosmetics/core/ui/theme/app_colors/light_app_colors.dart';
import 'package:cosmetics/core/ui/theme/app_texts/font_weight_helper.dart';
import 'package:cosmetics/core/logic/helpers/common_imports.dart';
import '../app_texts/app_fonts.dart';

ThemeData getLightTheme(BuildContext context) {
  return ThemeData(
    scaffoldBackgroundColor: LightAppColors.background,
    brightness: Brightness.light,
    fontFamily: AppFonts.cairo,
    colorScheme: ColorScheme.fromSeed(
      seedColor: LightAppColors.primary800,
      brightness: Brightness.light,
    ),
    appBarTheme: AppBarTheme(
      surfaceTintColor: Colors.transparent,
      backgroundColor: LightAppColors.background,
      elevation: 0,
      iconTheme: const IconThemeData(color: LightAppColors.grey900),
      titleTextStyle: TextStyle(
        color: LightAppColors.grey900,
        fontSize: 18.sp,
        fontWeight: FontWeightHelper.semiBold,
        fontFamily: AppFonts.cairo,
      ),
    ),
    textTheme: ThemeData.light().textTheme.apply(
      bodyColor: LightAppColors.grey900,
      displayColor: LightAppColors.grey900,
      fontFamily: AppFonts.cairo,
    ),
  );
}
