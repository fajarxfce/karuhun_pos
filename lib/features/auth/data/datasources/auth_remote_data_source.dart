import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart' as core_exceptions;
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});

  Future<void> logout();
}

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiClient.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final responseData = response.data;

        // Debug print untuk melihat struktur response
        debugPrint('Login Response: $responseData');

        if (responseData is Map<String, dynamic>) {
          // Check if response has code 200 and message Success
          if (responseData['code'] == 200 &&
              responseData['message'] == 'Success') {
            final data = responseData['data'] as Map<String, dynamic>;
            final token = data['token'] as String;
            final tokenType = data['token_type'] as String?;

            // Create user data with token information
            // Since API doesn't return user data, create minimal user object
            final userData = {
              'id': 1, // Default user ID
              'name': 'User', // Default name
              'email': email, // Use provided email
              'token': token,
              'token_type': tokenType ?? 'bearer',
            };

            return UserModel.fromJson(userData);
          } else {
            // Not successful
            final message = responseData['message'] ?? 'Login failed';
            throw core_exceptions.ServerException(message);
          }
        } else {
          // Response data is not a Map
          throw core_exceptions.ServerException('Invalid response format');
        }
      } else {
        throw core_exceptions.ServerException(
          'Login failed with status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      debugPrint(
        'DioException caught: ${e.type}, Response: ${e.response?.data}',
      );

      if (e.response != null) {
        final errorData = e.response!.data;
        String errorMessage = 'Login failed';

        if (errorData is Map<String, dynamic>) {
          errorMessage = errorData['message'] ?? errorMessage;

          // Handle validation errors
          if (errorData['errors'] != null) {
            final errors = errorData['errors'] as Map<String, dynamic>;
            final List<String> errorMessages = [];

            errors.forEach((key, value) {
              if (value is List) {
                errorMessages.addAll(value.cast<String>());
              }
            });

            if (errorMessages.isNotEmpty) {
              errorMessage = errorMessages.join(', ');
            }
          }
        }

        if (e.response!.statusCode == 401) {
          throw core_exceptions.UnauthorizedException(errorMessage);
        } else if (e.response!.statusCode == 422) {
          throw core_exceptions.ValidationException(errorMessage);
        } else {
          throw core_exceptions.ServerException(errorMessage);
        }
      } else {
        // No response means network error
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          throw core_exceptions.NetworkException('Connection timeout');
        } else if (e.type == DioExceptionType.connectionError) {
          throw core_exceptions.NetworkException('No internet connection');
        } else {
          throw core_exceptions.NetworkException('Network error occurred');
        }
      }
    } on core_exceptions.ServerException {
      rethrow;
    } on core_exceptions.NetworkException {
      rethrow;
    } on core_exceptions.UnauthorizedException {
      rethrow;
    } on core_exceptions.ValidationException {
      rethrow;
    } catch (e) {
      debugPrint('Unexpected error in login: $e');
      throw core_exceptions.ServerException(
        'Unexpected error occurred: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await apiClient.post('/logout');
    } on DioException catch (e) {
      if (e.response != null) {
        throw core_exceptions.ServerException('Logout failed');
      } else {
        throw core_exceptions.NetworkException('No internet connection');
      }
    } catch (e) {
      throw core_exceptions.ServerException(
        'Unexpected error occurred: ${e.toString()}',
      );
    }
  }
}
