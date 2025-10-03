import 'dart:io';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String? id;
  final String name;
  final String description;
  final String barcode;
  final String categoryId;
  final String supplierId;
  final double price;
  final double? weight;
  final String unit;
  final DateTime? expiryDate;
  final List<String> imageUrls;
  final bool isActive;
  final Map<String, dynamic> metadata;

  const Product({
    this.id,
    required this.name,
    required this.description,
    required this.barcode,
    required this.categoryId,
    required this.supplierId,
    required this.price,
    this.weight,
    required this.unit,
    this.expiryDate,
    required this.imageUrls,
    required this.isActive,
    required this.metadata,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? barcode,
    String? categoryId,
    String? supplierId,
    double? price,
    double? weight,
    String? unit,
    DateTime? expiryDate,
    List<String>? imageUrls,
    bool? isActive,
    Map<String, dynamic>? metadata,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      barcode: barcode ?? this.barcode,
      categoryId: categoryId ?? this.categoryId,
      supplierId: supplierId ?? this.supplierId,
      price: price ?? this.price,
      weight: weight ?? this.weight,
      unit: unit ?? this.unit,
      expiryDate: expiryDate ?? this.expiryDate,
      imageUrls: imageUrls ?? this.imageUrls,
      isActive: isActive ?? this.isActive,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    barcode,
    categoryId,
    supplierId,
    price,
    weight,
    unit,
    expiryDate,
    imageUrls,
    isActive,
    metadata,
  ];
}

// Value object for form validation
class ProductFormData extends Equatable {
  final String name;
  final String description;
  final String barcode;
  final String? selectedCategoryId;
  final String? selectedSupplierId;
  final double? price;
  final double? weight;
  final String? unit;
  final DateTime? expiryDate;
  final List<File> selectedImages;
  final List<String> uploadedImageUrls;
  final Map<String, String?> validationErrors;

  const ProductFormData({
    required this.name,
    required this.description,
    required this.barcode,
    this.selectedCategoryId,
    this.selectedSupplierId,
    this.price,
    this.weight,
    this.unit,
    this.expiryDate,
    required this.selectedImages,
    required this.uploadedImageUrls,
    required this.validationErrors,
  });

  ProductFormData copyWith({
    String? name,
    String? description,
    String? barcode,
    String? selectedCategoryId,
    String? selectedSupplierId,
    double? price,
    double? weight,
    String? unit,
    DateTime? expiryDate,
    List<File>? selectedImages,
    List<String>? uploadedImageUrls,
    Map<String, String?>? validationErrors,
  }) {
    return ProductFormData(
      name: name ?? this.name,
      description: description ?? this.description,
      barcode: barcode ?? this.barcode,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedSupplierId: selectedSupplierId ?? this.selectedSupplierId,
      price: price ?? this.price,
      weight: weight ?? this.weight,
      unit: unit ?? this.unit,
      expiryDate: expiryDate ?? this.expiryDate,
      selectedImages: selectedImages ?? this.selectedImages,
      uploadedImageUrls: uploadedImageUrls ?? this.uploadedImageUrls,
      validationErrors: validationErrors ?? this.validationErrors,
    );
  }

  bool get isValid => validationErrors.values.every((error) => error == null);

  @override
  List<Object?> get props => [
    name,
    description,
    barcode,
    selectedCategoryId,
    selectedSupplierId,
    price,
    weight,
    unit,
    expiryDate,
    selectedImages,
    uploadedImageUrls,
    validationErrors,
  ];
}
