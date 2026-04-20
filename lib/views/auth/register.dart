import 'package:cosmetics/core/common/widgets/app_images.dart';
import 'package:cosmetics/core/common/widgets/app_button.dart';
import 'package:cosmetics/core/common/widgets/app_phone_input.dart';
import 'package:cosmetics/core/common/widgets/app_input.dart';
import 'package:cosmetics/core/helpers/app_navigator.dart';
import 'package:cosmetics/core/helpers/app_validators.dart';
import 'package:cosmetics/core/helpers/extensions.dart';
import 'package:cosmetics/core/helpers/shared_pref_helper.dart';
import 'package:cosmetics/core/network/dio_helper.dart';
import 'package:cosmetics/core/theme/app_colors/light_app_colors.dart';
import 'package:cosmetics/core/theme/app_texts/app_text_styles.dart';
import 'package:cosmetics/core/utils/common_imports.dart';
import 'package:cosmetics/core/utils/shared_pref_keys.dart';
import 'package:cosmetics/views/auth/login.dart';
import 'package:cosmetics/views/auth/verify_code.dart';
import 'package:cosmetics/views/auth/widgets/auth_switcher_text.dart';
import 'package:cosmetics/views/auth/widgets/success_dialog.dart';
import 'package:cosmetics/views/home/view.dart';
import 'package:dio/dio.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final phoneController = TextEditingController();
  final passwordContoller = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String selectedCountryCode = "+20";
  bool isFormValid = false;
  final nameFocus = FocusNode();
  final emailFocus = FocusNode();
  final phoneFocus = FocusNode();
  final passwordFocus = FocusNode();
  final confirmFocus = FocusNode();

  @override
  void dispose() {
    phoneController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordContoller.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void validateForm() {
    final isValid =
        nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        passwordContoller.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;

    setState(() {
      isFormValid = isValid;
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(nameFocus);
    });
  }

  Future<void> register() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      final request = _RegisterRequest(
        username: nameController.text,
        countryCode: selectedCountryCode,
        phoneNumber: phoneController.text,
        email: emailController.text,
        password: passwordContoller.text,
      );

      final response = await DioHelper.post(
        "/api/Auth/register",
        data: request.toJson(),
      );

      final message = response.data["message"];

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));

      AppNavigator.push(
        VerifyCodeView(
          contact: 'your email ${emailController.text}',
          onSuccess: () => showDialog(
            context: context,
            builder: (context) {
              return AccountActivatedDialog(
                onTap: () async {
                  Navigator.pop(context);
                  await SharedPrefHelper.setData(
                    key: SharedPrefKeys.kIsRegistered,
                    value: true,
                  );
                  AppNavigator.pushAndRemoveUntil(HomeView());
                },
                title: 'Account Activated!',
                subTitle:
                    'Congratulations! Your account has been successfully activated',
                buttonTitle: 'Go to home',
              );
            },
          ),
          countryCode: selectedCountryCode,
          phoneNumber: phoneController.text,
        ),
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
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 12.w,
                right: 12.w,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Spacer(),
                        AppImages(
                          imagePath: '/app_logo.png',
                          height: 52.h,
                          width: 60.w,
                        ),
                        40.h.ph,
                        Text(
                          'Create Account',
                          style: AppTextStyles.font24Bold.copyWith(
                            color: LightAppColors.grey900,
                          ),
                        ),
                        70.h.ph,
                        AppInput(
                          focusNode: nameFocus,
                          onChanged: (_) => validateForm(),
                          labelText: 'Your Name',
                          validator: AppValidators.name,
                          controller: nameController,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(emailFocus);
                          },
                        ),
                        38.h.ph,
                        AppInput(
                          focusNode: emailFocus,
                          onChanged: (_) => validateForm(),
                          labelText: 'Email',
                          validator: AppValidators.email,
                          controller: emailController,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(phoneFocus);
                          },
                        ),
                        38.h.ph,
                        AppPhoneInput(
                          focusNode: phoneFocus,
                          onChanged: (_) => validateForm(),
                          phoneController: phoneController,
                          validator: AppValidators.phone,
                          onCountryChanged: (code) {
                            selectedCountryCode = code;
                          },
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(passwordFocus);
                          },
                        ),
                        16.h.ph,
                        AppInput(
                          focusNode: passwordFocus,
                          onChanged: (_) => validateForm(),
                          labelText: 'Create your password',
                          controller: passwordContoller,
                          isObscureText: true,
                          validator: AppValidators.password,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(confirmFocus);
                          },
                        ),
                        16.h.ph,
                        AppInput(
                          focusNode: confirmFocus,
                          onChanged: (_) => validateForm(),
                          labelText: 'Confirm password',
                          controller: confirmPasswordController,
                          isObscureText: true,
                          validator: (value) => AppValidators.confirmPassword(
                            value,
                            passwordContoller.text,
                          ),
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                        16.h.ph,
                        AppButton(
                          onTap: isFormValid
                              ? () {
                                  if (formKey.currentState!.validate()) {
                                    register();
                                  }
                                }
                              : null,
                          color: isFormValid
                              ? LightAppColors.primary800
                              : LightAppColors.grey400,
                          borderColor: isFormValid
                              ? LightAppColors.primary800
                              : LightAppColors.grey400,
                          text: isLoading ? 'Loading....' : 'Next',
                          width: 270.w,
                        ),
                        Spacer(),
                        AuthSwitcherText(
                          normalText: "Have an account? ",
                          actionText: "Login",
                          onTap: () {
                            AppNavigator.push(LoginView());
                          },
                        ),
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

class _RegisterRequest {
  final String username;
  final String countryCode;
  final String phoneNumber;
  final String email;
  final String password;

  _RegisterRequest({
    required this.username,
    required this.countryCode,
    required this.phoneNumber,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "countryCode": countryCode,
      "phoneNumber": phoneNumber,
      "email": email,
      "password": password,
    };
  }
}
