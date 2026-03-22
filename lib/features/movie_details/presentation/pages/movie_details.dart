import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:neo_play/config/theme/colors/all_colors.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/router/routes_name.dart';

class MovieDetails extends StatefulWidget {
  const MovieDetails({super.key});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  int _selectedTab = 0;
  bool _isExpanded = false;
  int _userRating = 0;
  final List<String> _tabs = [
    "Film haqida",
    "Ijodkorlar va akt...",
    "Fikrlar va baholar",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(10.h),
                  _buildActionButtons(),
                  Gap(20.h),
                  _buildMovieInfoTags(),
                  Gap(20.h),
                  _buildTabsContainer(),
                  Gap(20.h),
                  _buildTabContent(),
                  Gap(24.h),
                ],
              ),
            ),
            _buildSection(
              title: "O'xshash filmlar",
              child: _buildMovieHorizontalList(),
            ),
            Gap(4.h),
            _buildSection(
              title: "Siz uchun maxsus",
              child: _buildMovieHorizontalList(),
            ),
            Gap(50.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10.h,
        left: 16.w,
        right: 16.w,
        bottom: 10.h,
      ),
      color: Colors.black.withOpacity(0.3),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.chevron_left, color: Colors.white, size: 30.sp),
          ),
          Gap(16.w),
          Expanded(
            child: Text(
              "Koperatsiya: Maxfiy hamkorlik filmi",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CachedNetworkImage(
          imageUrl: "https://picsum.photos/seed/movie_poster/800/1200",
          height: 480.h,
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildShimmer(480.h, double.infinity),
        ),
        Container(
          height: 250.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                AllColors.background,
                AllColors.background.withOpacity(0.8),
                Colors.transparent,
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 10.h,
          child: Column(
            children: [
              Text(
                "KOPERATSIYA",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              Text(
                "MAXFIY HAMKORLIK",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        Positioned(top: 0, left: 0, right: 0, child: _buildTopBar()),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: GestureDetector(
            behavior: .translucent,
            onTap: () {
              Navigator.pushNamed(context, RoutesName.videoPlayerPage);
            },
            child: Container(
              height: 46.h,
              decoration: BoxDecoration(
                color: AllColors.primaryColor,
                borderRadius: BorderRadius.circular(23.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 28.sp,
                  ),
                  Gap(4.w),
                  Text(
                    "Tomosha qilish",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Gap(8.w),
        Expanded(
          flex: 3,
          child: Container(
            height: 46.h,
            decoration: BoxDecoration(
              color: const Color(0xff1A1B1E),
              borderRadius: BorderRadius.circular(23.r),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_outline, color: Colors.white, size: 20.sp),
                Gap(8.w),
                Text(
                  "Yoqdi",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        Gap(8.w),
        Container(
          height: 46.h,
          width: 46.h,
          decoration: BoxDecoration(
            color: const Color(0xff1A1B1E),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Icon(Icons.volume_off, color: Colors.white, size: 20.sp),
        ),
      ],
    );
  }

  Widget _buildMovieInfoTags() {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildInfoTagWithIcon("NeoPlay", "7,2"),
            Gap(8.w),
            _buildSimpleInfoTag("2018"),
            Gap(8.w),
            _buildSimpleInfoTag("Detektiv"),
            Gap(8.w),
            _buildSimpleInfoTag("16+"),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTagWithIcon(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xff1A1B1E),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: " $value",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleInfoTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xff1A1B1E),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12.sp),
      ),
    );
  }

  Widget _buildTabsContainer() {
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: const Color(0xff0F0F0F),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          bool isSelected = _selectedTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() {
                _selectedTab = index;
                _isExpanded = false; // Reset expansion when tab changes
              }),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xff1A1B1E)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Center(
                  child: Text(
                    _tabs[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : AllColors.greyText,
                      fontSize: 12.sp,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTabContent() {
    if (_selectedTab == 0) {
      return _buildFilmHaqida();
    } else if (_selectedTab == 1) {
      return _buildIjodkorlarContent();
    } else if (_selectedTab == 2) {
      return _buildFikrlarContent();
    }
    return Center(
      child: Text(
        _tabs[_selectedTab],
        style: TextStyle(color: Colors.white, fontSize: 16.sp),
      ),
    );
  }

  Widget _buildFilmHaqida() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xff0D0E10),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.r),
              child: CachedNetworkImage(
                imageUrl: "https://picsum.photos/seed/movie_inner/600/900",
                height: 320.h,
                width: 220.w,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildShimmer(320.h, 220.w),
              ),
            ),
          ),
          Gap(16.h),
          Text(
            "Koperatsiya: Maxfiy hamkorlik filmi",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Gap(12.h),
          Text(
            "Shimoliy Koreya chegara qo'shinlari polkovnigi Cha Gi Sung armiyaga kontrabanda qurollarini yetkazib berish bilan shug'ullangan, biroq kunlarning birida vaziyatdan unumli foydalanishg...",
            style: TextStyle(
              color: AllColors.greyText,
              fontSize: 13.sp,
              height: 1.4,
            ),
          ),
          Gap(16.h),
          _buildInfoLabel("Davlati:"),
          Gap(8.h),
          Row(
            children: [
              _buildSmallTag("Janubiy Koreya"),
              Gap(8.w),
              _buildSmallTag("Shimoliy Koreya"),
            ],
          ),
          if (_isExpanded) ...[
            Gap(16.h),
            _buildInfoLabel("Ishlab chiqilgan yili:"),
            Gap(8.h),
            Row(
              children: [
                _buildSmallTag("2018"),
                Gap(8.w),
                _buildSmallTag("2019"),
              ],
            ),
            Gap(16.h),
            _buildInfoLabel("Film janri:"),
            Gap(8.h),
            Row(
              children: [
                _buildSmallTag("Detektiv"),
                Gap(8.w),
                _buildSmallTag("Jangari"),
                Gap(8.w),
                _buildSmallTag("Drama"),
              ],
            ),
            Gap(16.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoLabel("Yosh chegarasi:"),
                      Gap(8.h),
                      _buildSmallTag("16+"),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoLabel("Davomiyligi:"),
                      Gap(8.h),
                      _buildSmallTag("2 s. 3 d."),
                    ],
                  ),
                ),
              ],
            ),
            Gap(16.h),
            _buildInfoLabel("Platformalarda quyidagicha baholangan:"),
            Gap(8.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildRatingChip("IMDb", "7,2"),
                  Gap(8.w),
                  _buildRatingChip("Кинопоиск", "7,2"),
                  Gap(8.w),
                  _buildRatingChip("NeoPlay", "7,2"),
                ],
              ),
            ),
          ],
          Gap(20.h),
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xff1A1B1E),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: Text(
                  _isExpanded ? "Kamroq" : "Batafsil o'qish",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIjodkorlarContent() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xff0D0E10),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPersonSection("Aktiyorlar", [
            _PersonModel("Hyeon Bin", "https://picsum.photos/seed/actor1/200"),
            _PersonModel(
              "Yoo Hae-j...",
              "https://picsum.photos/seed/actor2/200",
            ),
            _PersonModel(
              "Kim Joo-...",
              "https://picsum.photos/seed/actor3/200",
            ),
            _PersonModel("Kim Joo-...", null),
            _PersonModel("Kim Joo-...", null),
          ]),
          if (_isExpanded) ...[
            Gap(24.h),
            _buildPersonSection("Rejissorlar", [
              _PersonModel("Kim Joo-...", null),
              _PersonModel("Kim Joo-...", null),
            ]),
            Gap(24.h),
            _buildPersonSection("Mualliflar", [
              _PersonModel("Kim Joo-...", null),
              _PersonModel("Kim Joo-...", null),
            ]),
          ],
          Gap(24.h),
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xff1A1B1E),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: Text(
                  _isExpanded ? "Kamroq" : "Batafsil ko'rish",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFikrlarContent() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: const Color(0xff0D0E10),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Fikrlar va baholar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(16.h),
              _buildCommentItem(),
              Gap(12.h),
              _buildCommentItem(),
              Gap(20.h),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: const Color(0xff1A1B1E),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Center(
                    child: Text(
                      "Batafsil ko'rish",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Gap(20.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: const Color(0xff0D0E10),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Filmga bahoyingiz?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(12.h),
              Row(
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => setState(() => _userRating = index + 1),
                    child: Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: Icon(
                        index < _userRating
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: index < _userRating
                            ? Colors.orange
                            : Colors.white.withOpacity(0.3),
                        size: 32.sp,
                      ),
                    ),
                  );
                }),
              ),
              Gap(16.h),
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: const Color(0xff1A1B1E),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: TextField(
                  maxLines: 3,
                  style: TextStyle(color: Colors.white, fontSize: 13.sp),
                  decoration: InputDecoration(
                    hintText: "Fiklaringizni bildiring)",
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 13.sp,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              Gap(16.h),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: AllColors.primaryColor,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Center(
                    child: Text(
                      "Fikrimni yuborish",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommentItem() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xff1A1B1E),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < 4 ? Icons.star_rounded : Icons.star_outline_rounded,
                color: Colors.orange,
                size: 16.sp,
              );
            }),
          ),
          Gap(8.h),
          Text(
            "Film ssenariysi o'zgacha edi. Aktyorlar mahorat bilan rollarga hissiyot bilan yondashishgan, qisqa qilganda detektiv janridagi yaxshi filmlardan!",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12.sp,
              height: 1.5,
            ),
          ),
          Gap(8.h),
          Text(
            "Saidalixon Sobirov",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonSection(String title, List<_PersonModel> people) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Gap(16.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: people.map((person) => _buildPersonItem(person)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonItem(_PersonModel person) {
    return Container(
      width: 70.w,
      margin: EdgeInsets.only(right: 12.w),
      child: Column(
        children: [
          CircleAvatar(
            radius: 32.r,
            backgroundColor: const Color(0xff1A1B1E),
            backgroundImage: person.imageUrl != null
                ? CachedNetworkImageProvider(person.imageUrl!)
                : null,
            child: person.imageUrl == null
                ? Icon(
                    Icons.person,
                    color: Colors.white.withOpacity(0.2),
                    size: 30.sp,
                  )
                : null,
          ),
          Gap(8.h),
          Text(
            person.name,
            style: TextStyle(color: Colors.white, fontSize: 11.sp),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _navigateToMovieList(String title) {
    Navigator.pushNamed(context, RoutesName.movieList, arguments: title);
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
                  behavior: .translucent,
                  child: SizedBox(
                    width: 40,
                    child: Align(
                      alignment: .centerRight,
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

  Widget _buildMovieHorizontalList() {
    return SizedBox(
      height: 180.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 10,
        separatorBuilder: (context, index) => Gap(12.w),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, RoutesName.movieDetails);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: CachedNetworkImage(
                imageUrl: "https://picsum.photos/seed/${index + 50}/400/600",
                width: 130.w,
                height: 180.h,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildShimmer(180.h, 130.w),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildSmallTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xff1A1B1E),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        text,
        style: TextStyle(color: AllColors.greyText, fontSize: 12.sp),
      ),
    );
  }

  Widget _buildRatingChip(String platform, String score) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xff1A1B1E),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (platform == "IMDb")
            Image.network(
              "https://upload.wikimedia.org/wikipedia/commons/6/69/IMDB_Logo_2016.svg",
              height: 12.h,
              errorBuilder: (c, e, s) => Text(
                platform,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (platform != "IMDb")
            Text(
              platform,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          Gap(6.w),
          Text(
            score,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 11.sp,
            ),
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

class _PersonModel {
  final String name;
  final String? imageUrl;
  _PersonModel(this.name, this.imageUrl);
}
