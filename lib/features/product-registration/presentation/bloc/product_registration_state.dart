import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/supplier.dart';
import '../../domain/entities/product.dart';

// ✨ Form Data Class
class ProductFormData extends Equatable {
  final String name;
  final String description;
  final String barcode;
  final List<File> selectedImages;
  final List<String> uploadedImageUrls;
  final Map<String, String> validationErrors;
  final double? price;
  final double? cost;
  final int? stock;
  final String unit;
  final double? weight;
  final DateTime? expiryDate;

  const ProductFormData({
    required this.name,
    required this.description,
    required this.barcode,
    required this.selectedImages,
    required this.uploadedImageUrls,
    required this.validationErrors,
    this.price,
    this.cost,
    this.stock,
    this.unit = 'pcs',
    this.weight,
    this.expiryDate,
  });

  bool get isValid =>
      validationErrors.isEmpty &&
      name.isNotEmpty &&
      description.isNotEmpty &&
      price != null &&
      price! > 0 &&
      cost != null &&
      cost! > 0 &&
      stock != null &&
      stock! >= 0;

  ProductFormData copyWith({
    String? name,
    String? description,
    String? barcode,
    List<File>? selectedImages,
    List<String>? uploadedImageUrls,
    Map<String, String>? validationErrors,
    double? price,
    double? cost,
    int? stock,
    String? unit,
    double? weight,
    DateTime? expiryDate,
  }) {
    return ProductFormData(
      name: name ?? this.name,
      description: description ?? this.description,
      barcode: barcode ?? this.barcode,
      selectedImages: selectedImages ?? this.selectedImages,
      uploadedImageUrls: uploadedImageUrls ?? this.uploadedImageUrls,
      validationErrors: validationErrors ?? this.validationErrors,
      price: price ?? this.price,
      cost: cost ?? this.cost,
      stock: stock ?? this.stock,
      unit: unit ?? this.unit,
      weight: weight ?? this.weight,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }

  @override
  List<Object?> get props => [
    name,
    description,
    barcode,
    selectedImages,
    uploadedImageUrls,
    validationErrors,
    price,
    cost,
    stock,
    unit,
    weight,
    expiryDate,
  ];
}

// 🔥 Sealed class approach - jauh lebih clean!
sealed class ProductRegistrationState extends Equatable {
  const ProductRegistrationState();
}

// ✨ Initial State
class ProductRegistrationInitial extends ProductRegistrationState {
  const ProductRegistrationInitial();

  // Factory method untuk kemudahan
  static ProductRegistrationData initialData() {
    return const ProductRegistrationData(
      formData: ProductFormData(
        name: '',
        description: '',
        barcode: '',
        selectedImages: [],
        uploadedImageUrls: [],
        validationErrors: {},
      ),
      categories: [],
      suppliers: [],
      isLoadingCategories: false,
      isLoadingSuppliers: false,
      isUploadingImage: false,
    );
  }

  @override
  List<Object?> get props => [];
}

// ✨ Loading States dengan context
class ProductRegistrationLoading extends ProductRegistrationState {
  final String? message;
  const ProductRegistrationLoading({this.message});

  @override
  List<Object?> get props => [message];
}

// ✨ Data States
class ProductRegistrationData extends ProductRegistrationState {
  final ProductFormData formData;
  final List<Category> categories;
  final List<Supplier> suppliers;
  final Category? selectedCategory;
  final Supplier? selectedSupplier;
  final bool isSubmitting;
  
  // 🔥 Granular loading states
  final bool isLoadingCategories;
  final bool isLoadingSuppliers;
  final bool isUploadingImage;

  const ProductRegistrationData({
    required this.formData,
    required this.categories,
    required this.suppliers,
    this.selectedCategory,
    this.selectedSupplier,
    this.isSubmitting = false,
    this.isLoadingCategories = false,
    this.isLoadingSuppliers = false,
    this.isUploadingImage = false,
  });

  // Helper methods for reactive UI
  bool get showWeightField => selectedCategory?.requiresWeight ?? false;
  bool get showExpiryField => selectedCategory?.requiresExpiry ?? false;
  List<String> get allowedUnits => selectedCategory?.allowedUnits ?? ['pcs'];
  double? get taxRate => selectedCategory?.taxRate;
  double? get supplierDiscountRate => selectedSupplier?.discountRate;
  bool get canSelectSupplier =>
      selectedCategory != null && suppliers.isNotEmpty;
  bool get canSubmit =>
      formData.isValid &&
      selectedCategory != null &&
      selectedSupplier != null &&
      !isSubmitting;

  ProductRegistrationData copyWith({
    ProductFormData? formData,
    List<Category>? categories,
    List<Supplier>? suppliers,
    Category? selectedCategory,
    Supplier? selectedSupplier,
    bool? isSubmitting,
    bool? isLoadingCategories,
    bool? isLoadingSuppliers,
    bool? isUploadingImage,
  }) {
    return ProductRegistrationData(
      formData: formData ?? this.formData,
      categories: categories ?? this.categories,
      suppliers: suppliers ?? this.suppliers,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedSupplier: selectedSupplier ?? this.selectedSupplier,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
      isLoadingSuppliers: isLoadingSuppliers ?? this.isLoadingSuppliers,
      isUploadingImage: isUploadingImage ?? this.isUploadingImage,
    );
  }

  @override
  List<Object?> get props => [
    formData,
    categories,
    suppliers,
    selectedCategory,
    selectedSupplier,
    isSubmitting,
    isLoadingCategories,
    isLoadingSuppliers,
    isUploadingImage,
  ];
}

// ✨ Success State
class ProductRegistrationSuccess extends ProductRegistrationState {
  final Product createdProduct;
  const ProductRegistrationSuccess(this.createdProduct);

  @override
  List<Object?> get props => [createdProduct];
}

// ✨ Error States - specific dan type-safe!
sealed class ProductRegistrationError extends ProductRegistrationState {
  final String message;
  const ProductRegistrationError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductRegistrationCategoriesLoadError extends ProductRegistrationError {
  const ProductRegistrationCategoriesLoadError(super.message);
}

class ProductRegistrationSuppliersLoadError extends ProductRegistrationError {
  const ProductRegistrationSuppliersLoadError(super.message);
}

class ProductRegistrationImageUploadError extends ProductRegistrationError {
  const ProductRegistrationImageUploadError(super.message);
}

class ProductRegistrationSubmissionError extends ProductRegistrationError {
  const ProductRegistrationSubmissionError(super.message);
}

class ProductRegistrationValidationError extends ProductRegistrationError {
  final Map<String, String> fieldErrors;
  const ProductRegistrationValidationError(super.message, this.fieldErrors);

  @override
  List<Object?> get props => [message, fieldErrors];
}
