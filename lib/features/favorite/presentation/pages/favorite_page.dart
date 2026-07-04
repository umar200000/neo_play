import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:neo_play/config/theme/colors/all_colors.dart';
import 'package:neo_play/core/router/routes_name.dart';
import 'package:neo_play/core/service/api/movie_api.dart';
import 'package:shimmer/shimmer.dart';

class FavoritePage extends StatefulWidget {
  final VoidCallback? onBack;
  const FavoritePage({super.key, this.onBack});

  @override
  FavoritePageState createState() => FavoritePageState();
}

class FavoritePageState extends State<FavoritePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  bool _loading = true;
  List<Map<String, dynamic>> _films    = [];
  List<Map<String, dynamic>> _series   = [];
  List<Map<String, dynamic>> _cartoons = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadFavorites();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void reload() => _loadFavorites();

  Future<void> _loadFavorites() async {
    setState(() => _loading = true);
    try {
      final data = await MovieApi.getFavorites();
      if (!mounted) return;
      setState(() {
        _films    = (data['films']    as List? ?? []).cast<Map<String, dynamic>>();
        _series   = (data['series']   as List? ?? []).cast<Map<String, dynamic>>();
        _cartoons = (data['cartoons'] as List? ?? []).cast<Map<String, dynamic>>();
        _loading  = false;
      });
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  bool get _isEmpty => _films.isEmpty && _series.isEmpty && _cartoons.isEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColors.background,
      body: Column(
        children: [
          _buildHeader(),
          if (!_loading) _buildTabBar(),
          Expanded(
            child: RefreshIndicator(
              color: AllColors.primaryColor,
              backgroundColor: AllColors.cardColor,
              onRefresh: _loadFavorites,
              child: _loading
                  ? _buildLoadingBody()
                  : _isEmpty
                      ? _buildEmptyBody()
                      : _buildTabBody(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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
              Gap(16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saqlanganlar',
                      style: TextStyle(
                        color: AllColors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (!_loading && !_isEmpty)
                      Text(
                        '${_films.length + _series.length + _cartoons.length} ta kontent',
                        style: TextStyle(color: AllColors.greyText, fontSize: 12.sp),
                      ),
                  ],
                ),
              ),
              Container(
                width: 40.h, height: 40.h,
                decoration: BoxDecoration(
                  color: AllColors.primaryMuted,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.bookmark_rounded, color: AllColors.primaryColor, size: 20.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    final tabs = [
      _TabInfo('Filmlar', _films.length),
      _TabInfo('Seriallar', _series.length),
      _TabInfo('Multfilmlar', _cartoons.length),
    ];

    return Container(
      height: 46.h,
      margin: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
      padding: EdgeInsets.all(3.r),
      decoration: BoxDecoration(
        color: AllColors.cardColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AllColors.cardHigh,
          borderRadius: BorderRadius.circular(11.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: AllColors.white,
        unselectedLabelColor: AllColors.greyText,
        labelStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
        unselectedLabelStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400),
        tabs: tabs.map((t) => Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(t.label),
              if (t.count > 0) ...[
                Gap(5.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AllColors.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    '${t.count}',
                    style: TextStyle(
                      color: AllColors.primaryColor,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildTabBody() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildGrid(_films),
        _buildGrid(_series),
        _buildGrid(_cartoons),
      ],
    );
  }

  Widget _buildGrid(List<Map<String, dynamic>> movies) {
    if (movies.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: 400.h,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 72.w, height: 72.w,
                  decoration: BoxDecoration(
                    color: AllColors.cardColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.bookmark_border_rounded,
                      color: AllColors.greyText.withOpacity(0.4), size: 32.sp),
                ),
                Gap(16.h),
                Text("Bu yerda hali hech narsa yo'q",
                    style: TextStyle(
                        color: AllColors.greyText,
                        fontSize: 14.sp)),
              ],
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
      child: AlignedGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 10.w,
        itemCount: movies.length,
        itemBuilder: (ctx, i) => _buildGridItem(movies[i]),
      ),
    );
  }

  Widget _buildGridItem(Map<String, dynamic> movie) {
    final imageUrl = MovieApi.fullImageUrl(movie['poster_url'] as String?);
    final title    = movie['title_uz'] as String? ?? '';
    final rating   = (movie['neoplay_rating'] ?? 0.0) as num;
    final movieId  = movie['id'] as int?;

    return GestureDetector(
      onTap: () async {
        await Navigator.pushNamed(context, RoutesName.movieDetails, arguments: movieId);
        if (mounted) _loadFavorites();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: 150.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => _buildShimmer(150.h, double.infinity),
                  errorWidget: (_, __, ___) => Container(
                    height: 150.h,
                    color: AllColors.cardHigh,
                    child: Icon(Icons.movie_outlined, color: AllColors.greyText, size: 24.sp),
                  ),
                ),
              ),
              // gradient overlay at bottom
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  height: 60.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(14.r)),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                    ),
                  ),
                ),
              ),
              // Rating badge
              Positioned(
                top: 6.h, left: 6.w,
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
                            color: Colors.white, fontSize: 8.sp, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              // Bookmark icon
              Positioned(
                top: 6.h, right: 6.w,
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: AllColors.primaryColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Icon(Icons.bookmark_rounded, color: Colors.white, size: 10.sp),
                ),
              ),
            ],
          ),
          Gap(7.h),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AllColors.white,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 60.h, 16.w, 100.h),
      child: AlignedGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 10.w,
        itemCount: 9,
        itemBuilder: (_, __) => _buildShimmer(150.h, double.infinity),
      ),
    );
  }

  Widget _buildEmptyBody() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: 600.h,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100.w, height: 100.w,
                decoration: BoxDecoration(
                  color: AllColors.cardColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Icon(Icons.bookmark_border_rounded,
                    color: AllColors.greyText.withOpacity(0.4), size: 46.sp),
              ),
              Gap(24.h),
              Text(
                "Hali hech narsa saqlanmagan",
                style: TextStyle(
                  color: AllColors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  "Kino yoki seriallarni saqlash uchun ularni sahifasidagi belgiga bosing",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AllColors.greyText, fontSize: 13.sp, height: 1.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer(double height, double width) {
    return Shimmer.fromColors(
      baseColor: AllColors.cardHigh,
      highlightColor: AllColors.surfaceLight,
      child: Container(
        height: height, width: width,
        decoration: BoxDecoration(
          color: AllColors.cardHigh,
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
    );
  }
}

class _TabInfo {
  final String label;
  final int count;
  const _TabInfo(this.label, this.count);
}
