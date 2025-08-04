import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart' as core_exceptions;
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.login(
        email: email,
        password: password,
      );

      // Save user and token locally
      await localDataSource.saveUser(user);
      if (user.token != null) {
        await localDataSource.saveToken(user.token!);
      }

      return Right(user);
    } on core_exceptions.UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on core_exceptions.ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on core_exceptions.ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on core_exceptions.NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on core_exceptions.CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearUser();
      await localDataSource.clearToken();
      return const Right(null);
    } on core_exceptions.ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on core_exceptions.NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on core_exceptions.CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await localDataSource.getUser();
      return Right(user);
    } on core_exceptions.CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final token = await localDataSource.getToken();
      return Right(token != null && token.isNotEmpty);
    } on core_exceptions.CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error occurred: ${e.toString()}'));
    }
  }
}
