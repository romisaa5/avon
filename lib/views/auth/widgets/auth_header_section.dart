import 'package:cosmetics/core/ui/widgets/app_images.dart';
import 'package:cosmetics/core/logic/helpers/extensions.dart';
import 'package:cosmetics/core/ui/theme/app_colors/light_app_colors.dart';
import 'package:cosmetics/core/ui/theme/app_texts/app_text_styles.dart';
import 'package:cosmetics/core/logic/helpers/common_imports.dart';

class AuthHeaderSection extends StatelessWidget {
  const AuthHeaderSection({
    super.key,
    required this.title,
    required this.subTitle,
  });
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppImages(imagePath: '/app_logo.png', height: 52.h, width: 60.w),
        40.h.ph,
        Text(
          title,
          style: AppTextStyles.font24Bold.copyWith(
            color: LightAppColors.grey900,
          ),
        ),
        40.h.ph,
        Text(
          subTitle,
          style: AppTextStyles.font14Regular.copyWith(
            color: LightAppColors.grey500,
          ),
          textAlign: TextAlign.center,
        ),
        40.h.ph,
      ],
    );
  }
}
