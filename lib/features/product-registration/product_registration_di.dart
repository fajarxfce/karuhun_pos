import 'data/datasources/product_registration_remote_data_source.dart';
import 'data/repositories/product_registration_repository_impl.dart';
import 'domain/usecases/get_categories.dart';
import 'domain/usecases/get_suppliers_by_category.dart';
import 'domain/usecases/upload_image.dart';
import 'domain/usecases/create_product.dart';
import 'presentation/bloc/product_registration_bloc.dart';

class ProductRegistrationDI {
  static ProductRegistrationBloc createProductRegistrationBloc() {
    // Data sources
    final remoteDataSource = ProductRegistrationRemoteDataSourceImpl();
    
    // Repository
    final repository = ProductRegistrationRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );
    
    // Use cases
    final getCategories = GetCategories(repository);
    final getSuppliersByCategory = GetSuppliersByCategory(repository);
    final uploadImage = UploadImage(repository);
    final createProduct = CreateProduct(repository);
    
    // BLoC
    return ProductRegistrationBloc(
      getCategories: getCategories,
      getSuppliersByCategory: getSuppliersByCategory,
      uploadImage: uploadImage,
      createProduct: createProduct,
    );
  }
}