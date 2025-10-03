import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    super.id,
    required super.name,
    required super.description,
    required super.barcode,
    required super.categoryId,
    required super.supplierId,
    required super.price,
    super.weight,
    required super.unit,
    super.expiryDate,
    required super.imageUrls,
    required super.isActive,
    required super.metadata,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String,
      barcode: json['barcode'] as String,
      categoryId: json['category_id'] as String,
      supplierId: json['supplier_id'] as String,
      price: (json['price'] as num).toDouble(),
      weight: json['weight']?.toDouble(),
      unit: json['unit'] as String,
      expiryDate: json['expiry_date'] != null
          ? DateTime.parse(json['expiry_date'] as String)
          : null,
      imageUrls: List<String>.from(json['image_urls'] as List? ?? []),
      isActive: json['is_active'] as bool? ?? true,
      metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'barcode': barcode,
      'category_id': categoryId,
      'supplier_id': supplierId,
      'price': price,
      'weight': weight,
      'unit': unit,
      'expiry_date': expiryDate?.toIso8601String(),
      'image_urls': imageUrls,
      'is_active': isActive,
      'metadata': metadata,
    };
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      barcode: product.barcode,
      categoryId: product.categoryId,
      supplierId: product.supplierId,
      price: product.price,
      weight: product.weight,
      unit: product.unit,
      expiryDate: product.expiryDate,
      imageUrls: product.imageUrls,
      isActive: product.isActive,
      metadata: product.metadata,
    );
  }
}
