import 'package:cosmetics/core/common/widgets/app_images.dart';
import 'package:cosmetics/core/helpers/app_navigator.dart';
import 'package:cosmetics/core/helpers/extensions.dart';
import 'package:cosmetics/core/network/dio_helper.dart';
import 'package:cosmetics/views/check_out/check_out.dart';
import 'package:cosmetics/core/theme/app_colors/light_app_colors.dart';
import 'package:cosmetics/core/theme/app_texts/app_text_styles.dart';
import 'package:cosmetics/core/utils/common_imports.dart';
import 'package:flutter/cupertino.dart';

class MyCartPage extends StatefulWidget {
  const MyCartPage({super.key});

  @override
  State<MyCartPage> createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage> {
  CartModel? cart;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    try {
      final response = await DioHelper.get("/api/Cart");

      setState(() {
        cart = CartModel.fromJson(response.data);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error loading cart")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.h),
      child: Column(
        children: [
          12.h.ph,
          Row(
            children: [
              const Spacer(),
              Text(
                'My Cart',
                style: AppTextStyles.font24Bold.copyWith(
                  color: LightAppColors.primary800,
                ),
              ),
              const Spacer(),
              CupertinoButton(
                onPressed: () {
                  AppNavigator.push(CheckOutView());
                },
                child: AppImages(imagePath: '/add_cart.svg'),
              ),
            ],
          ),
          24.h.ph,
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              cart == null
                  ? 'You have 0 products in your cart'
                  : 'You have ${cart!.items.length} products in your cart',
              style: AppTextStyles.font12Regular.copyWith(
                color: LightAppColors.primary800.withValues(alpha: .55),
              ),
            ),
          ),
          34.h.ph,
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: cart?.items.length ?? 0,
                    itemBuilder: (context, index) {
                      final product = cart!.items[index];

                      return MyCartProductCard(
                        model: product,
                        onCartUpdated: fetchCartItems,
                      );
                    },
                  ),
          ),

          if (cart != null)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Text(
                "Total: ${cart!.total.toStringAsFixed(0)} EGP",
                style: AppTextStyles.font16SemiBold.copyWith(
                  color: LightAppColors.primary800,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class MyCartProductCard extends StatefulWidget {
  const MyCartProductCard({
    super.key,

    required this.model,
    required this.onCartUpdated,
  });

  final CartItemModel model;

  final VoidCallback onCartUpdated;

  @override
  State<MyCartProductCard> createState() => _MyCartProductCardState();
}

class _MyCartProductCardState extends State<MyCartProductCard> {
  late int quantity;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    quantity = widget.model.quantity;
  }

  Future<void> removeItem() async {
    try {
      await DioHelper.delete("/api/Cart/remove/${widget.model.productId}");

      widget.onCartUpdated();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error removing item")));
    }
  }

  Future<void> updateCart(int newQuantity) async {
    try {
      setState(() {
        isUpdating = true;
      });

      await DioHelper.put(
        "/api/Cart/update",
        queryParameters: {
          "productId": widget.model.productId,
          "quantity": newQuantity,
        },
      );

      widget.onCartUpdated();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error updating cart")));
    } finally {
      setState(() {
        isUpdating = false;
      });
    }
  }

  void addQuantity() async {
    final newQuantity = quantity + 1;

    setState(() {
      quantity = newQuantity;
    });

    await updateCart(newQuantity);
  }

  void removeQuantity() async {
    if (quantity > 1) {
      final newQuantity = quantity - 1;

      setState(() {
        quantity = newQuantity;
      });

      await updateCart(newQuantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: AppImages(
                    imagePath: widget.model.imageUrl,
                    height: 102.h,
                    width: 102.w,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 4,
                  top: 4,
                  child: GestureDetector(
                    onTap: removeItem,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: const Icon(
                        Icons.delete,
                        size: 16,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            12.w.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.model.productNameEn,
                    style: AppTextStyles.font16SemiBold.copyWith(
                      color: LightAppColors.primary800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  8.h.ph,
                  Text(
                    "${widget.model.price.toStringAsFixed(0)} EGP",
                    style: AppTextStyles.font14SemiBold.copyWith(
                      color: LightAppColors.primary800,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: LightAppColors.grey400),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: isUpdating ? null : removeQuantity,
                    child: Icon(
                      Icons.remove,
                      size: 18,
                      color: LightAppColors.primary800,
                    ),
                  ),
                  10.w.pw,
                  Text(
                    quantity.toString(),
                    style: AppTextStyles.font14SemiBold.copyWith(
                      color: LightAppColors.primary800,
                    ),
                  ),
                  10.w.pw,
                  GestureDetector(
                    onTap: isUpdating ? null : addQuantity,
                    child: Icon(
                      Icons.add,
                      size: 18,
                      color: LightAppColors.primary800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        14.h.ph,

        Divider(
          thickness: 1,
          color: LightAppColors.grey500.withValues(alpha: .5),
        ),

        14.h.ph,
      ],
    );
  }
}

class CartModel {
  final List<CartItemModel> items;
  final double total;

  CartModel({required this.items, required this.total});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      items: (json['items'] as List)
          .map((e) => CartItemModel.fromJson(e))
          .toList(),
      total: (json['total'] as num).toDouble(),
    );
  }
}

class CartItemModel {
  final int productId;
  final String productNameEn;
  final String productNameAr;
  final int quantity;
  final double price;
  final String imageUrl;

  CartItemModel({
    required this.productId,
    required this.productNameEn,
    required this.productNameAr,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['product_id'],
      productNameEn: json['product_name_en'],
      productNameAr: json['product_name_ar'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'],
    );
  }
}
