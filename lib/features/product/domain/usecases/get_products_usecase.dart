import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/paginated_products.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

@injectable
class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Failure, PaginatedProducts>> call(GetProductsParams params) async {
    return await repository.getProducts(
      page: params.page,
      perPage: params.perPage,
      orderBy: params.orderBy,
      order: params.order,
    );
  }
}

class GetProductsParams extends Equatable {
  final int page;
  final int perPage;
  final String orderBy;
  final String order;

  const GetProductsParams({
    this.page = 1,
    this.perPage = 10,
    this.orderBy = 'products.id',
    this.order = 'asc',
  });

  @override
  List<Object> get props => [page, perPage, orderBy, order];

  GetProductsParams copyWith({
    int? page,
    int? perPage,
    String? orderBy,
    String? order,
  }) {
    return GetProductsParams(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      orderBy: orderBy ?? this.orderBy,
      order: order ?? this.order,
    );
  }
}
