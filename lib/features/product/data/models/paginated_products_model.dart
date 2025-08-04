import '../../domain/entities/paginated_products.dart';
import '../../domain/entities/product.dart';
import 'product_model.dart';

class PaginatedProductsModel extends PaginatedProducts {
  const PaginatedProductsModel({
    required List<Product> data,
    required int currentPage,
    required int lastPage,
    required int perPage,
    required int total,
    int? from,
    int? to,
  }) : super(
         data: data,
         currentPage: currentPage,
         lastPage: lastPage,
         perPage: perPage,
         total: total,
         from: from,
         to: to,
       );

  factory PaginatedProductsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return PaginatedProductsModel(
      data: (data['data'] as List<dynamic>)
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      currentPage: data['current_page'] as int,
      lastPage: data['last_page'] as int,
      perPage: data['per_page'] as int,
      total: data['total'] as int,
      from: data['from'] as int?,
      to: data['to'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'data': data
            .map((product) => (product as ProductModel).toJson())
            .toList(),
        'current_page': currentPage,
        'last_page': lastPage,
        'per_page': perPage,
        'total': total,
        'from': from,
        'to': to,
      },
    };
  }
}
