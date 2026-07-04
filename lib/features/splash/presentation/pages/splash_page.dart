import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neo_play/config/theme/colors/all_colors.dart';
import 'package:neo_play/core/service/auth_service.dart';

import '../../../../core/router/routes_name.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final loggedIn = await AuthService.isLoggedIn();
    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      loggedIn ? RoutesName.homePage : RoutesName.authPage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColors.background,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24.r),
                  child: Image.asset(
                    'assets/images/neo_play.jpg',
                    width: 120.w,
                    height: 120.w,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  "NEO PLAY",
                  style: TextStyle(
                    color: AllColors.white,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 70.h,
            left: 60.w,
            right: 60.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: LinearProgressIndicator(
                backgroundColor: AllColors.greyText.withOpacity(0.2),
                color: AllColors.primaryColor,
                minHeight: 4.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
