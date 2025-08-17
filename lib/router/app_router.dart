import '../features/product/domain/entities/product.dart';
import '../main.dart' show rootNavigatorKey;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/auth/presentation/screen/login_screen.dart';
import '../features/dashboard/presentation/screen/dashboard_screen.dart';
import '../features/main/presentation/screen/main_screen.dart';
import '../features/onboarding/presentation/screen/onboarding-screen.dart';
import '../features/product/presentation/screen/product_list_screen.dart';
import '../features/product/presentation/screen/product_detail_screen.dart';

class AppRouter {
  static GoRouter get router => _router;

  static final _router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) async {
      final prefs = await SharedPreferences.getInstance();
      final onboardingCompleted =
          prefs.getBool('onboarding_completed') ?? false;
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

      // If we're on the root path, decide where to redirect
      if (state.matchedLocation == '/') {
        if (!onboardingCompleted) {
          return '/onboarding';
        } else if (!isLoggedIn) {
          return '/login';
        } else {
          return '/main';
        }
      }

      return null; // No redirect needed
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) =>
            const SizedBox(), // This will be redirected
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/main',
        name: 'main',
        builder: (context, state) => const MainScreen(),
      ),
      // Legacy routes for backward compatibility
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/products',
        name: 'products',
        builder: (context, state) => const ProductListScreen(),
      ),
      GoRoute(
        path: '/product/:id',
        name: 'product-detail',
        builder: (context, state) {
          final product = state.extra;
          if (product == null) {
            return const Scaffold(
              body: Center(child: Text('Produk tidak ditemukan')),
            );
          }
          return ProductDetailScreen(product: product as Product);
        },
      ),
    ],
  );
}
