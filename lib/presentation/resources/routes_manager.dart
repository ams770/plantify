import 'package:go_router/go_router.dart';

import '../home/home_view.dart';
import '../onboarding/onboarding_view.dart';
import '../splash/splash_view.dart';

class Routes {
  static const String splashRoute = "/";
  static const String onBoardingRoute = "/onboarding";
  static const String homeRoute = "/home";
}

class RouteGenerator {
  static final router = GoRouter(
    routes: [
      /* -------------------------- On Boarding Route -------------------------- */
      GoRoute(
        path: Routes.splashRoute,
        builder: (context, state) => const SplashView(),
      ),
      /* -------------------------- On Boarding Route -------------------------- */
      GoRoute(
        path: Routes.onBoardingRoute,
        builder: (context, state) => const OnBoardingView(),
      ),

      /* -------------------------- Home Route -------------------------- */
      GoRoute(
        path: Routes.homeRoute,
        builder: (context, state) => const HomeView(),
      ),
    ],
  );
}
