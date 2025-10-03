import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:karuhun_pos/core/error/failures.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/supplier.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_registration_repository.dart';
import '../datasources/product_registration_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRegistrationRepositoryImpl
    implements ProductRegistrationRepository {
  final ProductRegistrationRemoteDataSource remoteDataSource;

  ProductRegistrationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories);
    } catch (e) {
      return Left(ServerFailure('Failed to get categories: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Supplier>>> getSuppliersByCategory(
    String categoryId,
  ) async {
    try {
      final suppliers = await remoteDataSource.getSuppliersByCategory(
        categoryId,
      );
      return Right(suppliers);
    } catch (e) {
      return Left(ServerFailure('Failed to get categories: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadImage(File imageFile) async {
    try {
      final imageUrl = await remoteDataSource.uploadImage(imageFile);
      return Right(imageUrl);
    } catch (e) {
      return Left(ServerFailure('Image upload failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Product>> createProduct(Product product) async {
    try {
      final productModel = ProductModel.fromEntity(product);
      final createdProduct = await remoteDataSource.createProduct(productModel);
      return Right(createdProduct);
    } catch (e) {
      return Left(ServerFailure('Product creation failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Product>> updateProduct(Product product) async {
    try {
      final productModel = ProductModel.fromEntity(product);
      final updatedProduct = await remoteDataSource.updateProduct(productModel);
      return Right(updatedProduct);
    } catch (e) {
      return Left(ServerFailure('Product update failed: ${e.toString()}'));
    }
  }
}
