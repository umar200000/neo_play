import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neo_play/config/theme/colors/all_colors.dart';
import 'package:neo_play/core/service/auth_service.dart';
import 'package:neo_play/core/service/api/auth_api.dart';
import 'package:neo_play/core/service/api/api_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl  = TextEditingController();
  final _picker = ImagePicker();

  Map<String, dynamic>? _user;
  File? _pickedImage;
  bool _loading = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    setState(() => _loading = true);
    final local = await AuthService.getUser();
    if (local != null) {
      _user = local;
      _firstNameCtrl.text = local['first_name'] as String? ?? '';
      _lastNameCtrl.text  = local['last_name']  as String? ?? '';
    }
    // Backenddan yangi ma'lumot olish
    try {
      final data = await AuthApi.getMe();
      final fresh = data['user'] as Map<String, dynamic>;
      _user = fresh;
      _firstNameCtrl.text = fresh['first_name'] as String? ?? '';
      _lastNameCtrl.text  = fresh['last_name']  as String? ?? '';
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  String? get _currentAvatarUrl {
    final url = _user?['avatar'] as String?;
    if (url == null || url.isEmpty) return null;
    if (url.startsWith('http')) return url;
    return 'http://localhost:3000$url';
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        margin: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AllColors.cardColor,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Gap(8.h),
            Container(
              width: 40.w, height: 4.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Gap(20.h),
            Text("Rasm tanlash",
                style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
            Gap(16.h),
            _sheetItem(
              icon: Icons.photo_library_outlined,
              label: "Galereya",
              onTap: () async {
                Navigator.pop(ctx);
                final xFile = await _picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 80,
                  maxWidth: 800,
                );
                if (xFile != null && mounted) {
                  setState(() => _pickedImage = File(xFile.path));
                }
              },
            ),
            Gap(8.h),
            _sheetItem(
              icon: Icons.camera_alt_outlined,
              label: "Kamera",
              onTap: () async {
                Navigator.pop(ctx);
                final xFile = await _picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 80,
                  maxWidth: 800,
                );
                if (xFile != null && mounted) {
                  setState(() => _pickedImage = File(xFile.path));
                }
              },
            ),
            Gap(24.h),
          ],
        ),
      ),
    );
  }

  Widget _sheetItem({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white.withOpacity(0.07)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AllColors.primaryColor, size: 22.sp),
            Gap(16.w),
            Text(label,
                style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final firstName = _firstNameCtrl.text.trim();
    if (firstName.isEmpty) {
      _showSnack("Ismingizni kiriting");
      return;
    }

    setState(() => _saving = true);
    try {
      // 1. Agar yangi rasm tanlangan bo'lsa — yuklaymiz
      if (_pickedImage != null) {
        final avatarData = await AuthApi.uploadAvatar(_pickedImage!);
        _user = avatarData['user'] as Map<String, dynamic>?;
      }

      // 2. Ism/familiyani yangilaymiz
      final data = await AuthApi.updateProfile(
        firstName: firstName,
        lastName: _lastNameCtrl.text.trim(),
      );
      final updatedUser = data['user'] as Map<String, dynamic>;

      // 3. Localda saqlaymiz
      final token = await ApiService.getToken() ?? '';
      await AuthService.saveSession(token: token, user: updatedUser);

      if (!mounted) return;
      _showSnack("Muvaffaqiyatli saqlandi", success: true);
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      _showSnack("Xatolik: ${e.toString()}");
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showSnack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success ? Colors.green.shade700 : AllColors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Profilni tahrirlash",
          style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AllColors.primaryColor))
          : SingleChildScrollView(
              padding: EdgeInsets.all(24.r),
              child: Column(
                children: [
                  // Avatar
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        children: [
                          Container(
                            height: 100.r, width: 100.r,
                            decoration: BoxDecoration(
                              color: AllColors.cardColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AllColors.primaryColor.withOpacity(0.3), width: 2),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: _pickedImage != null
                                ? Image.file(_pickedImage!, fit: BoxFit.cover)
                                : _currentAvatarUrl != null
                                    ? Image.network(
                                        _currentAvatarUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Icon(
                                          Icons.person_rounded,
                                          color: AllColors.primaryColor,
                                          size: 50.sp,
                                        ),
                                      )
                                    : Icon(Icons.person_rounded,
                                        color: AllColors.primaryColor, size: 50.sp),
                          ),
                          Positioned(
                            bottom: 0, right: 0,
                            child: Container(
                              padding: EdgeInsets.all(8.r),
                              decoration: const BoxDecoration(
                                color: AllColors.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.camera_alt_rounded,
                                  color: Colors.white, size: 16.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Gap(8.h),
                  Text(
                    "Rasmni o'zgartirish uchun bosing",
                    style: TextStyle(color: AllColors.greyText, fontSize: 12.sp),
                  ),
                  Gap(36.h),

                  // Ism
                  _buildField(
                    label: "Ism",
                    controller: _firstNameCtrl,
                    hint: "Ismingizni kiriting",
                  ),
                  Gap(20.h),

                  // Familiya
                  _buildField(
                    label: "Familiya",
                    controller: _lastNameCtrl,
                    hint: "Familiyangizni kiriting",
                  ),
                  Gap(40.h),

                  // Saqlash tugmasi
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AllColors.primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        elevation: 8,
                        shadowColor: AllColors.primaryColor.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r)),
                      ),
                      child: _saving
                          ? SizedBox(
                              height: 20.h, width: 20.h,
                              child: const CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : Text("Saqlash",
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: AllColors.greyText,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500)),
        Gap(8.h),
        TextField(
          controller: controller,
          style: TextStyle(color: Colors.white, fontSize: 15.sp),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 14.sp),
            filled: true,
            fillColor: AllColors.cardColor,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide:
                  BorderSide(color: AllColors.primaryColor.withOpacity(0.5)),
            ),
          ),
        ),
      ],
    );
  }
}
