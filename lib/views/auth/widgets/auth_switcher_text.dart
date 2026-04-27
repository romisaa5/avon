import 'package:cosmetics/core/ui/theme/app_colors/light_app_colors.dart';
import 'package:cosmetics/core/ui/theme/app_texts/app_text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthSwitcherText extends StatelessWidget {
  final String normalText;
  final String actionText;
  final VoidCallback onTap;

  const AuthSwitcherText({
    super.key,
    required this.normalText,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: normalText,
        style: AppTextStyles.font12Regular.copyWith(
          color: LightAppColors.grey800,
        ),
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: onTap,
              child: Text(
                actionText,
                style: AppTextStyles.font12SemiBold.copyWith(
                  color: LightAppColors.secondary800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
