import 'package:carousel_slider/carousel_slider.dart';
import 'package:cosmetics/core/common/widgets/app_images.dart';
import 'package:cosmetics/core/helpers/extensions.dart';
import 'package:cosmetics/core/theme/app_texts/app_text_styles.dart';
import 'package:cosmetics/core/utils/common_imports.dart';
import 'package:cosmetics/views/home/pages/home.dart';

class Offers extends StatelessWidget {
  final List<OfferModel> offers;
  final bool isLoading;

  const Offers({super.key, required this.offers, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 160,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return CarouselSlider(
      items: offers.map((offer) {
        return Container(
          padding: const EdgeInsets.all(12),

          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: 0.6,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: AppImages(
                    imagePath: offer.imageUrl,
                    height: 320.h,
                    width: double.infinity,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  color: Color(0XFFE9DCD3).withValues(alpha: .5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${offer.discountPercent}% OFF DISCOUNT \n CUPON CODE : ${offer.couponCode}",
                          style: AppTextStyles.font16Bold.copyWith(
                            color: Color(0xff62322D),
                          ),
                        ),
                        AppImages(
                          imagePath: '/offer.svg',
                          width: 50.w,
                          height: 50.h,
                        ),
                      ],
                    ),
                    12.h.ph,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppImages(
                          imagePath: '/offer.svg',
                          width: 50.w,
                          height: 50.h,
                        ),
                        Text(
                          "${offer.descriptionTitle1En}\n${offer.descriptionTitle2En}",
                          style: AppTextStyles.font16Bold.copyWith(
                            color: Color(0xff434C6D),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: 320.h,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 1,
      ),
    );
  }
}
