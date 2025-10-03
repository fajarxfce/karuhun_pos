import 'package:dartz/dartz.dart';
import 'package:karuhun_pos/core/error/failures.dart';
import '../entities/supplier.dart';
import '../repositories/product_registration_repository.dart';

class GetSuppliersByCategory {
  final ProductRegistrationRepository repository;

  GetSuppliersByCategory(this.repository);

  Future<Either<Failure, List<Supplier>>> call(String categoryId) async {
    return await repository.getSuppliersByCategory(categoryId);
  }
}
