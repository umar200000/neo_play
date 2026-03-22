import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:neo_play/config/theme/colors/all_colors.dart';

class PaymentHistoryPage extends StatelessWidget {
  const PaymentHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for payment history
    final List<Map<String, dynamic>> history = [
      {
        'title': "Balansni to'ldirish",
        'amount': "+50 000 UZS",
        'date': "24.03.2024",
        'time': "14:20",
        'type': 'topup',
        'status': 'Muvaffaqiyatli',
        'method': 'Payme',
      },
      {
        'title': "PREMIUM 1 OY sotib olindi",
        'amount': "-15 000 UZS",
        'date': "22.03.2024",
        'time': "09:15",
        'type': 'purchase',
        'status': 'Muvaffaqiyatli',
        'method': 'Balans',
      },
      {
        'title': "Balansni to'ldirish",
        'amount': "+20 000 UZS",
        'date': "15.03.2024",
        'time': "18:45",
        'type': 'topup',
        'status': 'Muvaffaqiyatli',
        'method': 'Click',
      },
      {
        'title': "Tarifni uzaytirish",
        'amount': "-42 000 UZS",
        'date': "10.03.2024",
        'time': "12:00",
        'type': 'purchase',
        'status': 'Muvaffaqiyatli',
        'method': 'Balans',
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
          "To'lov tarixi",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: history.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: EdgeInsets.all(16.r),
              itemCount: history.length,
              separatorBuilder: (context, index) => Gap(12.h),
              itemBuilder: (context, index) {
                final item = history[index];
                final bool isTopUp = item['type'] == 'topup';

                return Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: AllColors.cardColor,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Row(
                    children: [
                      // Icon based on type
                      Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: isTopUp
                              ? AllColors.primaryColor.withOpacity(0.1)
                              : Colors.orange.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isTopUp
                              ? Icons.add_rounded
                              : Icons.shopping_bag_outlined,
                          color: isTopUp
                              ? AllColors.primaryColor
                              : Colors.orange,
                          size: 24.sp,
                        ),
                      ),
                      Gap(16.w),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Gap(4.h),
                            Text(
                              "${item['date']} • ${item['time']} • ${item['method']}",
                              style: TextStyle(
                                color: AllColors.greyText,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(8.w),
                      // Amount
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            item['amount'],
                            style: TextStyle(
                              color: isTopUp
                                  ? AllColors.primaryColor
                                  : Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Gap(4.h),
                          Text(
                            item['status'],
                            style: TextStyle(
                              color: AllColors.primaryColor.withOpacity(0.7),
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_rounded,
            color: AllColors.greyText.withOpacity(0.2),
            size: 80.sp,
          ),
          Gap(16.h),
          Text(
            "Hozircha to'lovlar tarixi yo'q",
            style: TextStyle(color: AllColors.greyText, fontSize: 15.sp),
          ),
        ],
      ),
    );
  }
}
