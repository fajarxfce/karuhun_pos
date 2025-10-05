import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart' as domain;
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_suppliers_by_category.dart';
import '../../domain/usecases/upload_image.dart';
import '../../domain/usecases/create_product.dart';
import 'product_registration_event.dart';
import 'product_registration_state.dart';

class ProductRegistrationBloc
    extends Bloc<ProductRegistrationEvent, ProductRegistrationState> {
  final GetCategories getCategories;
  final GetSuppliersByCategory getSuppliersByCategory;
  final UploadImage uploadImage;
  final CreateProduct createProduct;

  ProductRegistrationBloc({
    required this.getCategories,
    required this.getSuppliersByCategory,
    required this.uploadImage,
    required this.createProduct,
  }) : super(const ProductRegistrationInitial()) {
    // Register event handlers
    on<LoadCategories>(_onLoadCategories);
    on<CategorySelected>(_onCategorySelected);
    on<LoadSuppliers>(_onLoadSuppliers);
    on<SupplierSelected>(_onSupplierSelected);

    // Form field events
    on<NameChanged>(_onNameChanged);
    on<DescriptionChanged>(_onDescriptionChanged);
    on<BarcodeChanged>(_onBarcodeChanged);
    on<PriceChanged>(_onPriceChanged);

    // Image events
    on<ImageSelected>(_onImageSelected);
    on<ImageRemoved>(_onImageRemoved);

    // Form submission
    on<SubmitForm>(_onSubmitForm);
    on<ResetForm>(_onResetForm);
  }

  // 🔥 Helper method to get current data state
  ProductRegistrationData _getCurrentDataOrInitial() {
    if (state is ProductRegistrationData) {
      return state as ProductRegistrationData;
    }
    // If not ProductRegistrationData, create initial data state
    return ProductRegistrationInitial.initialData();
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<ProductRegistrationState> emit,
  ) async {
    print('🔥 LoadCategories started');
    final currentData = _getCurrentDataOrInitial();
    
    // Set loading flag instead of separate loading state
    emit(currentData.copyWith(isLoadingCategories: true));

    final result = await getCategories();
    result.fold(
      (failure) {
        print('🚨 Categories load failed: $failure');
        emit(ProductRegistrationCategoriesLoadError(failure.toString()));
      },
      (categories) {
        print('✅ Categories loaded: ${categories.length} items');
        // Update categories and stop loading
        emit(
          currentData.copyWith(
            categories: categories,
            isLoadingCategories: false,
          ),
        );
      },
    );
  }

  Future<void> _onCategorySelected(
    CategorySelected event,
    Emitter<ProductRegistrationState> emit,
  ) async {
    final currentData = _getCurrentDataOrInitial();
    final selectedCategory = currentData.categories.firstWhere(
      (cat) => cat.id == event.categoryId,
    );

    // Update validation - remove category error since it's now selected
    final errors = Map<String, String>.from(
      currentData.formData.validationErrors,
    );
    errors.remove('category');

    emit(
      currentData.copyWith(
        selectedCategory: selectedCategory,
        suppliers: [], // Reset suppliers
        selectedSupplier: null,
        formData: currentData.formData.copyWith(
          unit: selectedCategory.allowedUnits.isNotEmpty
              ? selectedCategory.allowedUnits.first
              : 'pcs',
          validationErrors: errors,
        ),
      ),
    );

    // Load suppliers for selected category
    add(LoadSuppliers(event.categoryId));
  }

  Future<void> _onLoadSuppliers(
    LoadSuppliers event,
    Emitter<ProductRegistrationState> emit,
  ) async {
    final currentData = _getCurrentDataOrInitial();

    // Set loading suppliers flag instead of separate loading state  
    emit(currentData.copyWith(isLoadingSuppliers: true));

    final result = await getSuppliersByCategory(event.categoryId);
    result.fold(
      (failure) =>
          emit(ProductRegistrationSuppliersLoadError(failure.toString())),
      (suppliers) {
        emit(currentData.copyWith(
          suppliers: suppliers,
          isLoadingSuppliers: false,
        ));
      },
    );
  }

  void _onSupplierSelected(
    SupplierSelected event,
    Emitter<ProductRegistrationState> emit,
  ) {
    final currentData = _getCurrentDataOrInitial();
    final selectedSupplier = currentData.suppliers.firstWhere(
      (sup) => sup.id == event.supplierId,
    );

    // Update validation - remove supplier error since it's now selected
    final errors = Map<String, String>.from(
      currentData.formData.validationErrors,
    );
    errors.remove('supplier');

    emit(
      currentData.copyWith(
        selectedSupplier: selectedSupplier,
        formData: currentData.formData.copyWith(validationErrors: errors),
      ),
    );
  }

  // 🔥 Form field handlers with validation
  void _onNameChanged(
    NameChanged event,
    Emitter<ProductRegistrationState> emit,
  ) {
    final currentData = _getCurrentDataOrInitial();

    // Update name value
    final updatedFormData = currentData.formData.copyWith(name: event.name);

    // Validate name field
    final errors = Map<String, String>.from(updatedFormData.validationErrors);
    if (event.name.trim().isEmpty) {
      errors['name'] = 'Product name is required';
    } else if (event.name.trim().length < 3) {
      errors['name'] = 'Product name must be at least 3 characters';
    } else {
      errors.remove('name');
    }

    emit(
      currentData.copyWith(
        formData: updatedFormData.copyWith(validationErrors: errors),
      ),
    );
  }

  void _onDescriptionChanged(
    DescriptionChanged event,
    Emitter<ProductRegistrationState> emit,
  ) {
    final currentData = _getCurrentDataOrInitial();

    // Update description value
    final updatedFormData = currentData.formData.copyWith(
      description: event.description,
    );

    // Validate description field
    final errors = Map<String, String>.from(updatedFormData.validationErrors);
    if (event.description.trim().isEmpty) {
      errors['description'] = 'Description is required';
    } else {
      errors.remove('description');
    }

    emit(
      currentData.copyWith(
        formData: updatedFormData.copyWith(validationErrors: errors),
      ),
    );
  }

  void _onBarcodeChanged(
    BarcodeChanged event,
    Emitter<ProductRegistrationState> emit,
  ) {
    final currentData = _getCurrentDataOrInitial();

    // Update barcode value
    final updatedFormData = currentData.formData.copyWith(
      barcode: event.barcode,
    );

    // Validate barcode field (optional field, but if provided should be valid)
    final errors = Map<String, String>.from(updatedFormData.validationErrors);
    if (event.barcode.isNotEmpty && event.barcode.length < 8) {
      errors['barcode'] = 'Barcode must be at least 8 characters';
    } else {
      errors.remove('barcode');
    }

    emit(
      currentData.copyWith(
        formData: updatedFormData.copyWith(validationErrors: errors),
      ),
    );
  }

  void _onPriceChanged(
    PriceChanged event,
    Emitter<ProductRegistrationState> emit,
  ) {
    final currentData = _getCurrentDataOrInitial();
    final price = double.tryParse(event.price);

    // Update price value
    final updatedFormData = currentData.formData.copyWith(price: price);

    // Validate price field
    final errors = Map<String, String>.from(updatedFormData.validationErrors);
    if (price == null || price <= 0) {
      errors['price'] = 'Please enter a valid price';
    } else {
      errors.remove('price');
    }

    emit(
      currentData.copyWith(
        formData: updatedFormData.copyWith(validationErrors: errors),
      ),
    );
  }

  // 🔥 Image handling - simplified
  Future<void> _onImageSelected(
    ImageSelected event,
    Emitter<ProductRegistrationState> emit,
  ) async {
    final currentData = _getCurrentDataOrInitial();

    // Store the state before upload to restore it properly
    final stateBeforeUpload = currentData.copyWith(
      formData: currentData.formData.copyWith(
        selectedImages: [
          ...currentData.formData.selectedImages,
          event.imageFile,
        ],
      ),
    );

    emit(stateBeforeUpload);

    // Upload image
    emit(const ProductRegistrationLoading(message: 'Uploading image...'));

    final result = await uploadImage(event.imageFile);
    result.fold(
      (failure) {
        // Restore to the state before upload on error
        emit(stateBeforeUpload);
        emit(ProductRegistrationImageUploadError(failure.toString()));
      },
      (imageUrl) {
        // Update with uploaded URL
        emit(
          stateBeforeUpload.copyWith(
            formData: stateBeforeUpload.formData.copyWith(
              uploadedImageUrls: [
                ...stateBeforeUpload.formData.uploadedImageUrls,
                imageUrl,
              ],
            ),
          ),
        );
      },
    );
  }

  void _onImageRemoved(
    ImageRemoved event,
    Emitter<ProductRegistrationState> emit,
  ) {
    final currentData = _getCurrentDataOrInitial();
    final updatedImages = List<File>.from(currentData.formData.selectedImages)
      ..removeAt(event.index);
    final updatedUrls = List<String>.from(
      currentData.formData.uploadedImageUrls,
    )..removeAt(event.index);

    emit(
      currentData.copyWith(
        formData: currentData.formData.copyWith(
          selectedImages: updatedImages,
          uploadedImageUrls: updatedUrls,
        ),
      ),
    );
  }

  // 🔥 Form submission - clean and simple
  Future<void> _onSubmitForm(
    SubmitForm event,
    Emitter<ProductRegistrationState> emit,
  ) async {
    final currentData = _getCurrentDataOrInitial();

    // Comprehensive validation before submit
    final validationErrors = <String, String>{};

    // Name validation
    if (currentData.formData.name.trim().isEmpty) {
      validationErrors['name'] = 'Product name is required';
    } else if (currentData.formData.name.trim().length < 3) {
      validationErrors['name'] = 'Product name must be at least 3 characters';
    }

    // Description validation
    if (currentData.formData.description.trim().isEmpty) {
      validationErrors['description'] = 'Product description is required';
    } else if (currentData.formData.description.trim().length < 10) {
      validationErrors['description'] =
          'Product description must be at least 10 characters';
    }

    // Price validation
    if (currentData.formData.price == null ||
        currentData.formData.price! <= 0) {
      validationErrors['price'] = 'Please enter a valid price';
    }

    // Category validation
    if (currentData.selectedCategory == null) {
      validationErrors['category'] = 'Please select a category';
    }

    // Supplier validation
    if (currentData.selectedSupplier == null) {
      validationErrors['supplier'] = 'Please select a supplier';
    }

    // If there are validation errors, emit them
    if (validationErrors.isNotEmpty) {
      emit(
        currentData.copyWith(
          formData: currentData.formData.copyWith(
            validationErrors: validationErrors,
          ),
        ),
      );
      return;
    }

    emit(currentData.copyWith(isSubmitting: true));

    final product = domain.Product(
      name: currentData.formData.name,
      description: currentData.formData.description,
      barcode: currentData.formData.barcode,
      categoryId: currentData.selectedCategory!.id,
      supplierId: currentData.selectedSupplier!.id,
      price: currentData.formData.price!,
      weight: currentData.formData.weight,
      unit: currentData.formData.unit,
      expiryDate: currentData.formData.expiryDate,
      imageUrls: currentData.formData.uploadedImageUrls,
      isActive: true,
      metadata: {
        'tax_rate': currentData.selectedCategory?.taxRate,
        'supplier_discount': currentData.selectedSupplier?.discountRate,
      },
    );

    final result = await createProduct(product);
    result.fold(
      (failure) => emit(ProductRegistrationSubmissionError(failure.toString())),
      (createdProduct) => emit(ProductRegistrationSuccess(createdProduct)),
    );
  }

  void _onResetForm(ResetForm event, Emitter<ProductRegistrationState> emit) {
    final currentData = _getCurrentDataOrInitial();

    // Reset form data but keep categories/suppliers
    emit(
      currentData.copyWith(
        formData: const ProductFormData(
          name: '',
          description: '',
          barcode: '',
          selectedImages: [],
          uploadedImageUrls: [],
          validationErrors: {},
        ),
        selectedCategory: null,
        selectedSupplier: null,
      ),
    );
  }
}
