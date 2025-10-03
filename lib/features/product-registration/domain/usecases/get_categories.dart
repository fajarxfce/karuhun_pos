import 'package:dartz/dartz.dart';
import 'package:karuhun_pos/core/error/failures.dart';
import '../entities/category.dart';
import '../repositories/product_registration_repository.dart';

class GetCategories {
  final ProductRegistrationRepository repository;

  GetCategories(this.repository);

  Future<Either<Failure, List<Category>>> call() async {
    return await repository.getCategories();
  }
}
