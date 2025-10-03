import 'dart:io';
import 'dart:math';
import '../models/category_model.dart';
import '../models/supplier_model.dart';
import '../models/product_model.dart';

abstract class ProductRegistrationRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<List<SupplierModel>> getSuppliersByCategory(String categoryId);
  Future<String> uploadImage(File imageFile);
  Future<ProductModel> createProduct(ProductModel product);
  Future<ProductModel> updateProduct(ProductModel product);
}

class ProductRegistrationRemoteDataSourceImpl
    implements ProductRegistrationRemoteDataSource {
  final Random _random = Random();

  // Dummy delay to simulate network call
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(Duration(milliseconds: 500 + _random.nextInt(1000)));
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    await _simulateNetworkDelay();

    // Simulate network failure occasionally
    if (_random.nextDouble() < 0.1) {
      throw Exception('Network error occurred');
    }

    // Dummy categories data
    final categoriesJson = [
      {
        'id': 'cat_1',
        'name': 'Electronics',
        'description': 'Electronic devices and accessories',
        'requires_weight': false,
        'requires_expiry': false,
        'allowed_units': ['pcs', 'box'],
        'tax_rate': 0.11,
      },
      {
        'id': 'cat_2',
        'name': 'Food & Beverages',
        'description': 'Food items and drinks',
        'requires_weight': true,
        'requires_expiry': true,
        'allowed_units': ['kg', 'gram', 'liter', 'ml'],
        'tax_rate': 0.05,
      },
      {
        'id': 'cat_3',
        'name': 'Clothing',
        'description': 'Apparel and fashion items',
        'requires_weight': false,
        'requires_expiry': false,
        'allowed_units': ['pcs', 'pair'],
        'tax_rate': 0.11,
      },
      {
        'id': 'cat_4',
        'name': 'Health & Beauty',
        'description': 'Healthcare and cosmetic products',
        'requires_weight': false,
        'requires_expiry': true,
        'allowed_units': ['pcs', 'ml', 'gram'],
        'tax_rate': 0.11,
      },
    ];

    return categoriesJson.map((json) => CategoryModel.fromJson(json)).toList();
  }

  @override
  Future<List<SupplierModel>> getSuppliersByCategory(String categoryId) async {
    await _simulateNetworkDelay();

    // Simulate network failure occasionally
    if (_random.nextDouble() < 0.1) {
      throw Exception('Network error occurred');
    }

    // Different suppliers based on category
    Map<String, List<Map<String, dynamic>>> suppliersByCategory = {
      'cat_1': [
        {
          'id': 'sup_1',
          'name': 'TechCorp Electronics',
          'email': 'contact@techcorp.com',
          'phone': '+62-21-1234567',
          'address': 'Jl. Sudirman No. 123, Jakarta',
          'category_ids': ['cat_1'],
          'discount_rate': 0.15,
        },
        {
          'id': 'sup_2',
          'name': 'Digital Solutions Inc',
          'email': 'sales@digitalsolutions.com',
          'phone': '+62-21-2345678',
          'address': 'Jl. Thamrin No. 456, Jakarta',
          'category_ids': ['cat_1'],
          'discount_rate': 0.12,
        },
      ],
      'cat_2': [
        {
          'id': 'sup_3',
          'name': 'Fresh Food Distributors',
          'email': 'orders@freshfood.co.id',
          'phone': '+62-21-3456789',
          'address': 'Jl. Kebon Jeruk No. 789, Jakarta',
          'category_ids': ['cat_2'],
          'discount_rate': 0.08,
        },
        {
          'id': 'sup_4',
          'name': 'Beverage Masters',
          'email': 'info@beveragemasters.com',
          'phone': '+62-21-4567890',
          'address': 'Jl. Mangga Dua No. 321, Jakarta',
          'category_ids': ['cat_2'],
          'discount_rate': 0.10,
        },
      ],
      'cat_3': [
        {
          'id': 'sup_5',
          'name': 'Fashion Forward',
          'email': 'wholesale@fashionforward.id',
          'phone': '+62-21-5678901',
          'address': 'Jl. Senayan No. 654, Jakarta',
          'category_ids': ['cat_3'],
          'discount_rate': 0.20,
        },
      ],
      'cat_4': [
        {
          'id': 'sup_6',
          'name': 'Beauty Essentials',
          'email': 'b2b@beautyessentials.co.id',
          'phone': '+62-21-6789012',
          'address': 'Jl. Pondok Indah No. 987, Jakarta',
          'category_ids': ['cat_4'],
          'discount_rate': 0.18,
        },
      ],
    };

    final suppliersJson = suppliersByCategory[categoryId] ?? [];
    return suppliersJson.map((json) => SupplierModel.fromJson(json)).toList();
  }

  @override
  Future<String> uploadImage(File imageFile) async {
    await _simulateNetworkDelay();

    // Simulate upload failure occasionally
    if (_random.nextDouble() < 0.05) {
      throw Exception('Image upload failed');
    }

    // Generate dummy image URL
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomId = _random.nextInt(10000);
    return 'https://api.example.com/images/products/${timestamp}_$randomId.jpg';
  }

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    await _simulateNetworkDelay();

    // Simulate creation failure occasionally
    if (_random.nextDouble() < 0.05) {
      throw Exception('Product creation failed');
    }

    // Return product with generated ID
    final productJson = product.toJson();
    productJson['id'] = 'prod_${_random.nextInt(100000)}';

    return ProductModel.fromJson(productJson);
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    await _simulateNetworkDelay();

    // Simulate update failure occasionally
    if (_random.nextDouble() < 0.05) {
      throw Exception('Product update failed');
    }

    return product;
  }
}
