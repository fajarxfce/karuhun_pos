import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.description,
    required super.requiresWeight,
    required super.requiresExpiry,
    required super.allowedUnits,
    super.taxRate,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      requiresWeight: json['requires_weight'] as bool,
      requiresExpiry: json['requires_expiry'] as bool,
      allowedUnits: List<String>.from(json['allowed_units'] as List),
      taxRate: json['tax_rate']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'requires_weight': requiresWeight,
      'requires_expiry': requiresExpiry,
      'allowed_units': allowedUnits,
      'tax_rate': taxRate,
    };
  }

  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      description: category.description,
      requiresWeight: category.requiresWeight,
      requiresExpiry: category.requiresExpiry,
      allowedUnits: category.allowedUnits,
      taxRate: category.taxRate,
    );
  }
}
