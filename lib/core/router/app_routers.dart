import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neo_play/core/router/routes_name.dart';
import 'package:neo_play/features/about/presentation/pages/about_app_page.dart';
import 'package:neo_play/features/about/presentation/pages/support_page.dart';
import 'package:neo_play/features/auth_and_register/presentation/pages/auth_page.dart';
import 'package:neo_play/features/auth_and_register/presentation/pages/register_page.dart';
import 'package:neo_play/features/devices/presentation/pages/active_devices_page.dart';
import 'package:neo_play/features/home/presentation/pages/home_page.dart';
import 'package:neo_play/features/movie_details/presentation/pages/movie_details.dart';
import 'package:neo_play/features/payment/presentation/pages/buy_subscription_page.dart';
import 'package:neo_play/features/payment/presentation/pages/payment_history_page.dart';
import 'package:neo_play/features/payment/presentation/pages/purchased_subscriptions_page.dart';
import 'package:neo_play/features/payment/presentation/pages/top_up_balance_page.dart';
import 'package:neo_play/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:neo_play/features/splash/presentation/pages/splash_page.dart';

import '../../features/auth_and_register/presentation/pages/auth_pinput.dart';
import '../../features/movie_list/presentation/pages/movie_list.dart';
import '../../features/notification/presentation/pages/notification.dart';
import '../../features/video_player/presentation/pages/video_player_page.dart';

Widget appRoutes(RouteSettings settings) {
  switch (settings.name) {
    case RoutesName.splashPage:
      {
        return const SplashPage();
      }
    case RoutesName.authPage:
      {
        return const AuthPage();
      }
    case RoutesName.authPinPut:
      {
        return const AuthPinPut();
      }
    case RoutesName.registerPage:
      {
        return const RegisterPage();
      }
    case RoutesName.homePage:
      {
        return const HomePage();
      }
    case RoutesName.movieDetails:
      {
        return const MovieDetails();
      }
    case RoutesName.notification:
      {
        return const NotificationPage();
      }
    case RoutesName.movieList:
      {
        final name = settings.arguments as String?;
        return MovieList(movieListName: name ?? "");
      }

    case RoutesName.editProfile:
      {
        return const EditProfilePage();
      }
    case RoutesName.videoPlayerPage:
      {
        return VideoPlayerPage();
      }

    case RoutesName.topUpBalance:
      {
        return const TopUpBalancePage();
      }
    case RoutesName.buySubscription:
      {
        return const BuySubscriptionPage();
      }
    case RoutesName.purchasedSubscriptions:
      {
        return const PurchasedSubscriptionsPage();
      }
    case RoutesName.paymentHistory:
      {
        return const PaymentHistoryPage();
      }

    /// Devices
    case RoutesName.activeDevices:
      {
        return const ActiveDevicesPage();
      }

    /// About
    case RoutesName.support:
      {
        return const SupportPage();
      }
    case RoutesName.aboutApp:
      {
        return const AboutAppPage();
      }

    default:
      {
        return const Placeholder();
      }
  }
}
