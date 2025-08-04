import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'auth_interceptor.dart';
import 'network_interceptors.dart';

@lazySingleton
class ApiClient {
  final Dio _dio;
  final AuthInterceptor _authInterceptor;

  ApiClient(this._dio, this._authInterceptor) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Add performance monitoring first
    if (kDebugMode) {
      _dio.interceptors.add(PerformanceInterceptor());
    }

    // Add rate limiting
    _dio.interceptors.add(RateLimitInterceptor());

    // Add retry mechanism (pass Dio instance)
    _dio.interceptors.add(RetryInterceptor(_dio));

    // Add auth interceptor
    _dio.interceptors.add(_authInterceptor);

    // Add pretty logging interceptor (only in debug mode)
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
          enabled: true,
          filter: (options, args) {
            // Don't log sensitive endpoints body
            if (options.path.contains('/login') || 
                options.path.contains('/register')) {
              return false;
            }
            return true;
          },
        ),
      );

      // Add additional debug logging
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            debugPrint('🚀 REQUEST[${options.method}] => PATH: ${options.path}');
            debugPrint('🚀 Headers: ${options.headers}');
            if (options.data != null && 
                !options.path.contains('/login') && 
                !options.path.contains('/register')) {
              debugPrint('🚀 Body: ${options.data}');
            }
            handler.next(options);
          },
          onResponse: (response, handler) {
            debugPrint('✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
            if (!response.requestOptions.path.contains('/login') && 
                !response.requestOptions.path.contains('/register')) {
              debugPrint('✅ Data: ${response.data}');
            } else {
              debugPrint('✅ Data: [SENSITIVE DATA HIDDEN]');
            }
            handler.next(response);
          },
          onError: (DioException e, handler) {
            debugPrint('❌ ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
            debugPrint('❌ Message: ${e.message}');
            if (e.response?.data != null) {
              debugPrint('❌ Error Data: ${e.response?.data}');
            }
            handler.next(e);
          },
        ),
      );
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add custom headers (if not already set by AuthInterceptor)
          options.headers['Accept'] = 'application/json';
          options.headers['Content-Type'] = 'application/json';
          
          handler.next(options);
        },
        onResponse: (response, handler) {
          // Handle successful responses globally if needed
          handler.next(response);
        },
        onError: (DioException e, handler) {
          // Handle errors globally
          _handleError(e);
          handler.next(e);
        },
      ),
    );
  }

  void _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw NetworkException('Connection timeout');
      case DioExceptionType.badResponse:
        throw ServerException('Server error: ${error.response?.statusCode}');
      case DioExceptionType.cancel:
        throw NetworkException('Request cancelled');
      case DioExceptionType.connectionError:
        throw NetworkException('No internet connection');
      default:
        throw NetworkException('Something went wrong');
    }
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}

// Custom exceptions
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);

  @override
  String toString() => 'ServerException: $message';
}
