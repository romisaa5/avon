import 'package:cosmetics/core/theme/app_colors/light_app_colors.dart';
import 'package:cosmetics/core/theme/app_texts/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppInput extends StatefulWidget {
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? inputTextStyle;
  final TextStyle? hintStyle;
  final String? labelText;
  final bool? isObscureText;
  final Widget? suffixIcon;
  final Color? backgroundColor;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final InputBorder? errorBorder;
  final int? maxLines;
  final bool isUnderline;
  final TextInputType? keyboardType;
  final TextAlign? textAlign;
  final bool isBorder;
  final void Function(String)? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool autoFocus;

  const AppInput({
    super.key,
    this.autoFocus = true,
    this.contentPadding,
    this.focusedBorder,
    this.enabledBorder,
    this.inputTextStyle,
    this.hintStyle,
    this.labelText,
    this.isObscureText,
    this.suffixIcon,
    this.backgroundColor,
    this.controller,
    this.validator,
    this.prefixIcon,
    this.focusNode,
    this.onChanged,
    this.errorBorder,
    this.maxLines,
    this.isUnderline = false,
    this.keyboardType,
    this.textAlign,
    this.isBorder = true,
    this.onFieldSubmitted,
    this.inputFormatters,
  });

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.isObscureText ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    InputBorder border = widget.isUnderline
        ? UnderlineInputBorder(
            borderSide: BorderSide(
              color: widget.isBorder
                  ? LightAppColors.grey600.withValues(alpha: .4)
                  : Colors.transparent,
              width: 1.w,
            ),
          )
        : OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: widget.isBorder
                  ? LightAppColors.grey600.withValues(alpha: .4)
                  : Colors.transparent,
              width: 1.w,
            ),
          );

    return FormField<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              inputFormatters: widget.inputFormatters,
              onFieldSubmitted: widget.onFieldSubmitted,
              autofocus: widget.autoFocus,
              keyboardType: widget.keyboardType,
              textAlign: widget.textAlign ?? TextAlign.start,
              maxLines: widget.maxLines ?? 1,
              controller: widget.controller,
              onChanged: (value) {
                state.didChange(value);
                widget.onChanged?.call(value);
              },
              focusNode: widget.focusNode,
              obscureText: _isObscure,
              cursorColor: LightAppColors.primary800,
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    widget.contentPadding ??
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                focusedBorder:
                    widget.focusedBorder ??
                    border.copyWith(
                      borderSide: BorderSide(
                        color: widget.isBorder
                            ? LightAppColors.secondary800
                            : Colors.transparent,
                        width: 1.5.w,
                      ),
                    ),
                enabledBorder: widget.enabledBorder ?? border,
                errorBorder:
                    widget.errorBorder ??
                    border.copyWith(
                      borderSide: BorderSide(
                        color: colorScheme.error,
                        width: 1.2.w,
                      ),
                    ),
                focusedErrorBorder:
                    widget.errorBorder ??
                    border.copyWith(
                      borderSide: BorderSide(
                        color: colorScheme.error,
                        width: 1.2.w,
                      ),
                    ),

                labelText: widget.labelText,
                labelStyle:
                    widget.hintStyle ??
                    AppTextStyles.font14Regular.copyWith(
                      color: LightAppColors.grey500,
                    ),
                suffixIcon: widget.isObscureText == true
                    ? IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility,
                          color: LightAppColors.grey500,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      )
                    : widget.suffixIcon,
                prefixIcon: widget.prefixIcon,
                fillColor: widget.backgroundColor ?? LightAppColors.background,
                filled: true,
              ),
              style:
                  widget.inputTextStyle ??
                  AppTextStyles.font16Regular.copyWith(
                    color: colorScheme.secondary,
                  ),
            ),
            if (state.hasError)
              Padding(
                padding: EdgeInsets.only(top: 6.h, left: 8.w),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: colorScheme.error,
                      size: 16.sp,
                    ),
                    5.w.horizontalSpace,
                    Flexible(
                      child: Text(
                        state.errorText ?? '',
                        style: AppTextStyles.font12Regular.copyWith(
                          color: colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
