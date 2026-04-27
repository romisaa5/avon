import 'package:cosmetics/core/ui/widgets/app_images.dart';
import 'package:cosmetics/core/logic/helpers/app_navigator.dart';
import 'package:cosmetics/core/logic/helpers/extensions.dart';
import 'package:cosmetics/core/logic/network/dio_helper.dart';
import 'package:cosmetics/core/logic/network/token_storage.dart';
import 'package:cosmetics/core/ui/theme/app_colors/light_app_colors.dart';
import 'package:cosmetics/core/ui/theme/app_texts/app_text_styles.dart';
import 'package:cosmetics/core/logic/helpers/common_imports.dart';
import 'package:cosmetics/views/auth/login.dart';
import 'package:cosmetics/views/home/account.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  Future<void> logout(BuildContext context) async {
    try {
      await DioHelper.post("/api/Auth/logout");
      await TokenStorage.deleteToken();
      AppNavigator.pushAndRemoveUntil(const LoginView());
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error logging out")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 160.h,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff434C6D).withValues(alpha: .83),
                    Color(0xffECA4C5).withValues(alpha: .8),
                    Color(0xffECA4C5),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 60.h,
                width: MediaQuery.of(context).size.width,
                color: LightAppColors.background,
              ),
            ),
            Positioned(
              top: 60.h,
              child: CircleAvatar(
                radius: 50.r,
                backgroundColor: LightAppColors.grey200,
                child: Icon(
                  Icons.person,
                  size: 40.sp,
                  color: LightAppColors.primary800,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              12.h.ph,
              Text(
                "Sara Samer Talaat",
                style: AppTextStyles.font16SemiBold.copyWith(
                  color: LightAppColors.primary800,
                ),
              ),
              32.h.ph,
              ProfileItem(
                icon: '/edit_info.svg',
                title: "Edit Info",
                onTap: () {
                  AppNavigator.push(AccountView());
                },
              ),
              ProfileItem(
                icon: '/order_history.svg',
                title: "Order history",
                onTap: () {},
              ),
              ProfileItem(icon: '/wallet.svg', title: "Wallet", onTap: () {}),
              ProfileItem(
                icon: '/settings.svg',
                title: "Settings",
                onTap: () {},
              ),
              ProfileItem(icon: '/voucher.svg', title: "Voucher", onTap: () {}),
              20.h.ph,
              InkWell(
                onTap: () => logout(context),
                child: Row(
                  children: [
                    AppImages(imagePath: '/logout.svg', width: 20.w),
                    8.w.pw,
                    Text(
                      "Logout",
                      style: AppTextStyles.font14SemiBold.copyWith(
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileItem extends StatelessWidget {
  const ProfileItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final String icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        18.h.ph,
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              AppImages(imagePath: icon, width: 20.w),
              12.w.pw,
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.font14Regular.copyWith(
                    color: LightAppColors.primary800,
                  ),
                ),
              ),
              AppImages(imagePath: '/forward.svg'),
            ],
          ),
        ),
        18.h.ph,
      ],
    );
  }
}
