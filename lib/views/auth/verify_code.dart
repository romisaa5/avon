import 'package:cosmetics/core/ui/widgets/app_images.dart';
import 'package:cosmetics/core/ui/widgets/app_button.dart';
import 'package:cosmetics/core/logic/helpers/app_navigator.dart';
import 'package:cosmetics/core/logic/helpers/extensions.dart';
import 'package:cosmetics/core/logic/network/dio_helper.dart';
import 'package:cosmetics/core/ui/theme/app_colors/light_app_colors.dart';
import 'package:cosmetics/core/ui/theme/app_texts/app_text_styles.dart';
import 'package:cosmetics/core/logic/helpers/common_imports.dart';
import 'package:cosmetics/views/auth/register.dart';
import 'package:cosmetics/views/auth/widgets/otp_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class VerifyCodeView extends StatefulWidget {
  const VerifyCodeView({
    super.key,
    required this.contact,
    required this.countryCode,
    required this.phoneNumber,

    this.onSuccess,
  });
  final String countryCode;
  final String phoneNumber;
  final String contact;
  final VoidCallback? onSuccess;

  @override
  State<VerifyCodeView> createState() => _VerifyCodeViewState();
}

class _VerifyCodeViewState extends State<VerifyCodeView> {
  final formKey = GlobalKey<FormState>();
  String otpCode = '';
  bool isLoading = false;

  Future<void> verifyOtp() async {
    if (otpCode.isEmpty || otpCode.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 4-digit OTP code')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final request = _VerifyOtpRequest(
      countryCode: widget.countryCode,
      phoneNumber: widget.phoneNumber,
      otpCode: otpCode,
    );

    try {
      final response = await DioHelper.post(
        "/api/Auth/verify-otp",
        data: request.toJson(),
      );

      final message = response.data["message"] ?? "Account verified!";

      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));

      if (widget.onSuccess != null) widget.onSuccess!();
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data["message"] ?? "Something went wrong";

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(12.h),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back_ios),
                          ),
                        ),
                        Spacer(),
                        AppImages(
                          imagePath: '/app_logo.png',
                          height: 52.h,
                          width: 60.w,
                        ),
                        40.h.ph,
                        Text(
                          'Verify Code',
                          style: AppTextStyles.font24Bold.copyWith(
                            color: LightAppColors.primary800,
                          ),
                        ),
                        40.h.ph,
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: AppTextStyles.font14SemiBold.copyWith(
                              color: LightAppColors.grey500,
                            ),
                            children: [
                              const TextSpan(
                                text:
                                    'We just sent a 4-digit verification code to ',
                              ),
                              TextSpan(
                                text: widget.contact,
                                style: AppTextStyles.font14Bold.copyWith(
                                  color: LightAppColors.primary800,
                                ),
                              ),
                              const TextSpan(
                                text:
                                    '. Enter the code in the box below to continue.',
                              ),
                            ],
                          ),
                        ),
                        40.h.ph,
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            AppNavigator.push(RegisterView());
                          },
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Edit the number',
                              style: AppTextStyles.font14Regular.copyWith(
                                color: LightAppColors.secondary800,
                              ),
                            ),
                          ),
                        ),
                        20.h.ph,
                        OtpField(
                          onCompleted: (code) {
                            setState(() {
                              otpCode = code;
                            });
                          },
                          countryCode: widget.countryCode,
                          phoneNumber: widget.phoneNumber,
                        ),
                        Spacer(),
                        AppButton(
                          text: isLoading ? 'Verifying...' : 'Done',
                          width: 270.w,
                          onTap: isLoading ? null : verifyOtp,
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _VerifyOtpRequest {
  final String countryCode;
  final String phoneNumber;
  final String otpCode;

  _VerifyOtpRequest({
    required this.countryCode,
    required this.phoneNumber,
    required this.otpCode,
  });

  Map<String, dynamic> toJson() {
    return {
      "countryCode": countryCode,
      "phoneNumber": phoneNumber,
      "otpCode": otpCode,
    };
  }
}
