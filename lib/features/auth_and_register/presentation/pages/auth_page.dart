import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:neo_play/config/theme/colors/all_colors.dart';
import 'package:neo_play/core/router/routes_name.dart';
import 'package:neo_play/core/service/api/auth_api.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _phoneController = TextEditingController();
  bool _loading = false;
  bool _hasFocus = false;

  String get _fullPhone => '+998${_phoneController.text.replaceAll(' ', '')}';

  Future<void> _onContinue() async {
    final digits = _phoneController.text.replaceAll(' ', '');
    if (digits.length < 9) {
      _showError("To'liq telefon raqam kiriting");
      return;
    }
    setState(() => _loading = true);
    try {
      await AuthApi.sendOtp(_fullPhone);
    } catch (_) {}
    finally {
      setState(() => _loading = false);
    }
    if (!mounted) return;
    Navigator.pushNamed(context, RoutesName.authPinPut, arguments: _fullPhone);
  }

  void _showError(String msg) {
    showTopSnack(context, msg);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColors.background,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background glow effect
          Positioned(
            top: -80.h,
            left: -80.w,
            child: Container(
              width: 280.w,
              height: 280.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AllColors.primaryColor.withOpacity(0.07),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: -60.w,
            child: Container(
              width: 220.w,
              height: 220.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AllColors.primaryColor.withOpacity(0.05),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(60.h),

                    // Logo Section
                    Center(
                      child: Column(
                        children: [
                          // Logo
                          Container(
                            width: 88.w,
                            height: 88.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28.r),
                              color: AllColors.cardColor,
                              border: Border.all(
                                color: AllColors.primaryColor.withOpacity(0.2),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AllColors.primaryColor.withOpacity(0.2),
                                  blurRadius: 30,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(26.r),
                              child: Image.asset(
                                'assets/images/neo_play.jpg',
                                width: 88.w,
                                height: 88.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Gap(20.h),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Neo',
                                  style: TextStyle(
                                    color: AllColors.primaryColor,
                                    fontSize: 32.sp,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Play',
                                  style: TextStyle(
                                    color: AllColors.white,
                                    fontSize: 32.sp,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Gap(8.h),
                          Text(
                            "Kino dunyosiga xush kelibsiz",
                            style: TextStyle(
                              color: AllColors.greyText,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Gap(52.h),

                    // Phone input section
                    Text(
                      "Telefon raqam",
                      style: TextStyle(
                        color: AllColors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Gap(10.h),
                    Focus(
                      onFocusChange: (v) => setState(() => _hasFocus = v),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: AllColors.cardColor,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: _hasFocus
                                ? AllColors.primaryColor.withOpacity(0.6)
                                : Colors.white.withOpacity(0.07),
                            width: 1.5,
                          ),
                          boxShadow: _hasFocus
                              ? [
                                  BoxShadow(
                                    color: AllColors.primaryColor.withOpacity(0.15),
                                    blurRadius: 16,
                                  )
                                ]
                              : null,
                        ),
                        child: Row(
                          children: [
                            // Country code
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.white.withOpacity(0.07),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "🇺🇿",
                                    style: TextStyle(fontSize: 18.sp),
                                  ),
                                  Gap(6.w),
                                  Text(
                                    "+998",
                                    style: TextStyle(
                                      color: AllColors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Phone number field
                            Expanded(
                              child: TextField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(12),
                                  _PhoneInputFormatter(),
                                ],
                                style: TextStyle(
                                  color: AllColors.white,
                                  fontSize: 16.sp,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: "90 123 45 67",
                                  hintStyle: TextStyle(
                                    color: AllColors.textMuted,
                                    fontSize: 16.sp,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 18.h,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Gap(12.h),
                    Text(
                      "SMS orqali tasdiqlash kodi yuboriladi",
                      style: TextStyle(
                        color: AllColors.textMuted,
                        fontSize: 12.sp,
                      ),
                    ),

                    Gap(36.h),

                    // Continue button
                    SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _onContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AllColors.primaryColor,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: AllColors.primaryColor.withOpacity(0.4),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: _loading
                            ? SizedBox(
                                height: 22.h,
                                width: 22.h,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Davom etish",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  Gap(8.w),
                                  Icon(Icons.arrow_forward_rounded, size: 20.sp),
                                ],
                              ),
                      ),
                    ),

                    Gap(24.h),

                    // Terms
                    Center(
                      child: Text(
                        "Davom etish orqali siz xizmat shartlarini qabul qilasiz",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AllColors.textMuted,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                    Gap(32.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showTopSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: AllColors.red,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    ),
  );
}

class _PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text  = newValue.text.replaceAll(RegExp(r'\D'), '');
    final chars = text.characters.toList();
    var buffer  = StringBuffer();

    for (int i = 0; i < chars.length; i++) {
      if (i == 2 || i == 5 || i == 7) buffer.write(' ');
      buffer.write(chars[i]);
    }

    final finalString   = buffer.toString();
    int cursorPosition  = newValue.selection.end;
    if (oldValue.text.length < newValue.text.length) {
      if (cursorPosition == 3 || cursorPosition == 7 || cursorPosition == 10) cursorPosition++;
    }

    return TextEditingValue(
      text: finalString,
      selection: TextSelection.collapsed(
        offset: cursorPosition > finalString.length ? finalString.length : cursorPosition,
      ),
    );
  }
}
