import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:neo_play/config/theme/colors/all_colors.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Ilova haqida",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              Gap(40.h),
              Container(
                height: 120.r,
                width: 120.r,
                decoration: BoxDecoration(
                  color: AllColors.primaryColor,
                  borderRadius: BorderRadius.circular(30.r),
                  boxShadow: [
                    BoxShadow(
                      color: AllColors.primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 80.sp,
                ),
              ),
              Gap(24.h),
              Text(
                "Neo Play",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Versiya: 1.0.0",
                style: TextStyle(color: AllColors.greyText, fontSize: 14.sp),
              ),
              Gap(40.h),
              _buildAboutCard(
                title: "Neo Play haqida",
                description:
                    "Neo Play - bu sevimli filmlaringiz, seriallaringiz va teleko'rsatuvlaringizni yuqori sifatda tomosha qilish imkonini beruvchi zamonaviy oqimli xizmat. Biz foydalanuvchilarimizga eng so'nggi va sara kontentlarni yetkazib berishga intilamiz.",
              ),
              Gap(20.h),
              _buildAboutCard(
                title: "Bizning maqsadimiz",
                description:
                    "Tomoshabinlar uchun qulay va sifatli platforma yaratish orqali, uydan chiqmagan holda jahon kinosining eng yaxshi namunalaridan bahramand bo'lish imkoniyatini taqdim etish.",
              ),
              Gap(24.h),
              _buildSocialRow(),
              Gap(40.h),
              Text(
                "© 2024 Neo Play LLC. Barcha huquqlar himoyalangan.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AllColors.greyText.withOpacity(0.5),
                  fontSize: 12.sp,
                ),
              ),
              Gap(40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAboutCard({required String title, required String description}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AllColors.cardColor,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AllColors.primaryColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Gap(12.h),
          Text(
            description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14.sp,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialIcon(Icons.language_rounded),
        Gap(20.w),
        _buildSocialIcon(Icons.telegram_rounded),
        Gap(20.w),
        _buildSocialIcon(Icons.facebook_rounded),
        Gap(20.w),
        _buildSocialIcon(Icons.camera_alt_rounded),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AllColors.cardColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Icon(icon, color: Colors.white, size: 20.sp),
    );
  }
}
