import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:neo_play/config/theme/colors/all_colors.dart';
import 'package:neo_play/core/router/routes_name.dart';
import 'package:neo_play/core/service/api/movie_api.dart';
import 'package:shimmer/shimmer.dart';

class SearchPage extends StatefulWidget {
  final VoidCallback? onBack;
  const SearchPage({super.key, this.onBack});
  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode             _searchFocusNode  = FocusNode();
  Timer? _debounce;

  bool _isSearching = false;
  bool _isLoading   = false;
  List<Map<String, dynamic>> _results = [];

  void focusSearchField() => _searchFocusNode.requestFocus();

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      setState(() { _isSearching = false; _isLoading = false; _results = []; });
      return;
    }
    setState(() { _isSearching = true; _isLoading = true; });
    _debounce = Timer(const Duration(milliseconds: 450), () => _doSearch(query.trim()));
  }

  Future<void> _doSearch(String query) async {
    try {
      final data   = await MovieApi.search(query);
      final movies = (data['movies'] as List? ?? []).cast<Map<String, dynamic>>();
      if (mounted) setState(() { _results = movies; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _results = []; _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColors.background,
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AllColors.background,
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.06)),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
          child: Row(
            children: [
              // Back button
              GestureDetector(
                onTap: () {
                  if (widget.onBack != null) {
                    widget.onBack!();
                  } else {
                    Navigator.maybePop(context);
                  }
                },
                child: Container(
                  height: 44.h, width: 44.h,
                  decoration: BoxDecoration(
                    color: AllColors.cardHigh,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.06)),
                  ),
                  child: Icon(Icons.arrow_back_rounded, color: AllColors.white, size: 20.sp),
                ),
              ),
              Gap(12.w),
              // Search field
              Expanded(
                child: Container(
                  height: 46.h,
                  decoration: BoxDecoration(
                    color: AllColors.cardColor,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: Colors.white.withOpacity(0.07)),
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onChanged: _onSearch,
                    style: TextStyle(color: AllColors.white, fontSize: 14.sp),
                    cursorColor: AllColors.primaryColor,
                    cursorWidth: 1.5,
                    decoration: InputDecoration(
                      hintText: 'Film, serial, multfilm izlang...',
                      hintStyle: TextStyle(color: AllColors.textMuted, fontSize: 14.sp),
                      prefixIcon: Icon(Icons.search_rounded,
                          color: AllColors.greyText, size: 20.sp),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () { _searchController.clear(); _onSearch(''); },
                              child: Container(
                                margin: EdgeInsets.all(10.r),
                                decoration: BoxDecoration(
                                  color: AllColors.surfaceLight,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.close_rounded,
                                    color: AllColors.greyText, size: 14.sp),
                              ),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
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
    if (!_isSearching) return _buildInitialState();
    if (_isLoading)    return _buildLoadingState();
    if (_results.isEmpty) return _buildNotFoundState();
    return _buildResultsState();
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88.w, height: 88.w,
            decoration: BoxDecoration(
              color: AllColors.cardColor,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.search_rounded,
                color: AllColors.greyText.withOpacity(0.5), size: 40.sp),
          ),
          Gap(20.h),
          Text(
            'Film, serial yoki multfilm qidiring',
            style: TextStyle(
              color: AllColors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(8.h),
          Text(
            "Sarlavha bo'yicha qidiring",
            style: TextStyle(color: AllColors.greyText, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
      itemCount: 4,
      separatorBuilder: (_, __) => Gap(12.h),
      itemBuilder: (_, __) => _buildShimmerCard(),
    );
  }

  Widget _buildResultsState() {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
      itemCount: _results.length,
      separatorBuilder: (_, __) => Gap(10.h),
      itemBuilder: (ctx, i) => _buildResultCard(_results[i]),
    );
  }

  Widget _buildResultCard(Map<String, dynamic> movie) {
    final imageUrl = MovieApi.fullImageUrl(movie['poster_url'] as String?);
    final title    = movie['title_uz'] as String? ?? '';
    final year     = movie['release_year'] as int?;
    final rating   = (movie['neoplay_rating'] ?? movie['imdb_rating'] ?? 0.0) as num;
    final desc     = movie['description_uz'] as String? ?? '';
    final movieId  = movie['id'] as int?;
    final seasons  = (movie['total_seasons'] ?? 0) as int;
    final duration = (movie['duration_minutes'] ?? 0) as int;

    String meta = '';
    if (year != null) meta = '$year';
    if (seasons > 0) {
      meta += ' · $seasons mavsum';
    } else if (duration > 0) {
      meta += ' · ${duration}d.';
    }

    return GestureDetector(
      onTap: () {
        if (movieId != null) {
          Navigator.pushNamed(context, RoutesName.movieDetails, arguments: movieId);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AllColors.cardColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft:     Radius.circular(20.r),
                bottomLeft:  Radius.circular(20.r),
              ),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 90.w,
                    height: 130.h,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => _buildShimmer(130.h, 90.w),
                    errorWidget: (_, __, ___) => Container(
                      width: 90.w, height: 130.h,
                      color: AllColors.cardHigh,
                      child: Icon(Icons.movie_outlined, color: AllColors.greyText, size: 28.sp),
                    ),
                  ),
                  // Rating badge
                  Positioned(
                    top: 8.h, left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_rounded, color: AllColors.yellow, size: 10.sp),
                          Gap(2.w),
                          Text(
                            rating > 0 ? rating.toStringAsFixed(1) : '—',
                            style: TextStyle(color: Colors.white, fontSize: 9.sp, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(14.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AllColors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                    if (meta.isNotEmpty) ...[
                      Gap(4.h),
                      Text(meta,
                          style: TextStyle(color: AllColors.greyText, fontSize: 11.sp)),
                    ],
                    if (desc.isNotEmpty) ...[
                      Gap(8.h),
                      Text(
                        desc,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AllColors.greyText,
                          fontSize: 11.sp,
                          height: 1.4,
                        ),
                      ),
                    ],
                    Gap(10.h),
                    // Play button
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                      decoration: BoxDecoration(
                        color: AllColors.primaryColor,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_arrow_rounded, color: Colors.white, size: 16.sp),
                          Gap(4.w),
                          Text("Tomosha qilish",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
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
          Container(
            width: 88.w, height: 88.w,
            decoration: BoxDecoration(
              color: AllColors.cardColor,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.search_off_rounded,
                color: AllColors.greyText.withOpacity(0.5), size: 40.sp),
          ),
          Gap(20.h),
          Text("Hech narsa topilmadi",
              style: TextStyle(color: AllColors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
          Gap(8.h),
          Text(
            "Boshqa kalit so'zlar bilan qidirib ko'ring",
            textAlign: TextAlign.center,
            style: TextStyle(color: AllColors.greyText, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      height: 130.h,
      decoration: BoxDecoration(
        color: AllColors.cardColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          _buildShimmer(130.h, 90.w, radius: 20.r),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(14.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildShimmer(16.h, double.infinity),
                  Gap(8.h),
                  _buildShimmer(11.h, 120.w),
                  Gap(8.h),
                  _buildShimmer(32.h, double.infinity),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer(double height, double width, {double? radius}) {
    return Shimmer.fromColors(
      baseColor: AllColors.cardHigh,
      highlightColor: AllColors.surfaceLight,
      child: Container(
        height: height, width: width,
        decoration: BoxDecoration(
          color: AllColors.cardHigh,
          borderRadius: BorderRadius.circular(radius ?? 8.r),
        ),
      ),
    );
  }
}
