import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:neo_play/config/theme/colors/all_colors.dart';
import 'package:neo_play/core/router/routes_name.dart';
import 'package:neo_play/core/service/auth_service.dart';
import 'package:neo_play/core/service/api/auth_api.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback? onBack;
  const ProfilePage({super.key, this.onBack});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final local = await AuthService.getUser();
    if (mounted) setState(() => _user = local);
    try {
      final data  = await AuthApi.getMe();
      final fresh = data['user'] as Map<String, dynamic>;
      final token = await AuthService.getToken() ?? '';
      await AuthService.saveSession(token: token, user: fresh);
      if (mounted) setState(() => _user = fresh);
    } catch (_) {}
  }

  String get _displayName {
    if (_user == null) return '...';
    final first = _user!['first_name'] as String? ?? '';
    final last  = _user!['last_name']  as String? ?? '';
    final full  = '$first $last'.trim();
    return full.isEmpty ? 'Foydalanuvchi' : full;
  }

  String get _phone => _user?['phone'] as String? ?? '';

  String? get _avatarUrl {
    final url = _user?['avatar'] as String?;
    if (url == null || url.isEmpty) return null;
    if (url.startsWith('http')) return url;
    return 'http://localhost:3000$url';
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (ctx) => Dialog(
        backgroundColor: AllColors.cardHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.r)),
        child: Padding(
          padding: EdgeInsets.all(28.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  color: AllColors.red.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.logout_rounded, color: AllColors.red, size: 28.sp),
              ),
              Gap(20.h),
              Text("Chiqish",
                  style: TextStyle(color: AllColors.white, fontSize: 20.sp, fontWeight: FontWeight.bold)),
              Gap(10.h),
              Text(
                "Haqiqatan ham hisobingizdan chiqmoqchimisiz?",
                textAlign: TextAlign.center,
                style: TextStyle(color: AllColors.greyText, fontSize: 14.sp, height: 1.4),
              ),
              Gap(28.h),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                          side: BorderSide(color: Colors.white.withOpacity(0.1)),
                        ),
                      ),
                      child: Text("Bekor",
                          style: TextStyle(color: AllColors.white, fontSize: 14.sp, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  Gap(12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await AuthApi.logout();
                        await AuthService.clearSession();
                        if (mounted) {
                          Navigator.pushNamedAndRemoveUntil(context, RoutesName.authPage, (r) => false);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AllColors.red,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                      ),
                      child: Text("Chiqish",
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
        decoration: BoxDecoration(
          color: AllColors.cardHigh,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36.w, height: 4.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Gap(24.h),
            Text("Tilni tanlang",
                style: TextStyle(color: AllColors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
            Gap(20.h),
            _langItem(ctx, "🇺🇿", "O'zbek tili",      "uz"),
            Gap(10.h),
            _langItem(ctx, "🇷🇺", "Русский язык",     "ru"),
            Gap(10.h),
            _langItem(ctx, "🇬🇧", "English language", "en"),
          ],
        ),
      ),
    );
  }

  Widget _langItem(BuildContext ctx, String flag, String title, String code) {
    return InkWell(
      onTap: () => Navigator.pop(ctx),
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AllColors.surfaceLight.withOpacity(0.5),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Row(
          children: [
            Text(flag, style: TextStyle(fontSize: 20.sp)),
            Gap(14.w),
            Text(title,
                style: TextStyle(color: AllColors.white, fontSize: 15.sp, fontWeight: FontWeight.w500)),
            const Spacer(),
            Icon(Icons.arrow_forward_ios_rounded, color: AllColors.greyText, size: 13.sp),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroHeader(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  Gap(28.h),

                  _buildSection(
                    title: "Profil sozlamalari",
                    items: [
                      _MenuItem(
                        icon: Icons.person_outline_rounded,
                        iconColor: AllColors.blue,
                        title: "Profilni tahrirlash",
                        onTap: () => Navigator.pushNamed(context, RoutesName.editProfile).then((_) => _loadUser()),
                      ),
                      _MenuItem(
                        icon: Icons.language_outlined,
                        iconColor: const Color(0xFF10B981),
                        title: "Tilni o'zgartirish",
                        subtitle: "O'zbek tili",
                        onTap: _showLanguageModal,
                      ),
                    ],
                  ),

                  Gap(16.h),
                  _buildSection(
                    title: "Xizmatlar",
                    items: [
                      _MenuItem(
                        icon: Icons.account_balance_wallet_outlined,
                        iconColor: AllColors.yellow,
                        title: "Balansni to'ldirish",
                        onTap: () => Navigator.pushNamed(context, RoutesName.topUpBalance),
                      ),
                      _MenuItem(
                        icon: Icons.star_outline_rounded,
                        iconColor: AllColors.primaryColor,
                        title: "Tarif sotib olish",
                        badge: "PRO",
                        onTap: () => Navigator.pushNamed(context, RoutesName.buySubscription),
                      ),
                      _MenuItem(
                        icon: Icons.card_membership_outlined,
                        iconColor: AllColors.purple,
                        title: "Sotib olingan tariflar",
                        onTap: () => Navigator.pushNamed(context, RoutesName.purchasedSubscriptions),
                      ),
                      _MenuItem(
                        icon: Icons.receipt_long_outlined,
                        iconColor: const Color(0xFF06B6D4),
                        title: "To'lov tarixi",
                        onTap: () => Navigator.pushNamed(context, RoutesName.paymentHistory),
                      ),
                    ],
                  ),

                  Gap(16.h),
                  _buildSection(
                    title: "Xavfsizlik",
                    items: [
                      _MenuItem(
                        icon: Icons.devices_outlined,
                        iconColor: const Color(0xFFF97316),
                        title: "Faol qurilmalar",
                        onTap: () => Navigator.pushNamed(context, RoutesName.activeDevices),
                      ),
                    ],
                  ),

                  Gap(16.h),
                  _buildSection(
                    title: "Ilova haqida",
                    items: [
                      _MenuItem(
                        icon: Icons.headset_mic_outlined,
                        iconColor: AllColors.green,
                        title: "Qo'llab-quvvatlash",
                        onTap: () => Navigator.pushNamed(context, RoutesName.support),
                      ),
                      _MenuItem(
                        icon: Icons.info_outline_rounded,
                        iconColor: AllColors.greyText,
                        title: "Ilova haqida",
                        onTap: () => Navigator.pushNamed(context, RoutesName.aboutApp),
                      ),
                    ],
                  ),

                  Gap(16.h),
                  // Logout
                  GestureDetector(
                    onTap: _showLogoutDialog,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      decoration: BoxDecoration(
                        color: AllColors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: AllColors.red.withOpacity(0.15)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout_rounded, color: AllColors.red, size: 20.sp),
                          Gap(10.w),
                          Text("Chiqish",
                              style: TextStyle(
                                color: AllColors.red,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                    ),
                  ),

                  Gap(100.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader() {
    return Stack(
      children: [
        // Gradient background
        Container(
          height: 240.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1E0005),
                AllColors.background,
              ],
            ),
          ),
        ),
        // Decorative glow
        Positioned(
          top: -50.h, right: -50.w,
          child: Container(
            width: 220.w, height: 220.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AllColors.primaryColor.withOpacity(0.06),
            ),
          ),
        ),
        Positioned(
          bottom: 0, left: 0,
          child: Container(
            width: 150.w, height: 150.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AllColors.primaryColor.withOpacity(0.03),
            ),
          ),
        ),
        // Content
        SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                Gap(12.h),
                // Top row
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (widget.onBack != null) {
                          widget.onBack!();
                        } else {
                          Navigator.maybePop(context);
                        }
                      },
                      child: Container(
                        width: 40.w, height: 40.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.08)),
                        ),
                        child: Icon(Icons.arrow_back_rounded, color: AllColors.white, size: 20.sp),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "Profil",
                      style: TextStyle(
                        color: AllColors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(width: 40.w),
                  ],
                ),
                Gap(24.h),
                // Avatar
                Container(
                  width: 80.w, height: 80.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AllColors.primaryColor, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: AllColors.primaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: _avatarUrl != null
                        ? Image.network(
                            _avatarUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _defaultAvatar(),
                          )
                        : _defaultAvatar(),
                  ),
                ),
                Gap(14.h),
                Text(
                  _displayName,
                  style: TextStyle(
                    color: AllColors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(4.h),
                Text(
                  _phone,
                  style: TextStyle(color: AllColors.greyText, fontSize: 13.sp),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _defaultAvatar() {
    return Container(
      color: AllColors.primaryColor.withOpacity(0.15),
      child: Icon(Icons.person_rounded, color: AllColors.primaryColor, size: 40.sp),
    );
  }

  Widget _buildSection({required String title, required List<_MenuItem> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 10.h),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              color: AllColors.textMuted,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AllColors.cardColor,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            children: items.asMap().entries.map((e) {
              final index = e.key;
              final item  = e.value;
              return Column(
                children: [
                  _buildMenuItem(item),
                  if (index < items.length - 1)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Divider(
                        color: Colors.white.withOpacity(0.04),
                        height: 0,
                        thickness: 0.5,
                      ),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(_MenuItem item) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              width: 38.w, height: 38.w,
              decoration: BoxDecoration(
                color: item.iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(item.icon, color: item.iconColor, size: 18.sp),
            ),
            Gap(14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: TextStyle(
                          color: AllColors.white, fontSize: 14.sp, fontWeight: FontWeight.w500)),
                  if (item.subtitle != null) ...[
                    Gap(2.h),
                    Text(item.subtitle!,
                        style: TextStyle(color: AllColors.greyText, fontSize: 11.sp)),
                  ],
                ],
              ),
            ),
            if (item.badge != null) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE50914), Color(0xFFFF4B4B)],
                  ),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(item.badge!,
                    style: TextStyle(
                        color: Colors.white, fontSize: 9.sp, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
              ),
              Gap(8.w),
            ],
            Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.white.withOpacity(0.2), size: 13.sp),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final String? badge;
  final VoidCallback onTap;
  const _MenuItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.badge,
    required this.onTap,
  });
}
