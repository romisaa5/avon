import 'package:cosmetics/core/common/widgets/app_button.dart';
import 'package:cosmetics/core/common/widgets/app_images.dart';
import 'package:cosmetics/core/helpers/extensions.dart';
import 'package:cosmetics/core/theme/app_colors/light_app_colors.dart';
import 'package:cosmetics/core/theme/app_texts/app_text_styles.dart';
import 'package:cosmetics/core/utils/common_imports.dart';
import 'package:cosmetics/views/check_out/widgets/selection_google_maps_card.dart';

class CheckOutView extends StatelessWidget {
  const CheckOutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Container(
              color: Color(0xff29D3DA).withValues(alpha: .11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  10.h.ph,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 27.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Delivery to'),
                        10.h.ph,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: SelectionGoogleMapsCard(
                            icon: Icons.location_on_outlined,
                            title: 'Home',
                            subtitle: 'Mansoura, 14 Forsaid St',
                            showDropdown: true,
                          ),
                        ),
                        20.h.ph,
                        _buildSectionTitle('Payment Method'),
                        10.h.ph,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: Column(
                            children: [
                              _buildPaymentCard(),
                              10.h.ph,
                              _buildVoucherInput(),
                            ],
                          ),
                        ),
                        20.h.ph,
                        _buildReviewPaymentLabel(),
                        20.h.ph,
                        _buildPaymentSummary(),
                        35.h.ph,
                        _buildOrderButton(),
                        10.h.ph,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Color(0xffD9D9D9),
      height: 100.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios_new, size: 24.sp),
          ),

          Text(
            'Checkout',
            style: AppTextStyles.font24Bold.copyWith(
              color: LightAppColors.primary800,
            ),
          ),
          30.w.pw,
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.font14Medium.copyWith(
        color: LightAppColors.primary800,
      ),
    );
  }

  Widget _buildPaymentCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF73B9BB), width: 1.5),
      ),
      child: Row(
        children: [
          AppImages(imagePath: '/meza.svg'),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '**** **** **** 0256',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
          ),
          const Icon(Icons.expand_more, color: Color(0xFFE91E63), size: 24),
        ],
      ),
    );
  }

  Widget _buildVoucherInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF73B9BB), width: 1.5),
      ),
      child: Row(
        children: [
          AppImages(imagePath: '/voucher.svg'),
          const SizedBox(width: 12),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Add voucher',
                hintStyle: TextStyle(fontSize: 14, color: Color(0xFF999999)),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE91E63),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'Apply',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewPaymentLabel() {
    return Text(
      '- REVIEW PAYMENT',
      style: AppTextStyles.font12Regular.copyWith(
        color: LightAppColors.primary800,
      ),
    );
  }

  Widget _buildPaymentSummary() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PAYMENT SUMMARY',
            style: AppTextStyles.font20Regular.copyWith(
              color: LightAppColors.primary800,
            ),
          ),
          10.h.ph,
          _buildSummaryRow('Subtotal', '16,100 EGP'),
          10.h.ph,
          _buildSummaryRow('SHIPPING FEES', 'TO BE CALCULATED'),
          10.h.ph,
          Divider(color: const Color(0xFF73B9BB), thickness: 1),
          10.h.ph,
          _buildSummaryRow('TOTAL + VAT', '16,100 EGP', isBold: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    bool isLabel = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isLabel ? 11 : 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: isLabel ? const Color(0xFF666666) : const Color(0xFF2C3E50),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isLabel ? 11 : 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: isLabel ? const Color(0xFF666666) : const Color(0xFF2C3E50),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderButton() {
    return Center(
      child: AppButton(
        hight: 65.h,
        width: 268.w,
        icon: '/my_cart.svg',
        text: 'ORDER',
        isIcon: true,
        iconColor: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    );
  }
}
