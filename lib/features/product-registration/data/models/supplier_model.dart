import '../../domain/entities/supplier.dart';

class SupplierModel extends Supplier {
  const SupplierModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.address,
    required super.categoryIds,
    required super.discountRate,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      categoryIds: List<String>.from(json['category_ids'] as List),
      discountRate: (json['discount_rate'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'category_ids': categoryIds,
      'discount_rate': discountRate,
    };
  }

  factory SupplierModel.fromEntity(Supplier supplier) {
    return SupplierModel(
      id: supplier.id,
      name: supplier.name,
      email: supplier.email,
      phone: supplier.phone,
      address: supplier.address,
      categoryIds: supplier.categoryIds,
      discountRate: supplier.discountRate,
    );
  }
}
