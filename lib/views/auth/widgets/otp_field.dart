import 'dart:async';
import 'package:cosmetics/core/common/widgets/app_input.dart';
import 'package:cosmetics/core/helpers/extensions.dart';
import 'package:cosmetics/core/network/dio_helper.dart';
import 'package:cosmetics/core/theme/app_colors/light_app_colors.dart';
import 'package:cosmetics/core/theme/app_texts/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';

class OtpField extends StatefulWidget {
  final int length;
  final void Function(String) onCompleted;
  final String countryCode;
  final String phoneNumber;

  const OtpField({
    super.key,
    this.length = 4,
    required this.onCompleted,
    required this.countryCode,
    required this.phoneNumber,
  });

  @override
  State<OtpField> createState() => _OtpFieldState();
}

class _OtpFieldState extends State<OtpField> {
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  Timer? _timer;
  int _seconds = 60;
  bool canResend = false;
  bool isResending = false;

  @override
  void initState() {
    super.initState();

    controllers = List.generate(widget.length, (_) => TextEditingController());
    focusNodes = List.generate(widget.length, (_) => FocusNode());

    for (int i = 0; i < controllers.length; i++) {
      controllers[i].addListener(() {
        setState(() {});
      });
    }

    _startTimer();
  }

  void _startTimer() {
    _seconds = 60;
    canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else {
        setState(() {
          canResend = true;
        });
        _timer?.cancel();
      }
    });
  }

  Future<void> _resendOtp() async {
    if (!canResend) return;

    setState(() {
      isResending = true;
    });

    try {
      final request = _ResendOtpRequest(
        countryCode: widget.countryCode,
        phoneNumber: widget.phoneNumber,
      );

      final response = await DioHelper.post(
        "/api/Auth/resend-otp",
        data: request.toJson(),
      );
      final message = response.data["message"] ?? "OTP resent successfully.";
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      _startTimer();
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data["message"] ?? "Something went wrong";
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } finally {
      setState(() {
        isResending = false;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in controllers) c.dispose();
    for (var f in focusNodes) f.dispose();
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        focusNodes[index + 1].requestFocus();
      }
    } else {
      if (index > 0) {
        focusNodes[index - 1].requestFocus();
        controllers[index - 1].selection = TextSelection.fromPosition(
          TextPosition(offset: controllers[index - 1].text.length),
        );
      }
    }

    String code = controllers.map((e) => e.text).join();

    if (code.length == widget.length && !code.contains("")) {
      widget.onCompleted(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    String minutesStr = (_seconds ~/ 60).toString().padLeft(1, '0');
    String secondsStr = (_seconds % 60).toString().padLeft(2, '0');

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.length, (index) {
            return Container(
              width: 60.w,
              height: 65.w,
              margin: EdgeInsets.symmetric(horizontal: 5.w),
              child: AppInput(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(1),
                ],
                controller: controllers[index],
                focusNode: focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                onChanged: (value) => _onChanged(index, value),
              ),
            );
          }),
        ),
        10.h.ph,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Didn't receive a code? ",
              style: AppTextStyles.font12Regular.copyWith(
                color: LightAppColors.grey600,
              ),
            ),
            GestureDetector(
              onTap: canResend && !isResending ? _resendOtp : null,
              child: Text(
                isResending ? "Resending..." : " Resend",
                style: AppTextStyles.font12Regular.copyWith(
                  color: canResend && !isResending
                      ? LightAppColors.secondary800
                      : LightAppColors.grey500,
                ),
              ),
            ),
            10.w.pw,
            Text(
              "$minutesStr:$secondsStr",
              style: AppTextStyles.font12Regular.copyWith(
                color: LightAppColors.grey600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ResendOtpRequest {
  final String countryCode;
  final String phoneNumber;

  _ResendOtpRequest({required this.countryCode, required this.phoneNumber});

  Map<String, dynamic> toJson() {
    return {"countryCode": countryCode, "phoneNumber": phoneNumber};
  }
}
