import 'package:go_router/go_router.dart';

import '../features/auth/presentation/screen/login_screen.dart';
import '../features/dashboard/presentation/screen/dashboard_screen.dart';
import '../features/product/presentation/screen/product_list_screen.dart';

class AppRouter {
  static GoRouter get router => _router;

  static final _router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
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
    ],
  );
}
