import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:neo_play/config/theme/colors/all_colors.dart';
import 'package:neo_play/core/router/routes_name.dart';
import 'package:neo_play/core/service/auth_service.dart';
import 'package:neo_play/core/service/api/auth_api.dart';
import 'package:neo_play/core/service/api/api_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  bool _loading = false;

  Future<void> _onRegister() async {
    final firstName = _firstNameController.text.trim();
    if (firstName.isEmpty) {
      _showError("Ismingizni kiriting");
      return;
    }

    setState(() => _loading = true);
    try {
      final data = await AuthApi.register(
        firstName,
        _lastNameController.text.trim(),
      );
      final user = data['user'] as Map<String, dynamic>;

      // Mavjud tokenni olib, user ma'lumotlarini yangilaymiz
      final token = await ApiService.getToken() ?? '';
      await AuthService.saveSession(token: token, user: user);

      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesName.homePage,
        (route) => false,
      );
    } catch (_) {
      // Backend ishlamasa ham home ga o'tish
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesName.homePage,
        (route) => false,
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AllColors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
    );
  }

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

              _buildInputLabel("Ism"),
              Gap(12.h),
              _buildTextField(
                controller: _firstNameController,
                hintText: "Ismingizni kiriting",
                icon: Icons.person_outline_rounded,
              ),

              Gap(24.h),

              _buildInputLabel("Familiya"),
              Gap(12.h),
              _buildTextField(
                controller: _lastNameController,
                hintText: "Familiyangizni kiriting",
                icon: Icons.person_outline_rounded,
              ),

              Gap(48.h),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _onRegister,
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
                  child: _loading
                      ? SizedBox(
                          height: 20.h,
                          width: 20.h,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Ro'yxatdan o'tish",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              Gap(24.h),

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
