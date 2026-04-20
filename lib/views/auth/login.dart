import 'package:cosmetics/core/common/widgets/app_images.dart';
import 'package:cosmetics/core/common/widgets/app_button.dart';
import 'package:cosmetics/core/common/widgets/app_phone_input.dart';
import 'package:cosmetics/core/common/widgets/app_input.dart';
import 'package:cosmetics/core/helpers/app_navigator.dart';
import 'package:cosmetics/core/helpers/app_validators.dart';
import 'package:cosmetics/core/helpers/extensions.dart';
import 'package:cosmetics/core/helpers/shared_pref_helper.dart';
import 'package:cosmetics/core/network/dio_helper.dart';
import 'package:cosmetics/core/network/token_storage.dart';
import 'package:cosmetics/core/theme/app_colors/light_app_colors.dart';
import 'package:cosmetics/core/theme/app_texts/app_text_styles.dart';
import 'package:cosmetics/core/utils/common_imports.dart' hide View;
import 'package:cosmetics/core/utils/shared_pref_keys.dart';
import 'package:cosmetics/views/auth/forget_password.dart';
import 'package:cosmetics/views/auth/register.dart';
import 'package:cosmetics/views/auth/widgets/auth_switcher_text.dart';
import 'package:cosmetics/views/home/view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart' hide View;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final phoneController = TextEditingController();
  final passwordContoller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String selectedCountryCode = "+20";
  bool isLoading = false;
  final phoneFocus = FocusNode();
  final passwordFocus = FocusNode();

  @override
  void dispose() {
    passwordContoller.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(phoneFocus);
    });
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final request = _LoginRequest(
        countryCode: "+20",
        phoneNumber: phoneController.text,
        password: passwordContoller.text,
      );

      final response = await DioHelper.post(
        "/api/Auth/login",
        data: request.toJson(),
      );

      final loginResponse = LoginResponse.fromJson(response.data);

      await TokenStorage.saveToken(loginResponse.token);

      setState(() {
        isLoading = false;
      });
      await SharedPrefHelper.setData(
        key: SharedPrefKeys.kIsRegistered,
        value: true,
      );

      AppNavigator.pushAndRemoveUntil(HomeView());
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? "Something went wrong";

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
                        AppImages(imagePath: '/login.png'),
                        Text(
                          'Login Now',
                          style: AppTextStyles.font24Bold.copyWith(
                            color: LightAppColors.grey900,
                          ),
                        ),
                        14.h.ph,
                        Text(
                          'Please enter the details below to continue',
                          style: AppTextStyles.font14Regular.copyWith(
                            color: LightAppColors.grey500,
                          ),
                        ),
                        40.h.ph,
                        AppPhoneInput(
                          focusNode: phoneFocus,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(passwordFocus);
                          },
                          phoneController: phoneController,
                          validator: AppValidators.phone,
                          onCountryChanged: (code) {
                            selectedCountryCode = code;
                          },
                        ),
                        8.h.ph,
                        AppInput(
                          focusNode: passwordFocus,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).unfocus();
                          },
                          labelText: 'Your Password',
                          controller: passwordContoller,
                          isObscureText: true,
                          validator: AppValidators.password,
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Align(
                            alignment: AlignmentGeometry.centerRight,
                            child: Text(
                              'Forget Password ?',
                              style: AppTextStyles.font14Regular.copyWith(
                                color: LightAppColors.secondary800,
                              ),
                            ),
                          ),
                          onPressed: () {
                            AppNavigator.push(ForgetPasswordView());
                          },
                        ),
                        AppButton(
                          text: isLoading ? 'Loading...' : 'Login',
                          width: 270.w,
                          onTap: login,
                        ),
                        Spacer(),
                        AuthSwitcherText(
                          normalText: "Don't have an account? ",
                          actionText: " Register",
                          onTap: () {
                            AppNavigator.push(RegisterView());
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

class _LoginRequest {
  final String countryCode;
  final String phoneNumber;
  final String password;

  _LoginRequest({
    required this.countryCode,
    required this.phoneNumber,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "countryCode": countryCode,
      "phoneNumber": phoneNumber,
      "password": password,
    };
  }
}

class LoginResponse {
  final String token;
  final User user;

  LoginResponse({required this.token, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final int id;
  final String username;
  final String email;
  final String phoneNumber;
  final String countryCode;
  final String role;
  final String profilePhotoUrl;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.countryCode,
    required this.role,
    required this.profilePhotoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      countryCode: json['countryCode'],
      role: json['role'],
      profilePhotoUrl: json['profilePhotoUrl'],
    );
  }
}
