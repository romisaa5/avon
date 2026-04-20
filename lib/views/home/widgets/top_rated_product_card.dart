import 'package:cosmetics/core/common/widgets/app_images.dart';
import 'package:cosmetics/core/helpers/extensions.dart';
import 'package:cosmetics/core/theme/app_colors/light_app_colors.dart';
import 'package:cosmetics/core/theme/app_texts/app_text_styles.dart';
import 'package:cosmetics/core/utils/common_imports.dart';
import 'package:flutter/cupertino.dart';

class TopRatedProductCard extends StatelessWidget {
  const TopRatedProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.onPressed,
  });

  final String imageUrl;
  final String title;
  final String price;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: LightAppColors.background,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                AppImages(imagePath: imageUrl, width: double.infinity),
                Positioned(
                  top: 6.h,
                  right: 6.w,
                  child: CupertinoButton(
                    onPressed: onPressed,
                    child: Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: LightAppColors.grey0,
                      ),
                      child: AppImages(imagePath: '/add_cart.svg'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          8.h.ph,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font16SemiBold.copyWith(
                color: LightAppColors.primary800,
              ),
            ),
          ),
          6.h.ph,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Text(
              price,
              style: AppTextStyles.font16SemiBold.copyWith(
                color: LightAppColors.primary500,
              ),
            ),
          ),
          8.h.ph,
        ],
      ),
    );
  }
}
