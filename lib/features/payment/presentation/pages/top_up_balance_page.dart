import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:neo_play/config/theme/colors/all_colors.dart';

class TopUpBalancePage extends StatelessWidget {
  const TopUpBalancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> paymentMethods = [
      {'name': 'Payme', 'color': const Color(0xff00BAE0)},
      {'name': 'Click', 'color': const Color(0xff00AEEF)},
      {'name': 'Visa/Mastercard', 'color': Colors.white},
      {'name': 'Uzcard/Humo', 'color': Colors.white},
      {'name': 'Paynet', 'color': const Color(0xff00A357)},
      {'name': 'Beepul', 'color': const Color(0xffFBC02D)},
      {'name': 'Trastpay', 'color': const Color(0xff0052CC)},
      {'name': 'SQB Mobile', 'color': const Color(0xff0054A6)},
      {'name': 'Alif', 'color': const Color(0xff00C165)},
      {'name': 'Openbank', 'color': const Color(0xff007AFF)},
      {'name': 'Xazna', 'color': const Color(0xff4CAF50)},
      {'name': 'Mavrid', 'color': const Color(0xffE91E63)},
    ];

    return Scaffold(
      backgroundColor: AllColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Balansni to'ldirish",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Gap(16.h),
          Text(
            "To'lov tizimini tanlang:",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Gap(24.h),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 1,
              ),
              itemCount: paymentMethods.length,
              itemBuilder: (context, index) {
                final method = paymentMethods[index];
                return GestureDetector(
                  onTap: () {
                    // TODO: Implement payment selection
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AllColors.cardColor,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Placeholder for logos since assets are not available
                        Container(
                          padding: EdgeInsets.all(8.r),
                          child: Text(
                            method['name'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: method['color'] == Colors.white
                                  ? Colors.white
                                  : method['color'],
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
