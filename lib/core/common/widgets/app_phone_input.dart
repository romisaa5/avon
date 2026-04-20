import 'package:cosmetics/core/common/widgets/app_input.dart';
import 'package:cosmetics/core/helpers/extensions.dart';
import 'package:cosmetics/core/logic/models/country.dart';
import 'package:cosmetics/core/logic/services/country_service.dart';
import 'package:cosmetics/core/theme/app_texts/app_text_styles.dart';
import 'package:cosmetics/core/theme/app_colors/light_app_colors.dart';
import 'package:cosmetics/core/utils/common_imports.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class AppPhoneInput extends StatefulWidget {
  final TextEditingController phoneController;
  final Function(String completePhone)? onChanged;
  final String? Function(String?)? validator;
  final Function(String countryCode)? onCountryChanged;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;

  const AppPhoneInput({
    super.key,
    required this.phoneController,
    this.onChanged,
    this.validator,
    this.onCountryChanged,
    this.focusNode,
    this.onFieldSubmitted,
  });

  @override
  State<AppPhoneInput> createState() => _AppPhoneInputState();
}

class _AppPhoneInputState extends State<AppPhoneInput> {
  final countryNotifier = ValueNotifier<String>("+20");
  List<Country> countries = [];

  @override
  void initState() {
    super.initState();
    loadCountries();
  }

  Future<void> loadCountries() async {
    await CountryService().fetchCountries();
    if (CountryService().countries.isNotEmpty) {
      countryNotifier.value = CountryService().countries.first.code;
    }
    setState(() {
      countries = CountryService().countries;
    });
  }

  void _updateFullNumber() {
    final fullNumber = "${countryNotifier.value}${widget.phoneController.text}";
    widget.onChanged?.call(fullNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 120.w,
          height: 55.h,
          decoration: BoxDecoration(
            color: LightAppColors.background,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: LightAppColors.grey500),
          ),
          child: ValueListenableBuilder<String>(
            valueListenable: countryNotifier,
            builder: (context, value, child) {
              return DropdownButton2<String>(
                isExpanded: true,
                valueListenable: countryNotifier,
                selectedItemBuilder: (context) {
                  return countries.map((c) {
                    return SizedBox(
                      height: 50.h,
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          c.code,
                          style: AppTextStyles.font14Regular.copyWith(
                            color: LightAppColors.grey600,
                          ),
                        ),
                      ),
                    );
                  }).toList();
                },
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 300.h,
                  width: 250.w,
                  decoration: BoxDecoration(
                    color: LightAppColors.background,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 8,
                  scrollbarTheme: ScrollbarThemeData(
                    thumbColor: WidgetStateProperty.all(LightAppColors.grey500),
                    radius: Radius.circular(8.r),
                    thickness: WidgetStateProperty.all(5),
                  ),
                ),
                items: countries
                    .map(
                      (c) => DropdownItem<String>(
                        value: c.code,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                c.nameEn,
                                style: AppTextStyles.font14Regular.copyWith(
                                  color: LightAppColors.grey600,
                                ),
                              ),
                              Spacer(),
                              Text(
                                c.code,
                                style: AppTextStyles.font14Regular.copyWith(
                                  color: LightAppColors.grey600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val == null) return;
                  countryNotifier.value = val;
                  _updateFullNumber();
                  widget.onCountryChanged?.call(val);
                },
                underline: Container(),
              );
            },
          ),
        ),

        10.w.pw,
        Expanded(
          child: AppInput(
            focusNode: widget.focusNode,
            onFieldSubmitted: widget.onFieldSubmitted,
            keyboardType: TextInputType.number,
            onChanged: (_) => _updateFullNumber(),
            labelText: 'Phone Number',
            controller: widget.phoneController,
            validator: widget.validator,
          ),
        ),
      ],
    );
  }
}
