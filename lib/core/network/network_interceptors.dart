import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Retry interceptor for handling network failures
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;
  final Dio _dio;

  RetryInterceptor(this._dio, {
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err) && err.requestOptions.extra['retryCount'] == null) {
      err.requestOptions.extra['retryCount'] = 0;
    }

    final retryCount = err.requestOptions.extra['retryCount'] ?? 0;

    if (_shouldRetry(err) && retryCount < maxRetries) {
      err.requestOptions.extra['retryCount'] = retryCount + 1;
      
      debugPrint('🔄 Retrying request (${retryCount + 1}/$maxRetries): ${err.requestOptions.path}');
      
      await Future.delayed(retryDelay * (retryCount + 1));
      
      try {
        // Use the original Dio instance to maintain interceptors
        final response = await _dio.fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (e) {
        // Retry failed, continue with original error
      }
    }

    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.sendTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           err.type == DioExceptionType.connectionError ||
           (err.response?.statusCode != null && 
            err.response!.statusCode! >= 500);
  }
}

/// Rate limiting interceptor
class RateLimitInterceptor extends Interceptor {
  final Duration minInterval;
  DateTime? _lastRequestTime;

  RateLimitInterceptor({
    this.minInterval = const Duration(milliseconds: 100),
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (_lastRequestTime != null) {
      final timeSinceLastRequest = DateTime.now().difference(_lastRequestTime!);
      if (timeSinceLastRequest < minInterval) {
        final waitTime = minInterval - timeSinceLastRequest;
        debugPrint('⏳ Rate limiting: waiting ${waitTime.inMilliseconds}ms');
        await Future.delayed(waitTime);
      }
    }
    
    _lastRequestTime = DateTime.now();
    handler.next(options);
  }
}

/// Performance monitoring interceptor
class PerformanceInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['start_time'] = DateTime.now().millisecondsSinceEpoch;
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = response.requestOptions.extra['start_time'] as int?;
    if (startTime != null) {
      final duration = DateTime.now().millisecondsSinceEpoch - startTime;
      debugPrint('⏱️ Request took ${duration}ms: ${response.requestOptions.path}');
      
      // Log slow requests
      if (duration > 3000) {
        debugPrint('🐌 SLOW REQUEST DETECTED: ${response.requestOptions.path} took ${duration}ms');
      }
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startTime = err.requestOptions.extra['start_time'] as int?;
    if (startTime != null) {
      final duration = DateTime.now().millisecondsSinceEpoch - startTime;
      debugPrint('⏱️ Failed request took ${duration}ms: ${err.requestOptions.path}');
    }
    handler.next(err);
  }
}
