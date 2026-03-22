import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:neo_play/config/theme/colors/all_colors.dart';
import 'package:neo_play/core/router/routes_name.dart';
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
  int _start = 120; // 2 minut (120 sekund)

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  String get timerText {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    startTimer();
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
    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 60.h,
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

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AllColors.primaryColor),
      borderRadius: BorderRadius.circular(12.r),
    );

    final errorPinTheme = defaultPinTheme.copyDecorationWith(
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
                      text: "+998 90 *** ** **",
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

              Pinput(
                autofocus: true,
                length: 5,
                controller: _pinController,
                focusNode: _focusNode,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                errorPinTheme: errorPinTheme,
                separatorBuilder: (index) => Gap(12.w),
                hapticFeedbackType: HapticFeedbackType.lightImpact,
                onCompleted: (pin) {
                  Navigator.pushNamed(context, RoutesName.registerPage);
                },
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

              Gap(48.h),

              // Taymer yoki Qayta yuborish tugmasi
              if (_start > 0)
                Column(
                  children: [
                    Text(
                      "Kodni qayta yuborish: ",
                      style: TextStyle(
                        color: AllColors.greyText,
                        fontSize: 14.sp,
                      ),
                    ),
                    Gap(8.h),
                    Text(
                      timerText,
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
                      style: TextStyle(
                        color: AllColors.greyText,
                        fontSize: 14.sp,
                      ),
                    ),
                    Gap(4.h),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _start = 120;
                          startTimer();
                        });
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
