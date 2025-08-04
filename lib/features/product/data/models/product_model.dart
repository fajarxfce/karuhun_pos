import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.sku,
    required super.name,
    required super.price,
    required super.stock,
    super.description,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.category,
    super.subCategory,
    super.merk,
    super.media,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      sku: json['sku'] as String,
      name: json['name'] as String,
      price: json['price'] as int,
      stock: json['stock'] as int,
      description: json['description'] as String?,
      status: json['status'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      category: json['category'] != null
          ? ProductCategoryModel.fromJson(
              json['category'] as Map<String, dynamic>,
            )
          : null,
      subCategory: json['sub_category'] != null
          ? ProductSubCategoryModel.fromJson(
              json['sub_category'] as Map<String, dynamic>,
            )
          : null,
      merk: json['merk'] != null
          ? ProductMerkModel.fromJson(json['merk'] as Map<String, dynamic>)
          : null,
      media: json['media'] != null
          ? (json['media'] as List)
                .map(
                  (media) =>
                      ProductMediaModel.fromJson(media as Map<String, dynamic>),
                )
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'name': name,
      'price': price,
      'stock': stock,
      'description': description,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'category': category != null
          ? (category as ProductCategoryModel).toJson()
          : null,
      'sub_category': subCategory != null
          ? (subCategory as ProductSubCategoryModel).toJson()
          : null,
      'merk': merk != null ? (merk as ProductMerkModel).toJson() : null,
      'media': media
          .map((media) => (media as ProductMediaModel).toJson())
          .toList(),
    };
  }
}

class ProductCategoryModel extends ProductCategory {
  const ProductCategoryModel({
    required super.id,
    required super.name,
    super.description,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      status: json['status'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class ProductSubCategoryModel extends ProductSubCategory {
  const ProductSubCategoryModel({
    required super.id,
    required super.productCategoryId,
    required super.name,
    super.description,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProductSubCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductSubCategoryModel(
      id: json['id'] as int,
      productCategoryId: json['product_category_id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      status: json['status'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_category_id': productCategoryId,
      'name': name,
      'description': description,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class ProductMerkModel extends ProductMerk {
  const ProductMerkModel({
    required super.id,
    required super.name,
    super.description,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProductMerkModel.fromJson(Map<String, dynamic> json) {
    return ProductMerkModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      status: json['status'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class ProductMediaModel extends ProductMedia {
  const ProductMediaModel({
    required super.id,
    required super.uuid,
    required super.name,
    required super.fileName,
    required super.mimeType,
    required super.size,
    required super.originalUrl,
    super.previewUrl,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProductMediaModel.fromJson(Map<String, dynamic> json) {
    return ProductMediaModel(
      id: json['id'] as int,
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      fileName: json['file_name'] as String,
      mimeType: json['mime_type'] as String,
      size: json['size'] as int,
      originalUrl: json['original_url'] as String,
      previewUrl: json['preview_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'name': name,
      'file_name': fileName,
      'mime_type': mimeType,
      'size': size,
      'original_url': originalUrl,
      'preview_url': previewUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
