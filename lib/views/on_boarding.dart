import 'package:animate_do/animate_do.dart';
import 'package:cosmetics/core/ui/widgets/app_images.dart';
import 'package:cosmetics/core/ui/widgets/app_button.dart';
import 'package:cosmetics/core/logic/helpers/app_navigator.dart';
import 'package:cosmetics/core/logic/helpers/extensions.dart';
import 'package:cosmetics/core/logic/helpers/shared_pref_helper.dart';
import 'package:cosmetics/core/ui/theme/app_colors/light_app_colors.dart';
import 'package:cosmetics/core/ui/theme/app_texts/app_text_styles.dart';
import 'package:cosmetics/core/logic/helpers/common_imports.dart';
import 'package:cosmetics/core/logic/helpers/shared_pref_keys.dart';
import 'package:cosmetics/views/auth/login.dart';
import 'package:flutter/cupertino.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final _controller = PageController();
  int currentIndex = 0;

  final pages = [
    _OnBoarding(
      image: '/on_boarding1.png',
      title: "WELCOME!",
      description:
          "Makeup has the power to transform your mood and empowers you to be a more confident person.",
    ),
    _OnBoarding(
      image: '/on_boarding2.png',
      title: "SEARCH & PICK",
      description:
          "We have dedicated set of products and routines hand picked for every skin type.",
    ),
    _OnBoarding(
      image: '/on_boarding3.png',
      title: "PUSH NOTIFICATIONS",
      description: "Allow notifications for new makeup & cosmetics offers.",
    ),
  ];

  void nextPage(BuildContext context) async {
    if (currentIndex < pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      await SharedPrefHelper.setData(
        key: SharedPrefKeys.kIsOnBoardingSeen,
        value: true,
      );
      AppNavigator.pushAndRemoveUntil(LoginView());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () async {
                  await SharedPrefHelper.setData(
                    key: SharedPrefKeys.kIsOnBoardingSeen,
                    value: true,
                  );
                  AppNavigator.pushAndRemoveUntil(LoginView());
                },
                child: const Text("Skip"),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(flex: 1),
                        BounceIn(
                          duration: const Duration(milliseconds: 800),
                          child: AppImages(
                            imagePath: page.image,
                            height: 260.h,
                          ),
                        ),
                        24.h.ph,
                        FadeInDown(
                          duration: const Duration(milliseconds: 500),
                          child: Text(
                            page.title,
                            style: AppTextStyles.font16Bold.copyWith(
                              color: LightAppColors.grey900,
                            ),
                          ),
                        ),
                        10.h.ph,
                        FadeIn(
                          delay: const Duration(milliseconds: 300),
                          duration: const Duration(milliseconds: 500),
                          child: Text(
                            page.description,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.font16SemiBold.copyWith(
                              color: LightAppColors.grey600,
                            ),
                          ),
                        ),
                        30.h.ph,
                        currentIndex == pages.length - 1
                            ? FadeInUp(
                                duration: const Duration(milliseconds: 500),
                                child: AppButton(
                                  text: 'let’s start!',
                                  color: LightAppColors.primary800,
                                  onTap: () => nextPage(context),
                                ),
                              )
                            : FadeInUp(
                                duration: const Duration(milliseconds: 500),
                                child: CupertinoButton(
                                  onPressed: () => nextPage(context),
                                  child: Container(
                                    height: 50.w,
                                    width: 50.w,
                                    decoration: BoxDecoration(
                                      color: LightAppColors.primary800,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: LightAppColors.white,
                                    ),
                                  ),
                                ),
                              ),
                        Spacer(flex: 2),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnBoarding {
  final String image;
  final String title;
  final String description;

  _OnBoarding({
    required this.image,
    required this.title,
    required this.description,
  });
}
