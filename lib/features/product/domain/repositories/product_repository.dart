import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/paginated_products.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, PaginatedProducts>> getProducts({
    int page = 1,
    int perPage = 10,
    String orderBy = 'products.id',
    String order = 'asc',
  });

  Future<Either<Failure, Product>> getProductById(int id);

  Future<Either<Failure, Product>> createProduct(Product product);

  Future<Either<Failure, Product>> updateProduct(Product product);

  Future<Either<Failure, void>> deleteProduct(int id);
}
