import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:neo_play/config/theme/colors/all_colors.dart';
import 'package:neo_play/core/router/routes_name.dart';
import 'package:neo_play/core/service/api/movie_api.dart';
import 'package:shimmer/shimmer.dart';

class MovieList extends StatefulWidget {
  const MovieList({super.key, required this.movieListName});
  final String movieListName;

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  bool _loading = true;
  List<Map<String, dynamic>> _movies = [];

  static const _titleToSlug = {
    'Tarjima kinolar': 'movies',
    'Seriallar': 'series',
    'Multfilmlar': 'cartoons',
  };

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    setState(() => _loading = true);
    try {
      final slug = _titleToSlug[widget.movieListName];
      final data = await MovieApi.getMoviesByCategory(slug);
      if (!mounted) return;
      setState(() {
        _movies = (data['movies'] as List? ?? []).cast<Map<String, dynamic>>();
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColors.background,
      body: Stack(
        children: [
          RefreshIndicator(
            color: AllColors.primaryColor,
            backgroundColor: AllColors.cardColor,
            onRefresh: _loadMovies,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Gap(120.h),
                  if (_loading)
                    _buildLoadingGrid()
                  else if (_movies.isEmpty)
                    _buildEmpty()
                  else
                    _buildGrid(),
                  Gap(30.h),
                ],
              ),
            ),
          ),
          Positioned(top: 0, left: 0, right: 0, child: _buildHeader(context)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 44.h,
                  width: 44.h,
                  decoration: BoxDecoration(
                    color: const Color(0xff1A1B1E),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: const Icon(Icons.chevron_left, color: Colors.white),
                ),
              ),
              Gap(16.w),
              Expanded(
                child: Text(
                  widget.movieListName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: AlignedGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        mainAxisSpacing: 20.h,
        crossAxisSpacing: 12.w,
        itemCount: _movies.length,
        itemBuilder: (ctx, i) => _buildGridItem(ctx, _movies[i]),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, Map<String, dynamic> movie) {
    final imageUrl = MovieApi.fullImageUrl(movie['poster_url'] as String?);
    final title    = movie['title_uz'] as String? ?? '';
    final rating   = (movie['neoplay_rating'] ?? movie['imdb_rating'] ?? 0.0) as num;
    final movieId  = movie['id'] as int?;

    return GestureDetector(
      onTap: () {
        if (movieId != null) {
          Navigator.pushNamed(context, RoutesName.movieDetails, arguments: movieId);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: 150.h,
                  fit: BoxFit.cover,
                  placeholder: (ctx, url) => _buildShimmer(150.h, double.infinity),
                  errorWidget: (ctx, url, err) => Container(
                    height: 150.h,
                    color: Colors.grey[900],
                    child: const Icon(Icons.movie_outlined, color: Colors.white30),
                  ),
                ),
              ),
              Positioned(
                top: 6.h,
                left: 6.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star_rounded, color: Colors.amber, size: 10.sp),
                      Gap(2.w),
                      Text(
                        rating > 0 ? rating.toStringAsFixed(1) : '—',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Gap(8.h),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: AlignedGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        mainAxisSpacing: 20.h,
        crossAxisSpacing: 12.w,
        itemCount: 12,
        itemBuilder: (_, __) => _buildShimmer(150.h, double.infinity),
      ),
    );
  }

  Widget _buildEmpty() {
    return Padding(
      padding: EdgeInsets.all(40.r),
      child: Column(
        children: [
          Icon(Icons.movie_outlined, color: Colors.grey.withOpacity(0.3), size: 80.sp),
          Gap(16.h),
          Text(
            "Hozircha kino yo'q",
            style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
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
