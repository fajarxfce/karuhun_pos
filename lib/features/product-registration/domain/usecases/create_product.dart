import 'package:dartz/dartz.dart';
import 'package:karuhun_pos/core/error/failures.dart';
import '../entities/product.dart';
import '../repositories/product_registration_repository.dart';

class CreateProduct {
  final ProductRegistrationRepository repository;

  CreateProduct(this.repository);

  Future<Either<Failure, Product>> call(Product product) async {
    return await repository.createProduct(product);
  }
}
