import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/supplier.dart';
import '../bloc/product_registration_bloc.dart';
import '../bloc/product_registration_event.dart';
import '../bloc/product_registration_state.dart';
import '../widgets/custom_form_field.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/product_image_picker.dart';

class ProductRegistrationPage extends StatelessWidget {
  const ProductRegistrationPage({Key? key}) : super(key: key);

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Registration'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<ProductRegistrationBloc, ProductRegistrationState>(
        listener: (context, state) {
          // 🔥 Type-safe pattern matching with sealed classes!
          switch (state) {
            case ProductRegistrationSuccess(:final createdProduct):
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Product "${createdProduct.name}" created successfully!',
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 3),
                ),
              );
              Navigator.pop(context);

            case ProductRegistrationCategoriesLoadError(:final message):
              _showErrorSnackBar(
                context,
                'Failed to load categories: $message',
              );

            case ProductRegistrationSuppliersLoadError(:final message):
              _showErrorSnackBar(context, 'Failed to load suppliers: $message');

            case ProductRegistrationImageUploadError(:final message):
              _showErrorSnackBar(context, 'Image upload failed: $message');

            case ProductRegistrationSubmissionError(:final message):
              _showErrorSnackBar(context, 'Failed to create product: $message');

            case ProductRegistrationValidationError(:final message):
              _showErrorSnackBar(context, 'Validation failed: $message');

            case ProductRegistrationInitial():
              // Load categories on initial state
              context.read<ProductRegistrationBloc>().add(
                const LoadCategories(),
              );

            // No action needed for data and loading states
            case ProductRegistrationData() || ProductRegistrationLoading():
              break;
          }
        },
        child: BlocBuilder<ProductRegistrationBloc, ProductRegistrationState>(
          builder: (context, state) {
            return switch (state) {
              ProductRegistrationInitial() => _buildInitialView(context),
              ProductRegistrationLoading(:final message) => _buildLoadingView(
                message,
              ),
              ProductRegistrationData() => const ProductRegistrationForm(),
              ProductRegistrationError(:final message) => _buildErrorView(
                context,
                message,
              ),
              ProductRegistrationSuccess() => _buildSuccessView(),
            };
          },
        ),
      ),
    );
  }

  Widget _buildInitialView(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('Initializing Product Registration...'),
          SizedBox(height: 16),
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildLoadingView(String? message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message, style: const TextStyle(fontSize: 16)),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: $message', textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () =>
                context.read<ProductRegistrationBloc>().add(const ResetForm()),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 64, color: Colors.green),
          SizedBox(height: 16),
          Text('Product created successfully!', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}

// 🔥 Clean form component with BlocBuilder pattern
class ProductRegistrationForm extends StatelessWidget {
  const ProductRegistrationForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Basic Information Section
          _buildSectionHeader('Basic Information'),

          const ProductNameField(),
          const ProductDescriptionField(),
          const ProductBarcodeField(),

          const SizedBox(height: 24),

          // Category & Supplier Section
          _buildSectionHeader('Category & Supplier'),

          const CategoryDropdown(),
          const CategoryInfoWidget(),
          const SupplierDropdown(),
          const SupplierInfoWidget(),

          const SizedBox(height: 24),

          // Pricing & Details Section
          _buildSectionHeader('Pricing & Details'),

          const ProductPriceField(),

          const SizedBox(height: 24),

          // Images Section
          _buildSectionHeader('Product Images'),
          const ProductImagesWidget(),

          const SizedBox(height: 32),

