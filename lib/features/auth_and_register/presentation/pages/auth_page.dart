import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:neo_play/config/theme/colors/all_colors.dart';
import 'package:neo_play/core/router/routes_name.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColors.background,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(80.h),
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: AllColors.cardColor,
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(
                          color: AllColors.primaryColor.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: Image.asset(
                          'assets/images/neo_play.jpg',
                          width: 80.w,
                          height: 80.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Gap(24.h),
                    Text(
                      "Xush kelibsiz!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(8.h),
                    Text(
                      "Kirish uchun telefon raqamingizni kiriting",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AllColors.greyText,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(48.h),
              Text(
                "Telefon raqam",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Gap(12.h),
              Container(
                decoration: BoxDecoration(
                  color: AllColors.cardColor,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.05),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: Text(
                        "+998",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(
                            12,
                          ), // 90 123 45 67 (9 raqam + 3 bo'shliq)
                          _PhoneInputFormatter(),
                        ],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          letterSpacing: 1.5,
                        ),
                        decoration: InputDecoration(
                          hintText: " (--) --- -- --",
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.2),
                            fontSize: 16.sp,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 18.h,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(32.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RoutesName.authPinPut);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AllColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    elevation: 8,
                    shadowColor: AllColors.primaryColor.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Text(
                    "Davom etish",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'\D'), '');
    final chars = text.characters.toList();
    var buffer = StringBuffer();
    var selectionIndex = newValue.selection.end;

    // Kursor joylashuvini hisoblash
    int newCursorPosition = selectionIndex;

    for (int i = 0; i < chars.length; i++) {
      if (i == 2 || i == 5 || i == 7) {
        buffer.write(' ');
        // Agar kursor shu joydan keyin bo'lsa, bitta suramiz
        if (selectionIndex > buffer.length - 1) {
          // Bu qism kursorning to'g'ri joylashishini ta'minlaydi
        }
      }
      buffer.write(chars[i]);
    }

    String finalString = buffer.toString();

    // Kursor mantiqi: o'chirish va yozishda o'z joyida qolishi uchun
    int cursorPosition = newValue.selection.end;
    if (oldValue.text.length < newValue.text.length) {
      // Yozilayotganda
      if (cursorPosition == 3 || cursorPosition == 7 || cursorPosition == 10) {
        cursorPosition++;
      }
    }

    return TextEditingValue(
      text: finalString,
      selection: TextSelection.collapsed(
        offset: cursorPosition > finalString.length
            ? finalString.length
            : cursorPosition,
      ),
    );
  }
}
