import 'package:cosmetics/core/ui/widgets/app_button.dart';
import 'package:cosmetics/core/ui/widgets/app_input.dart';
import 'package:cosmetics/core/logic/helpers/app_navigator.dart';
import 'package:cosmetics/core/logic/helpers/app_validators.dart';
import 'package:cosmetics/core/logic/helpers/extensions.dart';
import 'package:cosmetics/core/logic/network/dio_helper.dart';
import 'package:cosmetics/core/logic/helpers/common_imports.dart';
import 'package:cosmetics/views/auth/login.dart';
import 'package:cosmetics/views/auth/widgets/auth_header_section.dart';
import 'package:cosmetics/views/auth/widgets/success_dialog.dart';
import 'package:dio/dio.dart';

class CreateNewPasswordView extends StatefulWidget {
  const CreateNewPasswordView({
    super.key,
    required this.countryCode,
    required this.phoneNumber,
  });

  final String countryCode;
  final String phoneNumber;

  @override
  State<CreateNewPasswordView> createState() => _CreateNewPasswordViewState();
}

class _CreateNewPasswordViewState extends State<CreateNewPasswordView> {
  final passwordContoller = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    passwordContoller.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    final request = ResetPasswordRequest(
      countryCode: widget.countryCode,
      phoneNumber: widget.phoneNumber,
      newPassword: passwordContoller.text,
      confirmPassword: confirmPasswordController.text,
    );

    try {
      final response = await DioHelper.post(
        "/api/Auth/reset-password",
        data: request.toJson(),
      );

      final message =
          response.data["message"] ?? "Password reset successfully.";

      setState(() {
        isLoading = false;
      });

      showDialog(
        context: context,
        builder: (context) {
          return AccountActivatedDialog(
            title: 'Password Reset!',
            subTitle: message,
            buttonTitle: 'Return to login',
            onTap: () {
              Navigator.pop(context);
              AppNavigator.pushAndRemoveUntil(LoginView());
            },
          );
        },
      );
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
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.arrow_back_ios),
                          ),
                        ),
                        40.h.ph,
                        Flexible(
                          child: AuthHeaderSection(
                            title: 'Create Password',
                            subTitle:
                                'The password should have at least 6 characters.',
                          ),
                        ),
                        62.h.ph,
                        AppInput(
                          labelText: 'Create your password',
                          controller: passwordContoller,
                          isObscureText: true,
                          validator: AppValidators.password,
                        ),
                        16.h.ph,
                        AppInput(
                          labelText: 'Confirm password',
                          controller: confirmPasswordController,
                          isObscureText: true,
                          validator: (value) => AppValidators.confirmPassword(
                            value,
                            passwordContoller.text,
                          ),
                        ),
                        60.h.ph,
                        AppButton(
                          onTap: isLoading ? null : resetPassword,
                          text: isLoading ? 'Processing...' : 'Confirm',
                          width: 270.w,
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

class ResetPasswordRequest {
  final String countryCode;
  final String phoneNumber;
  final String newPassword;
  final String confirmPassword;

  ResetPasswordRequest({
    required this.countryCode,
    required this.phoneNumber,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      "countryCode": countryCode,
      "phoneNumber": phoneNumber,
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
    };
  }
}
