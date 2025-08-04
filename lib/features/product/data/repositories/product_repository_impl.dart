import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/paginated_products.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

@Injectable(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PaginatedProducts>> getProducts({
    int page = 1,
    int perPage = 10,
    String orderBy = 'products.id',
    String order = 'asc',
  }) async {
    try {
      final result = await remoteDataSource.getProducts(
        page: page,
        perPage: perPage,
        orderBy: orderBy,
        order: order,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(int id) async {
    try {
      final result = await remoteDataSource.getProductById(id);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product>> createProduct(Product product) async {
    // TODO: Implement create product
    return Left(ServerFailure('Create product not implemented yet'));
  }

  @override
  Future<Either<Failure, Product>> updateProduct(Product product) async {
    // TODO: Implement update product
    return Left(ServerFailure('Update product not implemented yet'));
  }

  @override
  Future<Either<Failure, void>> deleteProduct(int id) async {
    // TODO: Implement delete product
    return Left(ServerFailure('Delete product not implemented yet'));
  }
}
