import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:neo_play/config/theme/colors/all_colors.dart';

class PurchasedSubscriptionsPage extends StatelessWidget {
  const PurchasedSubscriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for purchased subscriptions
    final List<Map<String, dynamic>> activeSubscriptions = [
      {
        'title': 'PREMIUM PLAN',
        'price': '15 000 UZS',
        'expiryDate': '25 Mart, 2026',
        'expiryTime': '00:20',
        'status': 'Faol',
        'isPremium': true,
      },
    ];

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
          "Sotib olingan tariflar",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: activeSubscriptions.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: EdgeInsets.all(16.r),
              itemCount: activeSubscriptions.length,
              separatorBuilder: (context, index) => Gap(16.h),
              itemBuilder: (context, index) {
                final sub = activeSubscriptions[index];
                return _buildSubscriptionCard(sub);
              },
            ),
    );
  }

  Widget _buildSubscriptionCard(Map<String, dynamic> sub) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AllColors.cardColor,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AllColors.cardColor, const Color(0xff1A1B1E)],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Stack(
          children: [
            // Background decoration glow
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 100.r,
                height: 100.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AllColors.primaryColor.withOpacity(0.1),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AllColors.primaryColor.withOpacity(0.1),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                              color: AllColors.primaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.workspace_premium_rounded,
                              color: AllColors.primaryColor,
                              size: 24.sp,
                            ),
                          ),
                          Gap(12.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sub['title'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                sub['price'],
                                style: TextStyle(
                                  color: AllColors.greyText,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AllColors.primaryColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 6.r,
                              height: 6.r,
                              decoration: const BoxDecoration(
                                color: AllColors.primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Gap(6.w),
                            Text(
                              sub['status'],
                              style: TextStyle(
                                color: AllColors.primaryColor,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Gap(24.h),
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      children: [
                        _buildInfoItem(
                          icon: Icons.calendar_today_rounded,
                          label: "Tugash muddati",
                          value: sub['expiryDate'],
                        ),
                        Container(
                          width: 1,
                          height: 30.h,
                          margin: EdgeInsets.symmetric(horizontal: 16.w),
                          color: Colors.white.withOpacity(0.1),
                        ),
                        _buildInfoItem(
                          icon: Icons.access_time_rounded,
                          label: "Vaqti",
                          value: sub['expiryTime'],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, color: AllColors.greyText, size: 16.sp),
          Gap(8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: AllColors.greyText, fontSize: 10.sp),
              ),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.subtitles_off_rounded,
            color: AllColors.greyText.withOpacity(0.3),
            size: 64.sp,
          ),
          Gap(16.h),
          Text(
            "Sizda hali faol tariflar yo'q",
            style: TextStyle(color: AllColors.greyText, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}
