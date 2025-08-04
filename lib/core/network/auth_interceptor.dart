import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';

@injectable
class AuthInterceptor extends Interceptor {
  final AuthLocalDataSource localDataSource;

  AuthInterceptor(this.localDataSource);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip adding token for login endpoint
    if (options.path.contains('/login') || options.path.contains('/register')) {
      handler.next(options);
      return;
    }

    try {
      final token = await localDataSource.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      // Token retrieval failed, continue without token
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 unauthorized responses
    if (err.response?.statusCode == 401) {
      // Clear stored token and redirect to login
      _handleUnauthorized();
    }

    handler.next(err);
  }

  void _handleUnauthorized() async {
    try {
      await localDataSource.clearToken();
      await localDataSource.clearUser();
      // You could also trigger a logout event here
      // getIt<AuthBloc>().add(LogoutRequested());
    } catch (e) {
      // Handle error
    }
  }
}
