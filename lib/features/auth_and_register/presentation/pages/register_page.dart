import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:neo_play/config/theme/colors/all_colors.dart';
import 'package:neo_play/core/router/routes_name.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(20.h),
              // Sarlavha qismi
              Text(
                "Ro'yxatdan o'tish",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(8.h),
              Text(
                "Davom etish uchun ma'lumotlaringizni kiriting",
                style: TextStyle(color: AllColors.greyText, fontSize: 14.sp),
              ),
              Gap(40.h),

              // Ism inputi
              _buildInputLabel("Ism"),
              Gap(12.h),
              _buildTextField(
                controller: _firstNameController,
                hintText: "Ismingizni kiriting",
                icon: Icons.person_outline_rounded,
              ),

              Gap(24.h),

              // Familiya inputi
              _buildInputLabel("Familiya"),
              Gap(12.h),
              _buildTextField(
                controller: _lastNameController,
                hintText: "Familiyangizni kiriting",
                icon: Icons.person_outline_rounded,
              ),

              Gap(48.h),

              // Ro'yxatdan o'tish tugmasi
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Home sahifasiga o'tish (Hamma route-larni tozalab)
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RoutesName.homePage,
                      (route) => false,
                    );
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
                    "Ro'yxatdan o'tish",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Gap(24.h),

              // Shartlar va qoidalar
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        color: AllColors.greyText,
                        fontSize: 12.sp,
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(text: "Ro'yxatdan o'tish orqali siz "),
                        TextSpan(
                          text: "Foydalanish shartlari",
                          style: TextStyle(
                            color: AllColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(text: " va "),
                        TextSpan(
                          text: "Maxfiylik siyosati",
                          style: TextStyle(
                            color: AllColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(text: "ga rozilik bildirasiz"),
                      ],
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

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.white,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AllColors.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white, fontSize: 15.sp),
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: AllColors.greyText.withOpacity(0.5),
            size: 20.sp,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.2),
            fontSize: 15.sp,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 18.h,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
