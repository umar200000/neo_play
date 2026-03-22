import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:neo_play/config/theme/colors/all_colors.dart';
import 'package:neo_play/core/router/routes_name.dart';
import 'package:shimmer/shimmer.dart';

class MainPage extends StatefulWidget {
  final VoidCallback? onSearchTap;
  const MainPage({super.key, this.onSearchTap});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentCarouselIndex = 0;

  final List<String> categories = [
    "Asosiy",
    "Filmlar",
    "Seriallar",
    "Multfilmlar",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateToDetails() {
    Navigator.pushNamed(context, RoutesName.movieDetails);
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                _buildHeroCarousel(),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.6, 1.0],
                      colors: [
                        Colors.black.withOpacity(0.9),
                        Colors.black.withOpacity(0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Row(
                            children: [
                              Gap(8.w),
                              Text(
                                'Neo',
                                style: TextStyle(
                                  color: AllColors.primaryColor,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Play',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: _navigateToNotification,
                                icon: Icon(
                                  Icons.notifications_none_rounded,
                                  color: Colors.white,
                                  size: 28.sp,
                                ),
                              ),
                              IconButton(
                                onPressed: widget.onSearchTap,
                                icon: Icon(
                                  Icons.search_rounded,
                                  color: Colors.white,
                                  size: 28.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                          ),
                          child: TabBar(
                            controller: _tabController,
                            isScrollable: false,
                            indicatorColor: AllColors.primaryColor,
                            indicatorWeight: 2.5,
                            indicatorSize: TabBarIndicatorSize.label,
                            dividerColor: Colors.transparent,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.white.withOpacity(0.7),
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            labelPadding: EdgeInsets.zero,
                            tabs: categories
                                .map((e) => Tab(text: e, height: 35.h))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Gap(16.h),
            _buildSection(
              title: "Avval ko'rilganlar",
              child: _buildHorizontalList(isLarge: true),
            ),
            Gap(4.h),
            _buildSection(
              title: "Yangi filmlar",
              child: _buildHorizontalList(isLarge: false),
            ),
            Gap(4.h),
            _buildSection(
              title: "Siz uchun maxsus",
              child: _buildHorizontalList(isLarge: false),
            ),
            Gap(100.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCarousel() {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: 5,
          options: CarouselOptions(
            height: 420.h,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _currentCarouselIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            return GestureDetector(
              onTap: _navigateToDetails,
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl:
                        "https://picsum.photos/seed/${index + 10}/800/1200",
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) =>
                        _buildShimmer(420.h, double.infinity),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AllColors.background.withOpacity(0.5),
                          AllColors.background,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10.h,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Text(
                          "KOPERATSIYA",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                        Text(
                          "MAXFIY HAMKORLIK",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Gap(12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildHeroButton(
                              icon: Icons.play_arrow_rounded,
                              text: "Tomosha qilish",
                              color: AllColors.primaryColor,
                              textColor: Colors.white,
                              onTap: _navigateToDetails,
                            ),
                            Gap(12.w),
                            _buildHeroIconButton(Icons.bookmark_border_rounded),
                            Gap(12.w),
                            _buildHeroIconButton(Icons.volume_off),
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
        Gap(8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return Container(
              width: 8.w,
              height: 4.h,
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: _currentCarouselIndex == index
                    ? Colors.white
                    : Colors.grey.withOpacity(0.5),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildHeroButton({
    required IconData icon,
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 20.sp),
            Gap(6.w),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroIconButton(IconData icon) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: const Color(0xff3C3E42).withOpacity(0.5),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Icon(icon, color: Colors.white, size: 18.sp),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: AllColors.cardColor,
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => _navigateToMovieList(title),
                  behavior: HitTestBehavior.translucent,
                  child: SizedBox(
                    width: 40,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 14.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Gap(12.h),
          child,
        ],
      ),
    );
  }

  Widget _buildHorizontalList({required bool isLarge}) {
    return SizedBox(
      height: isLarge ? 170.h : 230.h,
      child: AlignedGridView.count(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        crossAxisCount: 1,
        mainAxisSpacing: 12.w,
        itemCount: 10,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: _navigateToDetails,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://picsum.photos/seed/${index + (isLarge ? 20 : 30)}/400/600",
                        width: isLarge ? 210.w : 130.w,
                        height: isLarge ? 130.h : 180.h,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => _buildShimmer(
                          isLarge ? 130.h : 180.h,
                          isLarge ? 210.w : 130.w,
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: isLarge ? 210.w : 130.w,
                          height: isLarge ? 130.h : 180.h,
                          color: Colors.grey[900],
                          child: const Icon(Icons.error, color: Colors.white),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6.h,
                      left: 6.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 1.h,
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
                              size: 10.sp,
                            ),
                            Gap(2.w),
                            Text(
                              "4.6",
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
                    if (isLarge)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 3.h,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(12.r),
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: index % 3 == 0 ? 0.4 : 0.8,
                            child: Container(color: AllColors.primaryColor),
                          ),
                        ),
                      ),
                  ],
                ),
                Gap(6.h),
                SizedBox(
                  width: isLarge ? 210.w : 130.w,
                  child: Text(
                    index % 2 == 0 ? "Qashqirlar makoni: Vatan" : "38-parallel",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 11.sp),
                  ),
                ),
              ],
            ),
          );
        },
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
