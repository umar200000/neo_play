import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/router/app_routers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      path: "assets/easy_localization/json_language",
      supportedLocales: const [Locale("uz"), Locale("en"), Locale("ru")],
      startLocale: const Locale("uz"),
      useOnlyLangCode: true,
      fallbackLocale: const Locale("uz"),
      child: const NeoPlay(),
    ),
  );
}

class NeoPlay extends StatelessWidget {
  const NeoPlay({super.key});

  @override
  Widget build(BuildContext context) {
    // AnnotatedRegion butun ilova bo'ylab status bar ikonkalari oq bo'lishini ta'minlaydi
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // Android: oq ikonka
        statusBarBrightness: Brightness.dark, // iOS: oq ikonka
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark, // Ilovani qorong'u rejimga o'tkazish
            appBarTheme: const AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle.light,
            ),
          ),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child!,
            );
          },
          onGenerateRoute: (settings) {
            return CupertinoPageRoute(
              builder: (context) => appRoutes(settings),
              settings: settings,
            );
          },
        ),
      ),
    );
  }
}
