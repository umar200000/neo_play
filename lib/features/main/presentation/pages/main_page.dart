import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:neo_play/config/theme/colors/all_colors.dart';
import 'package:neo_play/core/router/routes_name.dart';
import 'package:neo_play/core/service/api/movie_api.dart';
import 'package:shimmer/shimmer.dart';

class MainPage extends StatefulWidget {
  final VoidCallback? onSearchTap;
  const MainPage({super.key, this.onSearchTap});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentCarouselIndex = 0;
  bool _loading = true;
  String? _error;

  List<Map<String, dynamic>> _banners         = [];
  List<Map<String, dynamic>> _recentlyWatched = [];
  List<Map<String, dynamic>> _dubbedMovies    = [];
  List<Map<String, dynamic>> _series          = [];
  List<Map<String, dynamic>> _cartoons        = [];

  @override
  void initState() {
    super.initState();
    _loadHome();
  }

  Future<void> _loadHome() async {
    setState(() { _loading = true; _error = null; });
    try {
      final data = await MovieApi.getHome();
      if (!mounted) return;
      setState(() {
        _banners         = _castList(data['banners']);
        _recentlyWatched = _castList(data['recently_watched']);
        _dubbedMovies    = _castList(data['dubbed_movies']);
        _series          = _castList(data['series']);
        _cartoons        = _castList(data['cartoons']);
        _loading = false;
      });
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = e.toString(); });
    }
  }

  List<Map<String, dynamic>> _castList(dynamic raw) {
    if (raw == null) return [];
    return (raw as List).cast<Map<String, dynamic>>();
  }

  void _navigateToDetails(int? movieId) async {
    if (movieId != null) {
      await Navigator.pushNamed(context, RoutesName.movieDetails, arguments: movieId);
      if (mounted) _loadHome();
    } else {
      Navigator.pushNamed(context, RoutesName.movieDetails);
    }
  }

  void _navigateToMovieList(String title) {
    Navigator.pushNamed(context, RoutesName.movieList, arguments: title);
  }

  void _navigateToNotification() {
    Navigator.pushNamed(context, RoutesName.notification);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColors.background,
      body: RefreshIndicator(
        color: AllColors.primaryColor,
        backgroundColor: AllColors.cardColor,
        displacement: 80,
        onRefresh: _loadHome,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Banner with top overlay
              Stack(
                children: [
                  _buildBannerCarousel(),
                  // Top navigation bar overlay
                  Positioned(
                    top: 0, left: 0, right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.75),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                          child: Row(
                            children: [
                              // Logo
                              Row(
                                children: [
                                  Text(
                                    'Neo',
                                    style: TextStyle(
                                      color: AllColors.primaryColor,
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  Text(
                                    'Play',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              // Notification icon
                              GestureDetector(
                                onTap: _navigateToNotification,
                                child: Container(
                                  width: 40.h, height: 40.h,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.12)),
                                  ),
                                  child: Icon(Icons.notifications_none_rounded,
                                      color: Colors.white, size: 20.sp),
                                ),
                              ),
                              Gap(8.w),
                              // Search icon
                              GestureDetector(
                                onTap: widget.onSearchTap,
                                child: Container(
                                  width: 40.h, height: 40.h,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.12)),
                                  ),
                                  child: Icon(Icons.search_rounded,
                                      color: Colors.white, size: 20.sp),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // ── Content sections
              if (_loading) ...[
                Gap(8.h),
                _buildLoadingSection(),
                Gap(8.h),
                _buildLoadingSection(),
                Gap(8.h),
                _buildLoadingSection(),
              ] else if (_error != null) ...[
                _buildErrorWidget(),
              ] else ...[
                Gap(8.h),
                if (_recentlyWatched.isNotEmpty) ...[
                  _buildSection(
                    title: "Avval ko'rilganlar",
                    movies: _recentlyWatched,
                    isLarge: true,
                    showProgress: true,
                  ),
                  Gap(8.h),
                ],
                _buildSection(title: 'Tarjima kinolar', movies: _dubbedMovies),
                Gap(8.h),
                _buildSection(title: 'Seriallar',       movies: _series),
                Gap(8.h),
                _buildSection(title: 'Multfilmlar',     movies: _cartoons),
              ],
              Gap(90.h),
            ],
          ),
        ),
      ),
    );
  }

  // ── Banner ────────────────────────────────────────────────────────────────

  Widget _buildBannerCarousel() {
    if (_loading || _banners.isEmpty) {
      return _buildShimmer(430.h, double.infinity);
    }

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: _banners.length,
          options: CarouselOptions(
            height: 430.h,
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayCurve: Curves.easeInOut,
            onPageChanged: (index, _) => setState(() => _currentCarouselIndex = index),
          ),
          itemBuilder: (context, index, _) {
            final banner   = _banners[index];
            final imageUrl = MovieApi.fullImageUrl(banner['image_url'] as String?);
            final movieId  = banner['movie_id'] as int?;
            final title    = banner['title_uz'] as String? ?? '';

            return GestureDetector(
              onTap: () => _navigateToDetails(movieId),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Backdrop image
                  CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: AllColors.cardColor),
                    errorWidget: (_, __, ___) => Container(
                      color: AllColors.cardColor,
                      child: Icon(Icons.movie_outlined,
                          color: AllColors.greyText, size: 64.sp),
                    ),
                  ),
                  // Gradient overlay
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.4, 0.75, 1.0],
                        colors: [
                          Colors.transparent,
                          AllColors.background.withOpacity(0.7),
                          AllColors.background,
                        ],
                      ),
                    ),
                  ),
                  // Bottom content
                  Positioned(
                    bottom: 16.h, left: 16.w, right: 16.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (title.isNotEmpty) ...[
                          Text(
                            title.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                              shadows: const [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 10,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          Gap(14.h),
                        ],
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Play button
                            GestureDetector(
                              onTap: () => _navigateToDetails(movieId),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 11.h),
                                decoration: BoxDecoration(
                                  color: AllColors.primaryColor,
                                  borderRadius: BorderRadius.circular(30.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AllColors.primaryColor.withOpacity(0.5),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.play_arrow_rounded,
                                        color: Colors.white, size: 20.sp),
                                    Gap(6.w),
                                    Text(
                                      'Tomosha qilish',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Gap(12.w),
                            // Info button
                            Container(
                              width: 42.h, height: 42.h,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.2)),
                              ),
                              child: Icon(Icons.info_outline_rounded,
                                  color: Colors.white, size: 20.sp),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        // Dot indicators
        Gap(10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (i) {
            final isActive = _currentCarouselIndex == i;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: isActive ? 20.w : 6.w,
              height: 4.h,
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.r),
                color: isActive
                    ? AllColors.primaryColor
                    : Colors.white.withOpacity(0.25),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ── Section ───────────────────────────────────────────────────────────────

  Widget _buildSection({
    required String title,
    required List<Map<String, dynamic>> movies,
    bool isLarge = false,
    bool showProgress = false,
  }) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 0),
      padding: EdgeInsets.symmetric(vertical: 18.h),
      decoration: BoxDecoration(
        color: AllColors.cardColor,
        borderRadius: BorderRadius.circular(28.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 3.w, height: 16.h,
                      decoration: BoxDecoration(
                        color: AllColors.primaryColor,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    Gap(8.w),
                    Text(
                      title,
                      style: TextStyle(
                        color: AllColors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => _navigateToMovieList(title),
                  behavior: HitTestBehavior.translucent,
                  child: Row(
                    children: [
                      Text(
                        "Barchasi",
                        style: TextStyle(
                            color: AllColors.greyText, fontSize: 12.sp),
                      ),
                      Gap(2.w),
                      Icon(Icons.arrow_forward_ios_rounded,
                          color: AllColors.greyText, size: 11.sp),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gap(14.h),
          SizedBox(
            height: isLarge ? 180.h : 235.h,
            child: AlignedGridView.count(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              crossAxisCount: 1,
              mainAxisSpacing: 12.w,
              itemCount: movies.length,
              itemBuilder: (ctx, i) => _buildMovieCard(
                movies[i],
                isLarge: isLarge,
                showProgress: showProgress,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCard(
    Map<String, dynamic> movie, {
    required bool isLarge,
    bool showProgress = false,
  }) {
    final imageUrl = MovieApi.fullImageUrl(movie['poster_url'] as String?);
    final title    = movie['title_uz'] as String? ?? '';
    final rating   = (movie['neoplay_rating'] ?? movie['imdb_rating'] ?? 0.0) as num;
    final movieId  = movie['id'] as int?;

    double progress = 0;
    if (showProgress) {
      final prog  = (movie['progress_seconds'] ?? 0) as num;
      final total = (movie['total_seconds'] ?? 0) as num;
      if (total > 0) progress = (prog / total).clamp(0.0, 1.0).toDouble();
    }

    final double cardW = isLarge ? 220.w : 130.w;
    final double cardH = isLarge ? 140.h : 190.h;

    return GestureDetector(
      onTap: () => _navigateToDetails(movieId),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: cardW, height: cardH,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => _buildShimmer(cardH, cardW, radius: 14.r),
                  errorWidget: (_, __, ___) => Container(
                    width: cardW, height: cardH,
                    color: AllColors.cardHigh,
                    child: Icon(Icons.movie_outlined, color: AllColors.greyText, size: 28.sp),
                  ),
                ),
              ),
              // Gradient at bottom for readability
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  height: 56.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(14.r)),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black.withOpacity(0.65), Colors.transparent],
                    ),
                  ),
                ),
              ),
              // Rating badge
              Positioned(
                top: 7.h, left: 7.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_rounded, color: AllColors.yellow, size: 9.sp),
                      Gap(2.w),
                      Text(
                        rating > 0 ? rating.toStringAsFixed(1) : '—',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              // Progress bar at bottom
              if (showProgress && progress > 0)
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(14.r)),
                    child: SizedBox(
                      height: 3.h,
                      child: Stack(
                        children: [
                          Container(color: Colors.white.withOpacity(0.2)),
                          FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: progress,
                            child: Container(color: AllColors.primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Gap(7.h),
          SizedBox(
            width: cardW,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AllColors.white,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Loading ───────────────────────────────────────────────────────────────

  Widget _buildLoadingSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AllColors.cardColor,
        borderRadius: BorderRadius.circular(28.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildShimmer(16.h, 140.w),
          Gap(14.h),
          SizedBox(
            height: 200.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, __) => Gap(12.w),
              itemBuilder: (_, __) => _buildShimmer(180.h, 130.w, radius: 14.r),
            ),
          ),
        ],
      ),
    );
  }

  // ── Error ─────────────────────────────────────────────────────────────────

  Widget _buildErrorWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 40.h),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 72.w, height: 72.w,
              decoration: BoxDecoration(
                  color: AllColors.cardColor, shape: BoxShape.circle),
              child: Icon(Icons.wifi_off_rounded,
                  color: AllColors.greyText, size: 32.sp),
            ),
            Gap(16.h),
            Text("Ulanishda xatolik",
                style: TextStyle(
                    color: AllColors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold)),
            Gap(8.h),
            Text("Qayta urinib ko'ring",
                style: TextStyle(color: AllColors.greyText, fontSize: 13.sp)),
            Gap(24.h),
            GestureDetector(
              onTap: _loadHome,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 13.h),
                decoration: BoxDecoration(
                  color: AllColors.primaryColor,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Text('Qayta urinish',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _buildShimmer(double height, double width, {double? radius}) {
    return Shimmer.fromColors(
      baseColor: AllColors.cardHigh,
      highlightColor: AllColors.surfaceLight,
      child: Container(
        height: height, width: width,
        decoration: BoxDecoration(
          color: AllColors.cardHigh,
          borderRadius: BorderRadius.circular(radius ?? 12.r),
        ),
      ),
    );
  }
}
