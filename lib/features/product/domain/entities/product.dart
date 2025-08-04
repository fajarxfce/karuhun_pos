import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String sku;
  final String name;
  final int price;
  final int stock;
  final String? description;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ProductCategory? category;
  final ProductSubCategory? subCategory;
  final ProductMerk? merk;
  final List<ProductMedia> media;

  const Product({
    required this.id,
    required this.sku,
    required this.name,
    required this.price,
    required this.stock,
    this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.category,
    this.subCategory,
    this.merk,
    this.media = const [],
  });

  @override
  List<Object?> get props => [
        id,
        sku,
        name,
        price,
        stock,
        description,
        status,
        createdAt,
        updatedAt,
        category,
        subCategory,
        merk,
        media,
      ];
}

class ProductCategory extends Equatable {
  final int id;
  final String name;
  final String? description;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductCategory({
    required this.id,
    required this.name,
    this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, description, status, createdAt, updatedAt];
}

class ProductSubCategory extends Equatable {
  final int id;
  final int productCategoryId;
  final String name;
  final String? description;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductSubCategory({
    required this.id,
    required this.productCategoryId,
    required this.name,
    this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, productCategoryId, name, description, status, createdAt, updatedAt];
}

class ProductMerk extends Equatable {
  final int id;
  final String name;
  final String? description;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductMerk({
    required this.id,
    required this.name,
    this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, description, status, createdAt, updatedAt];
}

class ProductMedia extends Equatable {
  final int id;
  final String uuid;
  final String name;
  final String fileName;
  final String mimeType;
  final int size;
  final String originalUrl;
  final String? previewUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductMedia({
    required this.id,
    required this.uuid,
    required this.name,
    required this.fileName,
    required this.mimeType,
    required this.size,
    required this.originalUrl,
    this.previewUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        uuid,
        name,
        fileName,
        mimeType,
        size,
        originalUrl,
        previewUrl,
        createdAt,
        updatedAt,
      ];
}
