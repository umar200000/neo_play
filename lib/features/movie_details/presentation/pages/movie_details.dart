import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:neo_play/config/theme/colors/all_colors.dart';
import 'package:neo_play/core/router/routes_name.dart';
import 'package:neo_play/core/service/api/movie_api.dart';
import 'package:neo_play/core/widgets/top_notification.dart';
import 'package:shimmer/shimmer.dart';

class MovieDetails extends StatefulWidget {
  const MovieDetails({super.key});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  bool _isExpanded = false;
  int  _userRating = 0;
  final TextEditingController _reviewController = TextEditingController();
  bool _submittingReview = false;

  bool   _loading  = true;
  String? _error;
  Map<String, dynamic>? _movie;
  bool _isFavorite      = false;
  bool _togglingFavorite = false;
  int? _movieId;

  static const _tabs = ["Film haqida", "Ijodkorlar", "Fikrlar"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    final id = args is int ? args : null;
    if (id != null && id != _movieId) {
      _movieId = id;
      _loadMovie(id);
    }
  }

  Future<void> _loadMovie(int id) async {
    setState(() { _loading = true; _error = null; });
    try {
      final data  = await MovieApi.getMovieById(id);
      if (!mounted) return;
      final movie = data['movie'] as Map<String, dynamic>;
      setState(() {
        _movie      = movie;
        _isFavorite = movie['is_favorite'] as bool? ?? false;
        _loading    = false;
      });
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = e.toString(); });
    }
  }

  Future<void> _toggleFavorite() async {
    if (_movieId == null || _togglingFavorite) return;
    setState(() => _togglingFavorite = true);
    try {
      final data   = await MovieApi.toggleFavorite(_movieId!);
      if (!mounted) return;
      final nowFav = data['is_favorite'] as bool? ?? !_isFavorite;
      setState(() { _isFavorite = nowFav; _togglingFavorite = false; });
      showTopNotification(
        context,
        message:   nowFav ? "Saqlanganlar ro'yxatiga qo'shildi" : "Ro'yxatdan o'chirildi",
        isSuccess: nowFav,
        icon:      nowFav ? Icons.bookmark_added_rounded : Icons.bookmark_remove_rounded,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _togglingFavorite = false);
      showTopNotification(
        context,
        message: e.toString().contains('401') || e.toString().contains('Token')
            ? 'Saqlash uchun tizimga kiring'
            : 'Xatolik yuz berdi',
        isSuccess: false,
      );
    }
  }

  Future<void> _submitReview() async {
    if (_movieId == null || _userRating == 0) return;
    setState(() => _submittingReview = true);
    try {
      await MovieApi.submitReview(_movieId!, _userRating, _reviewController.text.trim());
      if (mounted) {
        _reviewController.clear();
        setState(() => _userRating = 0);
        showTopNotification(context, message: 'Fikringiz yuborildi!', isSuccess: true);
      }
    } catch (_) {}
    if (mounted) setState(() => _submittingReview = false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return _buildLoadingScaffold();
    if (_error != null || _movie == null) return _buildErrorScaffold();
    return _buildContent();
  }

  // ── Loading ───────────────────────────────────────────────────────────────

  Widget _buildLoadingScaffold() {
    return Scaffold(
      backgroundColor: AllColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildShimmer(520.h, double.infinity),
            Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                children: [
                  _buildShimmer(28.h, 240.w),
                  Gap(10.h),
                  _buildShimmer(14.h, 180.w),
                  Gap(20.h),
                  _buildShimmer(52.h, double.infinity),
                  Gap(12.h),
                  Row(
                    children: [
                      _buildShimmer(32.h, 80.w),
                      Gap(8.w),
                      _buildShimmer(32.h, 60.w),
                      Gap(8.w),
                      _buildShimmer(32.h, 70.w),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Error ─────────────────────────────────────────────────────────────────

  Widget _buildErrorScaffold() {
    return Scaffold(
      backgroundColor: AllColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.w, height: 80.w,
              decoration: BoxDecoration(
                color: AllColors.cardColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.error_outline_rounded,
                  color: AllColors.greyText, size: 36.sp),
            ),
            Gap(20.h),
            Text('Xatolik yuz berdi',
                style: TextStyle(color: AllColors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
            Gap(8.h),
            Text('Internet aloqasini tekshiring',
                style: TextStyle(color: AllColors.greyText, fontSize: 13.sp)),
            Gap(28.h),
            GestureDetector(
              onTap: () { if (_movieId != null) _loadMovie(_movieId!); },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: AllColors.primaryColor,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Text('Qayta urinish',
                    style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
              ),
            ),
            Gap(12.h),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Text('Orqaga',
                  style: TextStyle(color: AllColors.greyText, fontSize: 14.sp)),
            ),
          ],
        ),
      ),
    );
  }

  // ── Main content ──────────────────────────────────────────────────────────

  Widget _buildContent() {
    final movie         = _movie!;
    final title         = movie['title_uz'] as String? ?? '';
    final posterUrl     = MovieApi.fullImageUrl(movie['poster_url'] as String?);
    final backdropUrl   = MovieApi.fullImageUrl(movie['backdrop_url'] as String?);
    final videoUrl      = movie['video_url'] as String? ?? '';
    final description   = movie['description_uz'] as String? ?? '';
    final year          = movie['release_year'] as int?;
    final ageRating     = movie['age_rating'] as String? ?? '';
    final neoRating     = (movie['neoplay_rating'] ?? 0.0) as num;
    final imdbRating    = (movie['imdb_rating'] ?? 0.0) as num;
    final duration      = (movie['duration_minutes'] ?? 0) as int;
    final totalSeasons  = (movie['total_seasons'] ?? 0) as int;
    final totalEpisodes = (movie['total_episodes'] ?? 0) as int;
    final genres        = (movie['genres']    as List? ?? []).cast<Map<String, dynamic>>();
    final countries     = (movie['countries'] as List? ?? []).cast<Map<String, dynamic>>();
    final actors        = (movie['actors']    as List? ?? []).cast<Map<String, dynamic>>();
    final directors     = (movie['directors'] as List? ?? []).cast<Map<String, dynamic>>();
    final similar       = (movie['similar']   as List? ?? []).cast<Map<String, dynamic>>();
    final categorySlug  = movie['category_slug'] as String? ?? '';
    final isSeries      = categorySlug == 'series';

    String durationText = '';
    if (isSeries && totalSeasons > 0) {
      durationText = '$totalSeasons mavsum · $totalEpisodes qism';
    } else if (duration > 0) {
      final h = duration ~/ 60;
      final m = duration % 60;
      durationText = h > 0 ? '${h}s ${m}d.' : '${m}d.';
    }

    return Scaffold(
      backgroundColor: AllColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero
            _buildHeroSection(
              title:       title,
              backdropUrl: backdropUrl,
              posterUrl:   posterUrl,
            ),
            // ── Body
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meta info row
                  _buildMetaRow(
                    rating:     neoRating,
                    year:       year,
                    duration:   durationText,
                    ageRating:  ageRating,
                    genres:     genres,
                  ),
                  Gap(16.h),
                  // Action buttons
                  _buildActionButtons(videoUrl: videoUrl, title: title),
                  Gap(20.h),
                  // Tabs
                  _buildTabBar(),
                ],
              ),
            ),
            // ── Tab content (no horizontal padding — each tab handles its own)
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
              child: _buildTabContent(
                description:  description,
                year:         year,
                countries:    countries,
                genres:       genres,
                ageRating:    ageRating,
                durationText: durationText,
                neoRating:    neoRating,
                imdbRating:   imdbRating,
                actors:       actors,
                directors:    directors,
              ),
            ),
            if (similar.isNotEmpty) ...[
              Gap(20.h),
              _buildSimilarSection(similar),
            ],
            Gap(60.h),
          ],
        ),
      ),
    );
  }

  // ── Hero ──────────────────────────────────────────────────────────────────

  Widget _buildHeroSection({
    required String title,
    required String backdropUrl,
    required String posterUrl,
  }) {
    final imageUrl = backdropUrl.isNotEmpty ? backdropUrl : posterUrl;
    return Stack(
      children: [
        // Backdrop image
        SizedBox(
          height: 500.h,
          width: double.infinity,
          child: imageUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: AllColors.cardColor),
                  errorWidget: (_, __, ___) => Container(
                    color: AllColors.cardColor,
                    child: Icon(Icons.movie_outlined, color: AllColors.greyText, size: 80.sp),
                  ),
                )
              : Container(
                  color: AllColors.cardColor,
                  child: Icon(Icons.movie_outlined, color: AllColors.greyText, size: 80.sp),
                ),
        ),
        // Top-to-bottom gradient overlay
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.35, 0.7, 1.0],
                colors: [
                  Colors.black.withOpacity(0.55),
                  Colors.transparent,
                  AllColors.background.withOpacity(0.6),
                  AllColors.background,
                ],
              ),
            ),
          ),
        ),
        // Top navigation bar
        Positioned(
          top: 0, left: 0, right: 0,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 42.h, height: 42.h,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.15)),
                      ),
                      child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20.sp),
                    ),
                  ),
                  const Spacer(),
                  // Favorite button
                  GestureDetector(
                    onTap: _toggleFavorite,
                    child: Container(
                      width: 42.h, height: 42.h,
                      decoration: BoxDecoration(
                        color: _isFavorite
                            ? AllColors.primaryColor.withOpacity(0.9)
                            : Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _isFavorite
                              ? AllColors.primaryColor
                              : Colors.white.withOpacity(0.15),
                        ),
                      ),
                      child: _togglingFavorite
                          ? Padding(
                              padding: EdgeInsets.all(11.r),
                              child: const CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : Icon(
                              _isFavorite
                                  ? Icons.bookmark_rounded
                                  : Icons.bookmark_outline_rounded,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Title at bottom of hero
        Positioned(
          bottom: 20.h, left: 16.w, right: 16.w,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 26.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
              height: 1.2,
              shadows: const [
                Shadow(color: Colors.black, blurRadius: 12, offset: Offset(0, 2)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Meta row ──────────────────────────────────────────────────────────────

  Widget _buildMetaRow({
    required num rating,
    int? year,
    required String duration,
    required String ageRating,
    required List<Map<String, dynamic>> genres,
  }) {
    final List<Widget> chips = [];

    if (rating > 0) {
      chips.add(_buildRatingChip(rating.toStringAsFixed(1)));
    }
    if (year != null) {
      chips.add(_buildMetaChip('$year'));
    }
    if (duration.isNotEmpty) {
      chips.add(_buildMetaChip(duration, icon: Icons.schedule_rounded));
    }
    for (final g in genres.take(2)) {
      chips.add(_buildMetaChip(g['name_uz'] as String? ?? ''));
    }
    if (ageRating.isNotEmpty) {
      chips.add(_buildMetaChip(ageRating));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: chips
            .expand((c) => [c, Gap(8.w)])
            .toList()
            ..removeLast(),
      ),
    );
  }

  Widget _buildRatingChip(String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AllColors.yellow.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AllColors.yellow.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, color: AllColors.yellow, size: 12.sp),
          Gap(4.w),
          Text(value,
              style: TextStyle(
                  color: AllColors.yellow,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildMetaChip(String text, {IconData? icon}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AllColors.surfaceLight,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: AllColors.greyText, size: 11.sp),
            Gap(4.w),
          ],
          Text(text,
              style: TextStyle(color: AllColors.greyText, fontSize: 12.sp)),
        ],
      ),
    );
  }

  // ── Action buttons ────────────────────────────────────────────────────────

  Widget _buildActionButtons({required String videoUrl, required String title}) {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => Navigator.pushNamed(
              context,
              RoutesName.videoPlayerPage,
              arguments: {'videoUrl': videoUrl, 'title': title, 'movieId': _movieId},
            ),
            child: Container(
              height: 52.h,
              decoration: BoxDecoration(
                color: AllColors.primaryColor,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: AllColors.primaryColor.withOpacity(0.45),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow_rounded, color: Colors.white, size: 26.sp),
                  Gap(6.w),
                  Text(
                    'Tomosha qilish',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        Gap(10.w),
        Container(
          height: 52.h, width: 52.h,
          decoration: BoxDecoration(
            color: AllColors.cardHigh,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Icon(Icons.share_outlined, color: AllColors.greyText, size: 20.sp),
        ),
      ],
    );
  }

  // ── Tab bar ───────────────────────────────────────────────────────────────

  Widget _buildTabBar() {
    return Container(
      height: 44.h,
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
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: AllColors.white,
        unselectedLabelColor: AllColors.greyText,
        labelStyle: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700),
        unselectedLabelStyle: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400),
        tabs: _tabs.map((t) => Tab(text: t)).toList(),
      ),
    );
  }

  Widget _buildTabContent({
    required String description,
    int? year,
    required List<Map<String, dynamic>> countries,
    required List<Map<String, dynamic>> genres,
    required String ageRating,
    required String durationText,
    required num neoRating,
    required num imdbRating,
    required List<Map<String, dynamic>> actors,
    required List<Map<String, dynamic>> directors,
  }) {
    final tab = _tabController.index;
    if (tab == 0) {
      return _buildAboutTab(
        description:  description,
        year:         year,
        countries:    countries,
        genres:       genres,
        ageRating:    ageRating,
        durationText: durationText,
        neoRating:    neoRating,
        imdbRating:   imdbRating,
      );
    } else if (tab == 1) {
      return _buildCreatorsTab(actors: actors, directors: directors);
    } else {
      return _buildReviewsTab();
    }
  }

  // ── Tab 0: About ──────────────────────────────────────────────────────────

  Widget _buildAboutTab({
    required String description,
    int? year,
    required List<Map<String, dynamic>> countries,
    required List<Map<String, dynamic>> genres,
    required String ageRating,
    required String durationText,
    required num neoRating,
    required num imdbRating,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AllColors.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (description.isNotEmpty) ...[
            Text(
              description,
              maxLines: _isExpanded ? null : 3,
              overflow: _isExpanded ? null : TextOverflow.ellipsis,
              style: TextStyle(
                color: AllColors.greyText,
                fontSize: 13.sp,
                height: 1.6,
              ),
            ),
            Gap(10.h),
            GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Text(
                _isExpanded ? "Kamroq ko'rish" : "Ko'proq ko'rish",
                style: TextStyle(
                  color: AllColors.primaryColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Gap(16.h),
          ],
          // Info grid
          _buildInfoGrid(
            year: year,
            countries: countries,
            genres: genres,
            ageRating: ageRating,
            durationText: durationText,
            neoRating: neoRating,
            imdbRating: imdbRating,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGrid({
    int? year,
    required List<Map<String, dynamic>> countries,
    required List<Map<String, dynamic>> genres,
    required String ageRating,
    required String durationText,
    required num neoRating,
    required num imdbRating,
  }) {
    final rows = <_InfoRow>[];

    if (year != null)              rows.add(_InfoRow("Yil", '$year'));
    if (durationText.isNotEmpty)   rows.add(_InfoRow("Davomiyligi", durationText));
    if (ageRating.isNotEmpty)      rows.add(_InfoRow("Yosh chegarasi", ageRating));
    if (countries.isNotEmpty)      rows.add(_InfoRow("Davlati",
        countries.map((c) => c['country'] as String? ?? '').join(', ')));
    if (genres.isNotEmpty)         rows.add(_InfoRow("Janr",
        genres.map((g) => g['name_uz'] as String? ?? '').join(', ')));
    if (neoRating > 0)             rows.add(_InfoRow("NeoPlay reyting",
        neoRating.toStringAsFixed(1)));
    if (imdbRating > 0)            rows.add(_InfoRow("IMDb reyting",
        imdbRating.toStringAsFixed(1)));

    if (rows.isEmpty) return const SizedBox.shrink();

    return Column(
      children: rows.asMap().entries.map((e) {
        final isLast = e.key == rows.length - 1;
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 130.w,
                    child: Text(
                      e.value.label,
                      style: TextStyle(color: AllColors.greyText, fontSize: 12.sp),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      e.value.value,
                      style: TextStyle(
                        color: AllColors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (!isLast)
              Divider(height: 1, color: Colors.white.withOpacity(0.05)),
          ],
        );
      }).toList(),
    );
  }

  // ── Tab 1: Creators ───────────────────────────────────────────────────────

  Widget _buildCreatorsTab({
    required List<Map<String, dynamic>> actors,
    required List<Map<String, dynamic>> directors,
  }) {
    if (actors.isEmpty && directors.isEmpty) {
      return Container(
        padding: EdgeInsets.all(32.r),
        decoration: BoxDecoration(
          color: AllColors.cardColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Center(
          child: Text("Ma'lumot mavjud emas",
              style: TextStyle(color: AllColors.greyText, fontSize: 14.sp)),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AllColors.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (directors.isNotEmpty) ...[
            _buildPeopleSection("Rejissorlar", directors),
            Gap(20.h),
          ],
          if (actors.isNotEmpty)
            _buildPeopleSection("Aktyorlar", actors),
        ],
      ),
    );
  }

  Widget _buildPeopleSection(String title, List<Map<String, dynamic>> people) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                color: AllColors.white, fontSize: 14.sp, fontWeight: FontWeight.w700)),
        Gap(14.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: people.map((p) {
              final name     = p['name'] as String? ?? '';
              final photoUrl = MovieApi.fullImageUrl(p['photo_url'] as String?);
              return Container(
                width: 72.w,
                margin: EdgeInsets.only(right: 14.w),
                child: Column(
                  children: [
                    Container(
                      width: 58.w, height: 58.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white.withOpacity(0.1), width: 1.5),
                      ),
                      child: ClipOval(
                        child: photoUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: photoUrl,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => Container(color: AllColors.cardHigh),
                                errorWidget: (_, __, ___) => _buildPersonPlaceholder(),
                              )
                            : _buildPersonPlaceholder(),
                      ),
                    ),
                    Gap(8.h),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: AllColors.greyText, fontSize: 10.sp, height: 1.3),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonPlaceholder() {
    return Container(
      color: AllColors.cardHigh,
      child: Icon(Icons.person_rounded,
          color: AllColors.greyText.withOpacity(0.4), size: 28.sp),
    );
  }

  // ── Tab 2: Reviews ────────────────────────────────────────────────────────

  Widget _buildReviewsTab() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AllColors.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Filmga bahoyingiz",
            style: TextStyle(
                color: AllColors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          Gap(14.h),
          // Star rating
          Row(
            children: List.generate(5, (i) => GestureDetector(
              onTap: () => setState(() => _userRating = i + 1),
              child: Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: Icon(
                  i < _userRating ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: i < _userRating ? AllColors.yellow : AllColors.surfaceLight,
                  size: 34.sp,
                ),
              ),
            )),
          ),
          Gap(16.h),
          // Review text field
          Container(
            decoration: BoxDecoration(
              color: AllColors.cardHigh,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: TextField(
              controller: _reviewController,
              maxLines: 3,
              style: TextStyle(color: AllColors.white, fontSize: 13.sp),
              cursorColor: AllColors.primaryColor,
              decoration: InputDecoration(
                hintText: 'Fikringizni yozing...',
                hintStyle: TextStyle(color: AllColors.textMuted, fontSize: 13.sp),
                contentPadding: EdgeInsets.all(14.r),
                border: InputBorder.none,
              ),
            ),
          ),
          Gap(16.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: _submittingReview || _userRating == 0 ? null : _submitReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: AllColors.primaryColor,
                disabledBackgroundColor: AllColors.surfaceLight,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r)),
              ),
              child: _submittingReview
                  ? SizedBox(
                      width: 20.r, height: 20.r,
                      child: const CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : Text('Fikrimni yuborish',
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Similar ───────────────────────────────────────────────────────────────

  Widget _buildSimilarSection(List<Map<String, dynamic>> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Container(
                width: 3.w, height: 18.h,
                decoration: BoxDecoration(
                  color: AllColors.primaryColor,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Gap(8.w),
              Text(
                "O'xshash kinolar",
                style: TextStyle(
                    color: AllColors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Gap(14.h),
        SizedBox(
          height: 215.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: movies.length,
            separatorBuilder: (_, __) => Gap(12.w),
            itemBuilder: (ctx, i) {
              final m        = movies[i];
              final imageUrl = MovieApi.fullImageUrl(m['poster_url'] as String?);
              final movieId  = m['id'] as int?;
              final rating   = (m['neoplay_rating'] ?? 0.0) as num;
              final title    = m['title_uz'] as String? ?? '';

              return GestureDetector(
                onTap: () {
                  if (movieId != null) {
                    Navigator.pushReplacementNamed(
                        context, RoutesName.movieDetails, arguments: movieId);
                  }
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
                            width: 130.w, height: 180.h,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => _buildShimmer(180.h, 130.w),
                            errorWidget: (_, __, ___) => Container(
                              width: 130.w, height: 180.h,
                              color: AllColors.cardHigh,
                              child: Icon(Icons.movie_outlined,
                                  color: AllColors.greyText, size: 28.sp),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 6.h, left: 6.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(6.r),
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
                      ],
                    ),
                    Gap(7.h),
                    SizedBox(
                      width: 130.w,
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: AllColors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _buildShimmer(double height, double width) {
    return Shimmer.fromColors(
      baseColor: AllColors.cardHigh,
      highlightColor: AllColors.surfaceLight,
      child: Container(
        height: height, width: width,
        decoration: BoxDecoration(
          color: AllColors.cardHigh,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}

class _InfoRow {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);
}
