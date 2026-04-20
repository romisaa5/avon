import 'package:cosmetics/core/common/widgets/app_images.dart';
import 'package:cosmetics/core/common/widgets/app_input.dart';
import 'package:cosmetics/core/helpers/extensions.dart';
import 'package:cosmetics/core/network/dio_helper.dart';
import 'package:cosmetics/core/theme/app_colors/light_app_colors.dart';
import 'package:cosmetics/core/theme/app_texts/app_text_styles.dart';
import 'package:cosmetics/core/utils/common_imports.dart';
import 'package:cosmetics/views/home/widgets/offers.dart';
import 'package:cosmetics/views/home/widgets/top_rated_product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> topRatedProducts = [];
  bool isLoading = true;
  List<OfferModel> offers = [];
  bool isOffersLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTopRatedProducts();
    fetchOffers();
  }

  Future<void> fetchOffers() async {
    try {
      final response = await DioHelper.get("/api/Sliders");
      final List data = response.data;

      setState(() {
        offers = data.map((e) => OfferModel.fromJson(e)).toList();
        isOffersLoading = false;
      });
    } catch (e) {
      setState(() {
        isOffersLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error loading offers")));
    }
  }

  Future<void> fetchTopRatedProducts() async {
    try {
      final response = await DioHelper.get("/api/Products");
      final List data = response.data;
      if (!mounted) return;
      setState(() {
        topRatedProducts = data
            .map((e) => Product.fromJson(e))
            .take(6)
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error loading products")));
    }
  }

  Future<void> addToCart(int productId) async {
    try {
      final response = await DioHelper.post(
        "/api/Cart/add",
        queryParameters: {"productId": productId, "quantity": 1},
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.data["message"])));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to add to cart")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            12.h.ph,
            AppInput(
              autoFocus: false,
              labelText: 'Search',
              suffixIcon: SizedBox(
                height: 24.h,
                width: 24.w,
                child: Center(child: AppImages(imagePath: '/search.svg')),
              ),
            ),
            12.h.ph,
            Offers(offers: offers, isLoading: isOffersLoading),
            12.h.ph,
            Text(
              'Top rated products',
              style: AppTextStyles.font16Bold.copyWith(
                color: LightAppColors.primary800,
              ),
            ),
            14.h.ph,
            if (isLoading)
              SizedBox(
                height: 300.h,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (topRatedProducts.isEmpty)
              Center(child: Text('No products available'))
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: topRatedProducts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final product = topRatedProducts[index];
                  return TopRatedProductCard(
                    onPressed: () {
                      addToCart(product.id);
                    },
                    imageUrl: product.imageUrl,
                    title: product.nameEn,
                    price: "\$${product.price}",
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class Product {
  final int id;
  final String nameEn;
  final String nameAr;
  final String descriptionEn;
  final String descriptionAr;
  final double price;
  final int stock;
  final String imageUrl;
  final int categoryId;

  Product({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.categoryId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      nameEn: json["name_en"],
      nameAr: json["name_ar"],
      descriptionEn: json["description_en"] ?? "",
      descriptionAr: json["description_ar"] ?? "",
      price: (json["price"] as num).toDouble(),
      stock: json["stock"],
      imageUrl: json["image_url"],
      categoryId: json["category_id"],
    );
  }
}

class OfferModel {
  final int id;
  final String couponCode;
  final int discountPercent;

  final String descriptionTitle1En;
  final String descriptionTitle1Ar;

  final String descriptionTitle2En;
  final String descriptionTitle2Ar;

  final String imageUrl;

  OfferModel({
    required this.id,
    required this.couponCode,
    required this.discountPercent,
    required this.descriptionTitle1En,
    required this.descriptionTitle1Ar,
    required this.descriptionTitle2En,
    required this.descriptionTitle2Ar,
    required this.imageUrl,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] ?? 0,
      couponCode: json['coupon_code'] ?? '',
      discountPercent: json['discount_percent'] ?? 0,

      descriptionTitle1En: json['description_title1_en'] ?? '',
      descriptionTitle1Ar: json['description_title1_ar'] ?? '',

      descriptionTitle2En: json['description_title2_en'] ?? '',
      descriptionTitle2Ar: json['description_title2_ar'] ?? '',

      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'coupon_code': couponCode,
      'discount_percent': discountPercent,

      'description_title1_en': descriptionTitle1En,
      'description_title1_ar': descriptionTitle1Ar,

      'description_title2_en': descriptionTitle2En,
      'description_title2_ar': descriptionTitle2Ar,

      'image_url': imageUrl,
    };
  }
}
