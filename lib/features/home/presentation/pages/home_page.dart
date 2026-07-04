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

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int pageIndex = 0;
  final GlobalKey<SearchPageState>   _searchPageKey   = GlobalKey<SearchPageState>();
  final GlobalKey<FavoritePageState> _favoritePageKey = GlobalKey<FavoritePageState>();

  static const _navItems = [
    _NavItem(icon: Icons.home_rounded,          outlineIcon: Icons.home_outlined,           label: 'Asosiy'),
    _NavItem(icon: Icons.search_rounded,        outlineIcon: Icons.search_outlined,         label: 'Qidiruv'),
    _NavItem(icon: Icons.bookmark_rounded,      outlineIcon: Icons.bookmark_outline_rounded, label: 'Saqlangan'),
    _NavItem(icon: Icons.person_rounded,        outlineIcon: Icons.person_outline_rounded,  label: 'Profil'),
  ];

  void changePage(int index, {bool focusSearch = false}) {
    if (pageIndex != index) {
      setState(() => pageIndex = index);
      if (index == 2) {
        Future.microtask(() => _favoritePageKey.currentState?.reload());
      }
    }
    if (index == 1 && focusSearch) {
      Future.delayed(const Duration(milliseconds: 120), () {
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
        child: Stack(
          children: [
            IndexedStack(
              index: pageIndex,
              children: [
                MainPage(onSearchTap: () => changePage(1, focusSearch: true)),
                SearchPage(key: _searchPageKey,   onBack: () => changePage(0)),
                FavoritePage(key: _favoritePageKey, onBack: () => changePage(0)),
                ProfilePage(onBack: () => changePage(0)),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildNavBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBar() {
    return Container(
      height: 76.h,
      decoration: BoxDecoration(
        color: AllColors.navBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.07), width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: List.generate(
          _navItems.length,
          (i) => _buildNavItem(i),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final item     = _navItems[index];
    final isActive = pageIndex == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => changePage(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Active indicator dot at top
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: isActive ? 20.w : 0,
              height: isActive ? 3.h : 0,
              margin: EdgeInsets.only(bottom: isActive ? 6.h : 0),
              decoration: BoxDecoration(
                color: AllColors.primaryColor,
                borderRadius: BorderRadius.circular(2.r),
                boxShadow: isActive
                    ? [BoxShadow(color: AllColors.primaryColor.withOpacity(0.6), blurRadius: 8)]
                    : null,
              ),
            ),
            // Icon with glow container
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(isActive ? 8.r : 0),
              decoration: BoxDecoration(
                color: isActive ? AllColors.primaryColor.withOpacity(0.12) : Colors.transparent,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                isActive ? item.icon : item.outlineIcon,
                size: 22.sp,
                color: isActive ? AllColors.primaryColor : AllColors.greyText,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              item.label,
              style: TextStyle(
                color: isActive ? AllColors.white : AllColors.greyText,
                fontSize: 10.sp,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData outlineIcon;
  final String label;
  const _NavItem({required this.icon, required this.outlineIcon, required this.label});
}
