import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:neo_play/config/theme/colors/all_colors.dart';
import 'package:neo_play/core/router/routes_name.dart';
import 'package:neo_play/core/service/auth_service.dart';
import 'package:neo_play/core/service/api/auth_api.dart';
import 'package:neo_play/core/service/api/api_service.dart';
import 'package:pinput/pinput.dart';

class AuthPinPut extends StatefulWidget {
  const AuthPinPut({super.key});

  @override
  State<AuthPinPut> createState() => _AuthPinPutState();
}

class _AuthPinPutState extends State<AuthPinPut> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Timer? _timer;
  int _start = 120;
  bool _hasError = false;
  bool _loading = false;

  static const _correctPin = '111111';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_start == 0) {
        t.cancel();
      } else {
        setState(() => _start--);
      }
    });
  }

  String get _timerText {
    final m = _start ~/ 60;
    final s = _start % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String _maskPhone(String phone) {
    if (phone.length < 7) return phone;
    return '${phone.substring(0, 7)} *** ** **';
  }

  Future<void> _onPinCompleted(String pin) async {
    if (pin != _correctPin) {
      setState(() => _hasError = true);
      _pinController.clear();
      return;
    }

    setState(() { _hasError = false; _loading = true; });

    final phone = ModalRoute.of(context)?.settings.arguments as String? ?? '';

    try {
      final data = await AuthApi.verifyOtp(phone, pin);
      final token = data['token'] as String;
      final isNew = data['is_new'] as bool? ?? true;
      final user = data['user'] as Map<String, dynamic>;

      await AuthService.saveSession(token: token, user: user);
      await ApiService.setToken(token);

      if (!mounted) return;

      if (isNew) {
        Navigator.pushNamed(context, RoutesName.registerPage, arguments: token);
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesName.homePage,
          (route) => false,
        );
      }
    } catch (_) {
      // Backend javob bermasa ham, 111111 bilan o'tishga ruxsat
      if (!mounted) return;
      final phone2 = ModalRoute.of(context)?.settings.arguments as String? ?? '';
      final fakeUser = {'id': 0, 'phone': phone2, 'first_name': null, 'last_name': null, 'balance': 0};
      await AuthService.saveSession(token: 'offline_token', user: fakeUser);

      if (!mounted) return;
      Navigator.pushNamed(context, RoutesName.registerPage, arguments: 'offline_token');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phone = ModalRoute.of(context)?.settings.arguments as String? ?? '';

    final defaultTheme = PinTheme(
      width: 52.w,
      height: 58.h,
      textStyle: TextStyle(
        fontSize: 22.sp,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: AllColors.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
    );

    final focusedTheme = defaultTheme.copyDecorationWith(
      border: Border.all(color: AllColors.primaryColor),
      borderRadius: BorderRadius.circular(12.r),
    );

    final errorTheme = defaultTheme.copyDecorationWith(
      border: Border.all(color: Colors.redAccent),
      borderRadius: BorderRadius.circular(12.r),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AllColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(40.h),
              Text(
                "Tasdiqlash kodi",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(12.h),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    color: AllColors.greyText,
                    fontSize: 14.sp,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(text: "Tasdiqlash kodi "),
                    TextSpan(
                      text: _maskPhone(phone),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                      text: "\nraqamiga yuborildi. Uni quyida kiriting.",
                    ),
                  ],
                ),
              ),
              Gap(48.h),

              _loading
                  ? SizedBox(
                      height: 58.h,
                      child: const Center(
                        child: CircularProgressIndicator(color: AllColors.primaryColor),
                      ),
                    )
                  : Pinput(
                      autofocus: true,
                      length: 6,
                      controller: _pinController,
                      focusNode: _focusNode,
                      defaultPinTheme: defaultTheme,
                      focusedPinTheme: focusedTheme,
                      errorPinTheme: errorTheme,
                      forceErrorState: _hasError,
                      separatorBuilder: (index) => Gap(10.w),
                      hapticFeedbackType: HapticFeedbackType.lightImpact,
                      onChanged: (_) {
                        if (_hasError) setState(() => _hasError = false);
                      },
                      onCompleted: _onPinCompleted,
                      cursor: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 9.h),
                            width: 22.w,
                            height: 1,
                            color: AllColors.primaryColor,
                          ),
                        ],
                      ),
                    ),

              Gap(16.h),

              // Error xabar
              AnimatedOpacity(
                opacity: _hasError ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.redAccent, size: 16.sp),
                    Gap(6.w),
                    Text(
                      "Kod noto'g'ri. Qayta urinib ko'ring",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),

              Gap(32.h),

              if (_start > 0)
                Column(
                  children: [
                    Text(
                      "Kodni qayta yuborish:",
                      style: TextStyle(color: AllColors.greyText, fontSize: 14.sp),
                    ),
                    Gap(8.h),
                    Text(
                      _timerText,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    Text(
                      "Kodni olmadingizmi?",
                      style: TextStyle(color: AllColors.greyText, fontSize: 14.sp),
                    ),
                    Gap(4.h),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _start = 120;
                          _hasError = false;
                          _pinController.clear();
                        });
                        _startTimer();
                      },
                      child: Text(
                        "Kodni qayta yuborish",
                        style: TextStyle(
                          color: AllColors.primaryColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
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
}
