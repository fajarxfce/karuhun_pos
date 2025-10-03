import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:karuhun_pos/core/error/failures.dart';
import '../entities/category.dart';
import '../entities/supplier.dart';
import '../entities/product.dart';

abstract class ProductRegistrationRepository {
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, List<Supplier>>> getSuppliersByCategory(
    String categoryId,
  );
  Future<Either<Failure, String>> uploadImage(File imageFile);
  Future<Either<Failure, Product>> createProduct(Product product);
  Future<Either<Failure, Product>> updateProduct(Product product);
}
