import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:neo_play/config/theme/colors/all_colors.dart';
import 'package:neo_play/core/router/routes_name.dart';
import 'package:shimmer/shimmer.dart';

class SearchPage extends StatefulWidget {
  final VoidCallback? onBack;
  const SearchPage({super.key, this.onBack});

  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;
  List<int> _results = [];

  void focusSearchField() {
    _searchFocusNode.requestFocus();
  }

  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _isSearching = false;
        _results = [];
      } else {
        _isSearching = true;
        if (query.toLowerCase() == "bo'sh") {
          _results = [];
        } else {
          _results = List.generate(10, (index) => index);
        }
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColors.background,
      body: Stack(
        children: [
          // Content (Scrollable)
          Positioned.fill(child: _buildBody()),
          // Top Search Bar (Floating)
          Positioned(top: 0, left: 0, right: 0, child: _buildSearchBar()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff0F0F0F),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 24.h),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (widget.onBack != null) {
                    widget.onBack!();
                  } else {
                    Navigator.maybePop(context);
                  }
                },
                child: Container(
                  height: 44.h,
                  width: 44.h,
                  decoration: BoxDecoration(
                    color: const Color(0xff1A1B1E),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 28.sp,
                  ),
                ),
              ),
              Gap(10.w),
              Expanded(
                child: Container(
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: const Color(0xff1A1B1E),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onChanged: _onSearch,
                    style: TextStyle(color: Colors.white, fontSize: 15.sp),
                    cursorColor: AllColors.primaryColor,
                    decoration: InputDecoration(
                      hintText: "Film, serial, multfilm izlash...",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 15.sp,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.shade600,
                        size: 22.sp,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.grey.shade600,
                                size: 18.sp,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                _onSearch("");
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 8.h),
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

  Widget _buildBody() {
    if (!_isSearching) {
      return _buildInitialState();
    }

    if (_results.isEmpty) {
      return _buildNotFoundState();
    }

    return _buildResultsState();
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_rounded,
            color: Colors.grey.withOpacity(0.3),
            size: 100.sp,
          ),
          Gap(16.h),
          Text(
            "Film yoki serial qidirishni boshlang",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsState() {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.w, 140.h, 16.w, 100.h),
      itemCount: _results.length,
      separatorBuilder: (context, index) => Gap(16.h),
      itemBuilder: (context, index) {
        return _buildSearchResultItem(index);
      },
    );
  }

  Widget _buildSearchResultItem(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RoutesName.movieDetails);
      },
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: const Color(0xff0F0F0F),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://picsum.photos/seed/${index + 100}/400/600",
                    width: 100.w,
                    height: 140.h,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => _buildShimmer(140.h, 100.w),
                  ),
                ),
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 12.sp,
                        ),
                        Gap(2.w),
                        Text(
                          "4.6",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Gap(16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Baxt",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(4.h),
                  Text(
                    "2023 / Qo'rqinchli / 16 qism",
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  ),
                  Gap(8.h),
                  Text(
                    "Mana bir necha yildirki, insoniyat COVID-19 pandemiyasi sharoitida yashamoqda...",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 12.sp,
                    ),
                  ),
                  Gap(12.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: AllColors.primaryColor,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                        Gap(4.w),
                        Text(
                          "Tomosha qilish",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotFoundState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, color: Colors.grey, size: 80.sp),
          Gap(16.h),
          Text(
            "Hech narsa topilmadi",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Gap(8.h),
          Text(
            "Boshqa kalit so'zlar bilan qidirib ko'ring",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer(double height, double width) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[800]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}
