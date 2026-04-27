import 'package:cosmetics/core/ui/widgets/app_button.dart';
import 'package:cosmetics/core/ui/widgets/app_phone_input.dart';
import 'package:cosmetics/core/logic/helpers/app_navigator.dart';
import 'package:cosmetics/core/logic/helpers/extensions.dart';
import 'package:cosmetics/core/logic/network/dio_helper.dart';
import 'package:cosmetics/core/logic/helpers/common_imports.dart';
import 'package:cosmetics/views/auth/create_new_password.dart';
import 'package:cosmetics/views/auth/verify_code.dart';
import 'package:cosmetics/views/auth/widgets/auth_header_section.dart';
import 'package:dio/dio.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String selectedCountryCode = "+20";

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void sendForgetPassword() async {
    if (!formKey.currentState!.validate()) return;

    final request = _ForgetPasswordRequest(
      countryCode: selectedCountryCode,
      phoneNumber: phoneController.text,
    );

    try {
      final response = await DioHelper.post(
        "/api/Auth/forgot-password",
        data: request.toJson(),
      );

      final message = response.data["message"] ?? "OTP sent successfully.";

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));

      AppNavigator.push(
        VerifyCodeView(
          contact: "$selectedCountryCode ${phoneController.text}",
          countryCode: selectedCountryCode,
          phoneNumber: phoneController.text,
          onSuccess: () {
            AppNavigator.push(
              CreateNewPasswordView(
                countryCode: selectedCountryCode,
                phoneNumber: phoneController.text,
              ),
            );
          },
        ),
      );
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data["message"] ?? "Something went wrong";
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  AuthHeaderSection(
                    title: 'Forget Password',
                    subTitle:
                        'Please enter your phone number below to recover your password.',
                  ),
                  40.h.ph,
                  AppPhoneInput(
                    phoneController: phoneController,
                    onCountryChanged: (code) {
                      selectedCountryCode = code;
                    },
                  ),
                  55.h.ph,
                  AppButton(
                    onTap: sendForgetPassword,
                    text: 'Next',
                    width: 270.w,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ForgetPasswordRequest {
  final String countryCode;
  final String phoneNumber;

  _ForgetPasswordRequest({
    required this.countryCode,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {"countryCode": countryCode, "phoneNumber": phoneNumber};
  }
}
