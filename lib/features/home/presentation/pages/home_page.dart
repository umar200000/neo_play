import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neo_play/config/theme/colors/all_colors.dart';
import 'package:neo_play/features/favorite/presentation/pages/favorite_page.dart';
import 'package:neo_play/features/main/presentation/pages/main_page.dart';
import 'package:neo_play/features/profile/presentation/pages/profile_page.dart';
import 'package:neo_play/features/search/presentation/pages/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;
  final GlobalKey<SearchPageState> _searchPageKey =
      GlobalKey<SearchPageState>();

  void changePage(int index, {bool focusSearch = false}) {
    if (pageIndex != index) {
      setState(() {
        pageIndex = index;
      });
    }
    if (index == 1 && focusSearch) {
      // Key ochilishidan oldin biroz kutish kerak bo'lishi mumkin
      Future.delayed(const Duration(milliseconds: 100), () {
        _searchPageKey.currentState?.focusSearchField();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColors.background,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        top: false,
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: [
              IndexedStack(
                index: pageIndex,
                children: [
                  MainPage(onSearchTap: () => changePage(1, focusSearch: true)),
                  SearchPage(key: _searchPageKey, onBack: () => changePage(0)),
                  FavoritePage(onBack: () => changePage(0)),
                  ProfilePage(onBack: () => changePage(0)),
                ],
              ),
              Positioned(
                bottom: -1,
                left: -1,
                right: -1,
                child: Container(
                  height: 70.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.r),
                    ),
                    color: AllColors.bottomNavigatorBackgroundColor,
                    border: Border.all(color: const Color(0xff3C3E42)),
                  ),
                  child: Row(
                    children: [
                      _buildNavItem(
                        index: 0,
                        icon: Icons.home_outlined,
                        activeIcon: Icons.home_outlined,
                        label: "Asosiy",
                      ),
                      _buildNavItem(
                        index: 1,
                        icon: Icons.search,
                        activeIcon: Icons.search,
                        label: "Qidiruv",
                      ),
                      _buildNavItem(
                        index: 2,
                        icon: Icons.bookmark_border,
                        activeIcon: Icons.bookmark_border,
                        label: "Saqlangan",
                      ),
                      _buildNavItem(
                        index: 3,
                        icon: Icons.person_outline,
                        activeIcon: Icons.person_outline,
                        label: "Profil",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    bool isActive = pageIndex == index;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => changePage(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AllColors.white : AllColors.greyText,
              size: 24.sp,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AllColors.white : AllColors.greyText,
                fontSize: 12.sp,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
