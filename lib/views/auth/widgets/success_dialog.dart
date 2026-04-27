import 'package:cosmetics/core/ui/widgets/app_images.dart';
import 'package:cosmetics/core/ui/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cosmetics/core/ui/theme/app_colors/light_app_colors.dart';
import 'package:cosmetics/core/ui/theme/app_texts/app_text_styles.dart';

class AccountActivatedDialog extends StatelessWidget {
  const AccountActivatedDialog({
    super.key,
    required this.title,
    required this.subTitle,
    required this.buttonTitle,
    this.onTap,
  });
  final String title;
  final String subTitle;
  final String buttonTitle;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      backgroundColor: LightAppColors.background,
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppImages(imagePath: '/done.svg'),
            SizedBox(height: 20.h),
            Text(
              title,
              style: AppTextStyles.font16SemiBold.copyWith(
                color: LightAppColors.grey900,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            Text(
              subTitle,
              style: AppTextStyles.font12Regular.copyWith(
                color: LightAppColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 25.h),
            AppButton(text: buttonTitle, onTap: onTap),
          ],
        ),
      ),
    );
  }
}