          // Action Buttons
          const SubmitButton(),
          const SizedBox(height: 16),
          const ResetButton(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}

// 🔥 Clean field widgets with BlocBuilder pattern
class ProductNameField extends StatelessWidget {
  const ProductNameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductRegistrationBloc, ProductRegistrationState>(
      buildWhen: (previous, current) {
        // Only rebuild for data states when THIS field's data changes
        if (previous is ProductRegistrationData &&
            current is ProductRegistrationData) {
          final nameChanged = previous.formData.name != current.formData.name;
          final nameErrorChanged =
              previous.formData.validationErrors['name'] !=
              current.formData.validationErrors['name'];
          return nameChanged || nameErrorChanged;
        }
        return previous.runtimeType != current.runtimeType;
      },
      builder: (context, state) {
        return switch (state) {
          ProductRegistrationData(:final formData) => CustomFormField(
            label: 'Product Name',
            value: formData.name,
            onChanged: (value) =>
                context.read<ProductRegistrationBloc>().add(NameChanged(value)),
            hintText: 'Enter product name',
            errorText: formData.validationErrors['name'],
            required: true,
          ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}

class ProductDescriptionField extends StatelessWidget {
  const ProductDescriptionField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductRegistrationBloc, ProductRegistrationState>(
      buildWhen: (previous, current) {
        if (previous is ProductRegistrationData &&
            current is ProductRegistrationData) {
          final descChanged =
              previous.formData.description != current.formData.description;
          final descErrorChanged =
              previous.formData.validationErrors['description'] !=
              current.formData.validationErrors['description'];
          return descChanged || descErrorChanged;
        }
        return previous.runtimeType != current.runtimeType;
      },
      builder: (context, state) {
        return switch (state) {
          ProductRegistrationData(:final formData) => CustomFormField(
            label: 'Description',
            value: formData.description,
            onChanged: (value) => context.read<ProductRegistrationBloc>().add(
              DescriptionChanged(value),
            ),
            hintText: 'Enter product description',
            errorText: formData.validationErrors['description'],
            maxLines: 3,
            required: true,
          ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}

class ProductBarcodeField extends StatelessWidget {
  const ProductBarcodeField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductRegistrationBloc, ProductRegistrationState>(
      buildWhen: (previous, current) {
        if (previous is ProductRegistrationData &&
            current is ProductRegistrationData) {
          final barcodeChanged =
              previous.formData.barcode != current.formData.barcode;
          final barcodeErrorChanged =
              previous.formData.validationErrors['barcode'] !=
              current.formData.validationErrors['barcode'];
          return barcodeChanged || barcodeErrorChanged;
        }
        return previous.runtimeType != current.runtimeType;
      },
      builder: (context, state) {
        return switch (state) {
          ProductRegistrationData(:final formData) => CustomFormField(
            label: 'Barcode',
            value: formData.barcode,
            onChanged: (value) => context.read<ProductRegistrationBloc>().add(
              BarcodeChanged(value),
            ),
            hintText: 'Enter or scan barcode',
            errorText: formData.validationErrors['barcode'],
            required: true,
          ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}

class CategoryDropdown extends StatelessWidget {
  const CategoryDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductRegistrationBloc, ProductRegistrationState>(
      buildWhen: (previous, current) {
        if (previous is ProductRegistrationData &&
            current is ProductRegistrationData) {
          final categoryChanged =
              previous.selectedCategory != current.selectedCategory;
          final categoriesChanged = previous.categories != current.categories;
          final categoryErrorChanged =
              previous.formData.validationErrors['category'] !=
              current.formData.validationErrors['category'];
          return categoryChanged || categoriesChanged || categoryErrorChanged;
        }
        return previous.runtimeType != current.runtimeType;
      },
      builder: (context, state) {
        return switch (state) {
          ProductRegistrationData(
            :final selectedCategory,
            :final categories,
            :final formData,
          ) =>
            CustomDropdown<Category>(
              label: 'Category',
              value: selectedCategory,
              items: categories,
              onChanged: (category) {
                if (category != null) {
                  context.read<ProductRegistrationBloc>().add(
                    CategorySelected(category.id),
                  );
                }
              },
              itemLabel: (category) => category.name,
              hintText: 'Select a category',
              errorText: formData.validationErrors['category'],
              required: true,
            ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}

class CategoryInfoWidget extends StatelessWidget {
  const CategoryInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductRegistrationBloc, ProductRegistrationState>(
      buildWhen: (previous, current) {
        if (previous is ProductRegistrationData &&
            current is ProductRegistrationData) {
          return previous.selectedCategory != current.selectedCategory;
        }
        return previous.runtimeType != current.runtimeType;
      },
      builder: (context, state) {
        return switch (state) {
          ProductRegistrationData(:final selectedCategory)
              when selectedCategory != null =>
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category Requirements:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  if (selectedCategory.requiresWeight)
                    const Text('• Weight is required'),
                  if (selectedCategory.requiresExpiry)
                    const Text('• Expiry date is required'),
                  Text('• Allowed units: ${state.allowedUnits.join(", ")}'),
                  if (state.taxRate != null)
                    Text(
                      '• Tax rate: ${(state.taxRate! * 100).toStringAsFixed(1)}%',
                    ),
                ],
              ),
            ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}

class SupplierDropdown extends StatelessWidget {
  const SupplierDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductRegistrationBloc, ProductRegistrationState>(
      buildWhen: (previous, current) {
        if (previous is ProductRegistrationData &&
            current is ProductRegistrationData) {
          return previous.selectedSupplier != current.selectedSupplier ||
              previous.suppliers != current.suppliers ||
              previous.canSelectSupplier != current.canSelectSupplier ||
              previous.formData.validationErrors['supplier'] !=
                  current.formData.validationErrors['supplier'];
        }
        return previous.runtimeType != current.runtimeType;
      },
      builder: (context, state) {
        return switch (state) {
          ProductRegistrationData(
            :final selectedSupplier,
            :final suppliers,
            :final formData,
            :final canSelectSupplier,
          ) =>
            CustomDropdown<Supplier>(
              label: 'Supplier',
              value: selectedSupplier,
              items: suppliers,
              onChanged: (supplier) {
                if (supplier != null) {
                  context.read<ProductRegistrationBloc>().add(
                    SupplierSelected(supplier.id),
                  );
                }
              },
              itemLabel: (supplier) => supplier.name,
              hintText: canSelectSupplier
                  ? 'Select a supplier'
                  : 'Select category first',
              errorText: formData.validationErrors['supplier'],
              required: true,
            ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}

class SupplierInfoWidget extends StatelessWidget {
  const SupplierInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductRegistrationBloc, ProductRegistrationState>(
      buildWhen: (previous, current) {
        if (previous is ProductRegistrationData &&
            current is ProductRegistrationData) {
          return previous.selectedSupplier != current.selectedSupplier;
        }
        return previous.runtimeType != current.runtimeType;
      },
      builder: (context, state) {
        return switch (state) {
          ProductRegistrationData(:final selectedSupplier)
              when selectedSupplier != null =>
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Supplier Information:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text('• ${selectedSupplier.name}'),
                  Text('• ${selectedSupplier.email}'),
                  Text('• ${selectedSupplier.phone}'),
                  if (state.supplierDiscountRate != null)
                    Text(
                      '• Discount: ${(state.supplierDiscountRate! * 100).toStringAsFixed(1)}%',
                    ),
                ],
              ),
            ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}

class ProductPriceField extends StatelessWidget {
  const ProductPriceField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductRegistrationBloc, ProductRegistrationState>(
      buildWhen: (previous, current) {
        if (previous is ProductRegistrationData &&
            current is ProductRegistrationData) {
          return previous.formData.price != current.formData.price ||
              previous.formData.validationErrors['price'] !=
                  current.formData.validationErrors['price'];
        }
        return previous.runtimeType != current.runtimeType;
      },
      builder: (context, state) {
        return switch (state) {
          ProductRegistrationData(:final formData) => CustomFormField(
            label: 'Price',
            value: formData.price?.toString() ?? '',
            onChanged: (value) => context.read<ProductRegistrationBloc>().add(
              PriceChanged(value),
            ),
            hintText: 'Enter price',
            errorText: formData.validationErrors['price'],
            keyboardType: TextInputType.number,
            required: true,
            suffix: const Text('IDR'),
          ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}

class ProductImagesWidget extends StatelessWidget {
  const ProductImagesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductRegistrationBloc, ProductRegistrationState>(
      buildWhen: (previous, current) {
        if (previous is ProductRegistrationData &&
            current is ProductRegistrationData) {
          return previous.formData.selectedImages !=
              current.formData.selectedImages;
        }
        return previous.runtimeType != current.runtimeType;
      },
      builder: (context, state) {
        return switch (state) {
          ProductRegistrationData(:final formData) => ProductImagePicker(
            selectedImages: formData.selectedImages,
            onImageSelected: (image) => context
                .read<ProductRegistrationBloc>()
                .add(ImageSelected(image)),
            onImageRemoved: (index) => context
                .read<ProductRegistrationBloc>()
                .add(ImageRemoved(index)),
          ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductRegistrationBloc, ProductRegistrationState>(
      buildWhen: (previous, current) {
        if (previous is ProductRegistrationData &&
            current is ProductRegistrationData) {
          return previous.canSubmit != current.canSubmit ||
              previous.isSubmitting != current.isSubmitting;
        }
        return previous.runtimeType != current.runtimeType;
      },
      builder: (context, state) {
        return switch (state) {
          ProductRegistrationData(:final canSubmit, :final isSubmitting) =>
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: canSubmit
                    ? () => context.read<ProductRegistrationBloc>().add(
                        const SubmitForm(),
                      )
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isSubmitting
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('Creating Product...'),
                        ],
                      )
                    : const Text(
                        'Create Product',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}

class ResetButton extends StatelessWidget {
  const ResetButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: OutlinedButton(
        onPressed: () =>
            context.read<ProductRegistrationBloc>().add(const ResetForm()),
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).primaryColor,
          side: BorderSide(color: Theme.of(context).primaryColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Reset Form', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
