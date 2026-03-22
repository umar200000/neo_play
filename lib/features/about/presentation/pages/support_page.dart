import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:neo_play/config/theme/colors/all_colors.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

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
          "Qo'llab-quvvatlash",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.r),
        child: Column(
          children: [
            Gap(20.h),
            Container(
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: AllColors.cardColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AllColors.primaryColor.withOpacity(0.1),
                  width: 10,
                ),
              ),
              child: Icon(
                Icons.support_agent_rounded,
                color: AllColors.primaryColor,
                size: 80.sp,
              ),
            ),
            Gap(32.h),
            Text(
              "Sizga qanday yordam bera olamiz?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(12.h),
            Text(
              "Savollaringiz bo'lsa yoki muammolarga duch kelsangiz, biz bilan bog'laning. Bizning jamoamiz sizga yordam berishga tayyor!",
              textAlign: TextAlign.center,
              style: TextStyle(color: AllColors.greyText, fontSize: 14.sp),
            ),
            Gap(40.h),
            _buildContactItem(
              icon: Icons.telegram_rounded,
              title: "Telegram bot",
              subtitle: "@neo_play_support_bot",
              onTap: () {},
            ),
            Gap(12.h),
            _buildContactItem(
              icon: Icons.phone_rounded,
              title: "Telefon raqami",
              subtitle: "+998 90 123 45 67",
              onTap: () {},
            ),
            Gap(12.h),
            _buildContactItem(
              icon: Icons.email_rounded,
              title: "Elektron pochta",
              subtitle: "support@neoplay.uz",
              onTap: () {},
            ),
            Gap(40.h),
            Text(
              "Ish vaqti: 09:00 - 21:00 (Dam olish kunlarisiz)",
              style: TextStyle(
                color: AllColors.greyText.withOpacity(0.5),
                fontSize: 12.sp,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AllColors.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: AllColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: AllColors.primaryColor, size: 24.sp),
            ),
            Gap(16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AllColors.greyText,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white.withOpacity(0.2),
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }
}
