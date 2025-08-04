import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc({required this.loginUseCase}) : super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthFailure(_mapFailureToMessage(failure))),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    emit(const AuthInitial());
  }

  String _mapFailureToMessage(Failure failure) {
    debugPrint(
      'Mapping failure: ${failure.runtimeType} - ${failure.toString()}',
    );

    if (failure is UnauthorizedFailure) {
      return 'Email atau password salah';
    } else if (failure is ValidationFailure) {
      return failure.message;
    } else if (failure is NetworkFailure) {
      return 'Tidak ada koneksi internet';
    } else if (failure is ServerFailure) {
      // Don't show "ServerException" to user, just the message
      String message = failure.message;
      if (message.contains('ServerException:')) {
        message = message.replaceAll('ServerException:', '').trim();
      }
      if (message.contains('Unexpected error occurred:')) {
        message = message.replaceAll('Unexpected error occurred:', '').trim();
      }
      return message.isNotEmpty ? message : 'Terjadi kesalahan pada server';
    } else {
      return 'Terjadi kesalahan yang tidak terduga';
    }
  }
}
