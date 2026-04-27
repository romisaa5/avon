import 'package:cosmetics/core/common/widgets/app_images.dart';
import 'package:cosmetics/core/theme/app_colors/light_app_colors.dart';
import 'package:cosmetics/core/utils/common_imports.dart';
import 'package:cosmetics/views/home/pages/my_cart.dart';
import 'package:cosmetics/views/home/pages/categories.dart';
import 'package:cosmetics/views/home/pages/home.dart';
import 'package:cosmetics/views/home/pages/profile.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  final _pages = const [
    HomePage(),
    CategoriesPage(),
    MyCartPage(),
    ProfilePage(),
  ];

  Widget buildSvg(String path, bool isSelected) {
    return AppImages(
      imagePath: path,
      width: 20.w,
      height: 20.h,
      colorFilter: ColorFilter.mode(
        isSelected ? LightAppColors.secondary800 : LightAppColors.grey600,
        BlendMode.srcIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(8.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          color: LightAppColors.grey300,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },

            showSelectedLabels: false,
            showUnselectedLabels: false,

            items: [
              BottomNavigationBarItem(
                icon: buildSvg('/home.svg', _selectedIndex == 0),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: buildSvg('/categories.svg', _selectedIndex == 1),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: buildSvg('/my_cart.svg', _selectedIndex == 2),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: buildSvg('/profile.svg', _selectedIndex == 3),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
