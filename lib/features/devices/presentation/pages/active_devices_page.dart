import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:neo_play/config/theme/colors/all_colors.dart';

class ActiveDevicesPage extends StatelessWidget {
  const ActiveDevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> devices = [
      {
        'name': 'iPhone 15 Pro Max',
        'isCurrent': true,
        'lastActive': 'Hozir faol',
        'location': 'Toshkent, O\'zbekiston',
        'icon': Icons.smartphone_rounded,
      },
      {
        'name': 'Samsung Galaxy Tab S9',
        'isCurrent': false,
        'lastActive': '2 soat oldin',
        'location': 'Samarqand, O\'zbekiston',
        'icon': Icons.tablet_android_rounded,
      },
      {
        'name': 'Android TV - Sony Bravia',
        'isCurrent': false,
        'lastActive': 'Kecha, 20:45',
        'location': 'Toshkent, O\'zbekiston',
        'icon': Icons.tv_rounded,
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
          "Faol qurilmalar",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: devices.length,
                separatorBuilder: (context, index) => Gap(12.h),
                itemBuilder: (context, index) {
                  final device = devices[index];
                  return Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: AllColors.cardColor,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: device['isCurrent']
                            ? AllColors.primaryColor.withOpacity(0.3)
                            : Colors.white.withOpacity(0.05),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            device['icon'] as IconData,
                            color: device['isCurrent']
                                ? AllColors.primaryColor
                                : Colors.white,
                            size: 24.sp,
                          ),
                        ),
                        Gap(16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    device['name'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (device['isCurrent']) ...[
                                    Gap(8.w),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 2.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AllColors.primaryColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                      child: Text(
                                        "SHU QURILMA",
                                        style: TextStyle(
                                          color: AllColors.primaryColor,
                                          fontSize: 9.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              Gap(4.h),
                              Text(
                                "${device['lastActive']} • ${device['location']}",
                                style: TextStyle(
                                  color: AllColors.greyText,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!device['isCurrent'])
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.logout_rounded,
                              color: AllColors.red.withOpacity(0.7),
                              size: 20.sp,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Gap(20.h),
          ],
        ),
      ),
    );
  }
}
