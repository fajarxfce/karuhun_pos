import 'package:injectable/injectable.dart';

import '../../../../core/network/api_client.dart';
import '../models/paginated_products_model.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<PaginatedProductsModel> getProducts({
    int page = 1,
    int perPage = 10,
    String orderBy = 'products.id',
    String order = 'asc',
  });

  Future<ProductModel> getProductById(int id);
}

@Injectable(as: ProductRemoteDataSource)
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSourceImpl(this.apiClient);

  @override
  Future<PaginatedProductsModel> getProducts({
    int page = 1,
    int perPage = 10,
    String orderBy = 'products.id',
    String order = 'asc',
  }) async {
    try {
      final response = await apiClient.get(
        '/product',
        queryParameters: {
          'page': page,
          'paginate': perPage,
          'orderBy': orderBy,
          'order': order,
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData is Map<String, dynamic>) {
          if (responseData['code'] == 200 &&
              responseData['message'] == 'Success') {
            return PaginatedProductsModel.fromJson(responseData);
          } else {
            throw Exception(
              responseData['message'] ?? 'Failed to get products',
            );
          }
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception(
          'Failed to get products with status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error getting products: ${e.toString()}');
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await apiClient.get('/product/$id');

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData is Map<String, dynamic>) {
          if (responseData['code'] == 200 &&
              responseData['message'] == 'Success') {
            final productData = responseData['data'] as Map<String, dynamic>;
            return ProductModel.fromJson(productData);
          } else {
            throw Exception(responseData['message'] ?? 'Failed to get product');
          }
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception(
          'Failed to get product with status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error getting product: ${e.toString()}');
    }
  }
}
