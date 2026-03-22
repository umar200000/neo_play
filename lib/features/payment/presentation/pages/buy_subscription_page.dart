import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:neo_play/config/theme/colors/all_colors.dart';
import 'package:shimmer/shimmer.dart';

class BuySubscriptionPage extends StatefulWidget {
  const BuySubscriptionPage({super.key});

  @override
  State<BuySubscriptionPage> createState() => _BuySubscriptionPageState();
}

class _BuySubscriptionPageState extends State<BuySubscriptionPage> {
  bool _isLoading = true;

  final List<Map<String, dynamic>> _subscriptions = [
    {
      'title': 'PREMIUM 1 OY',
      'price': '15 000 UZS',
      'description':
          '30 kun «PREMIUM» tarifiga kiruvchi kontentlarni tomosha qilasiz!',
      'movies': [
        'https://picsum.photos/200/300?random=1',
        'https://picsum.photos/200/300?random=2',
        'https://picsum.photos/200/300?random=3',
        'https://picsum.photos/200/300?random=4',
        'https://picsum.photos/200/300?random=5',
      ],
      'stats': [
        {'icon': Icons.movie_outlined, 'label': '10k+ kino'},
        {'icon': Icons.child_care_outlined, 'label': '1.5k+ mult'},
        {'icon': Icons.history_outlined, 'label': '2k+ retro'},
        {'icon': Icons.tv_outlined, 'label': '1k+ serial'},
      ],
    },
    {
      'title': 'PREMIUM 3 OY',
      'price': '42 000 UZS',
      'description':
          '90 kun «PREMIUM» tarifiga kiruvchi kontentlarni tomosha qilasiz!',
      'movies': [
        'https://picsum.photos/200/300?random=6',
        'https://picsum.photos/200/300?random=7',
        'https://picsum.photos/200/300?random=8',
        'https://picsum.photos/200/300?random=9',
        'https://picsum.photos/200/300?random=10',
      ],
      'stats': [
        {'icon': Icons.movie_outlined, 'label': '10k+ kino'},
        {'icon': Icons.child_care_outlined, 'label': '1.5k+ mult'},
        {'icon': Icons.history_outlined, 'label': '2k+ retro'},
        {'icon': Icons.tv_outlined, 'label': '1k+ serial'},
      ],
    },
    {
      'title': 'PREMIUM 1 YIL',
      'price': '150 000 UZS',
      'description':
          '365 kun «PREMIUM» tarifiga kiruvchi kontentlarni tomosha qilasiz!',
      'movies': [
        'https://picsum.photos/200/300?random=11',
        'https://picsum.photos/200/300?random=12',
        'https://picsum.photos/200/300?random=13',
        'https://picsum.photos/200/300?random=14',
        'https://picsum.photos/200/300?random=15',
      ],
      'stats': [
        {'icon': Icons.movie_outlined, 'label': '10k+ kino'},
        {'icon': Icons.child_care_outlined, 'label': '1.5k+ mult'},
        {'icon': Icons.history_outlined, 'label': '2k+ retro'},
        {'icon': Icons.tv_outlined, 'label': '1k+ serial'},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Tarif sotib olish",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: _isLoading ? _buildShimmerEffect() : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      itemCount: _subscriptions.length,
      separatorBuilder: (context, index) => Gap(16.h),
      itemBuilder: (context, index) {
        final sub = _subscriptions[index];
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xff121212),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(12.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Auto Scrolling Movies Row
                    SizedBox(
                      height: 90.h,
                      child: _AutoScrollingMovies(movies: sub['movies']),
                    ),
                    Gap(12.h),
                    // Badges Row
                    Row(
                      children: [
                        _buildBadge(sub['title'], Colors.white10, Colors.white),
                        Gap(8.w),
                        _buildBadge(
                          "Narxi: ${sub['price']}",
                          Colors.white10,
                          AllColors.yellow,
                        ),
                      ],
                    ),
                    Gap(10.h),
                    // Details Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              sub['description'],
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 11.sp,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ),
                        Gap(8.w),
                        Expanded(flex: 2, child: _buildStatsGrid(sub['stats'])),
                      ],
                    ),
                  ],
                ),
              ),
              // Bottom Action
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: AllColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        bottomRight: Radius.circular(16.r),
                      ),
                    ),
                    child: Text(
                      "Sotib olish",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBadge(String text, Color bg, Color textColor) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8.r),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(List stats) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 4.h,
        crossAxisSpacing: 4.w,
        childAspectRatio: 1.8,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(stats[index]['icon'], color: Colors.white, size: 14.sp),
              Text(
                stats[index]['label'],
                style: TextStyle(color: Colors.white, fontSize: 8.sp),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[800]!,
      child: ListView.separated(
        padding: EdgeInsets.all(16.r),
        itemCount: 3,
        separatorBuilder: (context, index) => Gap(16.h),
        itemBuilder: (context, index) => Container(
          height: 220.h,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
    );
  }
}

class _AutoScrollingMovies extends StatefulWidget {
  final List<String> movies;
  const _AutoScrollingMovies({required this.movies});

  @override
  State<_AutoScrollingMovies> createState() => _AutoScrollingMoviesState();
}

class _AutoScrollingMoviesState extends State<_AutoScrollingMovies> {
  late ScrollController _scrollController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  void _startScrolling() {
    if (_scrollController.hasClients) {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      _scrollController
          .animateTo(
            maxScrollExtent,
            duration: Duration(seconds: widget.movies.length * 4),
            curve: Curves.linear,
          )
          .then((_) {
            if (mounted) {
              _scrollController.jumpTo(0);
              _startScrolling();
            }
          });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final doubleMovies = [...widget.movies, ...widget.movies, ...widget.movies];
    return ListView.separated(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: doubleMovies.length,
      separatorBuilder: (context, index) => Gap(8.w),
      itemBuilder: (context, index) => ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: CachedNetworkImage(
          imageUrl: doubleMovies[index],
          width: 65.w,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(color: Colors.white10),
        ),
      ),
    );
  }
}
