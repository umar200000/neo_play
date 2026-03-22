import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:neo_play/config/theme/colors/all_colors.dart';
import 'package:neo_play/core/router/routes_name.dart';

class ProfilePage extends StatelessWidget {
  final VoidCallback? onBack;
  const ProfilePage({super.key, this.onBack});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AllColors.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: AllColors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: AllColors.red,
                    size: 32.sp,
                  ),
                ),
                Gap(24.h),
                Text(
                  "Chiqish",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(12.h),
                Text(
                  "Haqiqatan ham hisobingizdan chiqmoqchimisiz?",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AllColors.greyText, fontSize: 14.sp),
                ),
                Gap(32.h),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            side: BorderSide(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),
                        child: Text(
                          "Bekor qilish",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                    Gap(12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implement logout logic
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AllColors.red,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          "Chiqish",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLanguageModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            color: AllColors.cardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Gap(24.h),
              Text(
                "Tilni tanlang",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(24.h),
              _buildLanguageItem(context, "O'zbek tili", "uz"),
              Gap(12.h),
              _buildLanguageItem(context, "Русский язык", "ru"),
              Gap(12.h),
              _buildLanguageItem(context, "English language", "en"),
              Gap(32.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageItem(BuildContext context, String title, String code) {
    return InkWell(
      onTap: () {
        // TODO: Implement language change logic
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AllColors.greyText,
              size: 14.sp,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColors.background,
      body: Stack(
        children: [
          // Content
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  Gap(120.h), // Space for floating header
                  _buildProfileHeader(),
                  Gap(24.h),

                  _buildSectionTitle("Profil sozlamalari"),
                  _buildMenuItem(
                    icon: Icons.person_outline_rounded,
                    title: "Profilni tahrirlash",
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.editProfile);
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.language_outlined,
                    title: "Tilni o'zgartirish",
                    subtitle: "O'zbek tili",
                    onTap: () => _showLanguageModal(context),
                  ),

                  Gap(24.h),
                  _buildSectionTitle("Xizmatlar"),
                  _buildMenuItem(
                    icon: Icons.account_balance_wallet_outlined,
                    title: "Balansni to'ldirish",
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.topUpBalance);
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.subscriptions_outlined,
                    title: "Tarif sotib olish",
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.buySubscription);
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.card_membership_outlined,
                    title: "Sotib olingan tariflar",
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RoutesName.purchasedSubscriptions,
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.history_outlined,
                    title: "To'lov tarixi",
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.paymentHistory);
                    },
                  ),

                  Gap(24.h),
                  _buildSectionTitle("Xavfsizlik va qurilmalar"),
                  _buildMenuItem(
                    icon: Icons.devices_outlined,
                    title: "Faol qurilmalar",
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.activeDevices);
                    },
                  ),
                  Gap(24.h),
                  _buildSectionTitle("Ilova haqida"),
                  _buildMenuItem(
                    icon: Icons.support_agent_outlined,
                    title: "Qo'llab-quvvatlash",
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.support);
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.info_outline,
                    title: "Ilova haqida",
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.aboutApp);
                    },
                  ),
                  Gap(24.h),
                  _buildMenuItem(
                    icon: Icons.logout_rounded,
                    title: "Chiqish",
                    titleColor: AllColors.red,
                    showChevron: false,
                    onTap: () => _showLogoutDialog(context),
                  ),
                  Gap(100.h),
                ],
              ),
            ),
          ),
          // Floating Header
          Positioned(top: 0, left: 0, right: 0, child: _buildHeader(context)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff0F0F0F),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 24.h),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (onBack != null) {
                    onBack!();
                  } else {
                    Navigator.maybePop(context);
                  }
                },
                child: Container(
                  height: 44.h,
                  width: 44.h,
                  decoration: BoxDecoration(
                    color: const Color(0xff1A1B1E),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: const Icon(Icons.chevron_left, color: Colors.white),
                ),
              ),
              Gap(16.w),
              Text(
                "Profil",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AllColors.cardColor,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            height: 70.h,
            width: 70.h,
            decoration: BoxDecoration(
              color: AllColors.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: AllColors.primaryColor.withOpacity(0.2),
              ),
            ),
            child: Icon(
              Icons.person_rounded,
              color: AllColors.primaryColor,
              size: 40.sp,
            ),
          ),
          Gap(16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Foydalanuvchi ismi",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(4.h),
                Text(
                  "+998 90 123 45 67",
                  style: TextStyle(color: AllColors.greyText, fontSize: 14.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: AllColors.greyText,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? titleColor,
    bool showChevron = true,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: AllColors.cardColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              Icon(icon, color: titleColor ?? Colors.white, size: 22.sp),
              Gap(16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: titleColor ?? Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (subtitle != null) ...[
                      Gap(2.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: AllColors.greyText,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (showChevron)
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withOpacity(0.2),
                  size: 14.sp,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
