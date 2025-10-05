import 'dart:io';

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

class ProductRegistrationPage extends StatefulWidget {
  const ProductRegistrationPage({Key? key}) : super(key: key);

  @override
  State<ProductRegistrationPage> createState() =>
      _ProductRegistrationPageState();
}

class _ProductRegistrationPageState extends State<ProductRegistrationPage> {
  @override
  void initState() {
    super.initState();
    // Load categories when page first loads
    context.read<ProductRegistrationBloc>().add(const LoadCategories());
  }

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
              // Only load categories once when first entering the page
              // Avoid infinite loop by not loading on reset
              break;

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

// 🔥 Clean field widgets with BlocSelector pattern (observes 2 values with Record)
class ProductNameField extends StatelessWidget {
  const ProductNameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      ProductRegistrationBloc,
      ProductRegistrationState,
      (String, String?)
    >(
      selector: (state) {
        if (state is ProductRegistrationData) {
          return (state.formData.name, state.formData.validationErrors['name']);
        }
        return ('', null);
      },
      builder: (context, data) {
        final (name, errorText) = data;

        return CustomFormField(
          label: 'Product Name',
          value: name,
          onChanged: (value) =>
              context.read<ProductRegistrationBloc>().add(NameChanged(value)),
          hintText: 'Enter product name',
          errorText: errorText,
          required: true,
        );
      },
    );
  }
}

class ProductDescriptionField extends StatelessWidget {
  const ProductDescriptionField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      ProductRegistrationBloc,
      ProductRegistrationState,
      (String, String?)
    >(
      selector: (state) {
        if (state is ProductRegistrationData) {
          return (
            state.formData.description,
            state.formData.validationErrors['description'],
          );
        }
        return ('', null);
      },
      builder: (context, data) {
        final (description, errorText) = data;

        return CustomFormField(
          label: 'Description',
          value: description,
          onChanged: (value) => context.read<ProductRegistrationBloc>().add(
            DescriptionChanged(value),
          ),
          hintText: 'Enter product description',
          errorText: errorText,
          maxLines: 3,
          required: true,
        );
      },
    );
  }
}

class ProductBarcodeField extends StatelessWidget {
  const ProductBarcodeField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      ProductRegistrationBloc,
      ProductRegistrationState,
      (String, String?)
    >(
      selector: (state) {
        if (state is ProductRegistrationData) {
          return (
            state.formData.barcode,
            state.formData.validationErrors['barcode'],
          );
        }
        return ('', null);
      },
      builder: (context, data) {
        final (barcode, errorText) = data;

        return CustomFormField(
          label: 'Barcode',
          value: barcode,
          onChanged: (value) => context.read<ProductRegistrationBloc>().add(
            BarcodeChanged(value),
          ),
          hintText: 'Enter or scan barcode',
          errorText: errorText,
          required: true,
        );
      },
    );
  }
}

class CategoryDropdown extends StatelessWidget {
  const CategoryDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      ProductRegistrationBloc,
      ProductRegistrationState,
      (Category?, List<Category>, String?)
    >(
      selector: (state) {
        if (state is ProductRegistrationData) {
          return (
            state.selectedCategory,
            state.categories,
            state.formData.validationErrors['category'],
          );
        }
        return (null, [], null);
      },
      builder: (context, data) {
        final (selectedCategory, categories, errorText) = data;

        return CustomDropdown<Category>(
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
          errorText: errorText,
          required: true,
        );
      },
    );
  }
}

class CategoryInfoWidget extends StatelessWidget {
  const CategoryInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      ProductRegistrationBloc,
      ProductRegistrationState,
      (Category?, List<String>, double?)
    >(
      selector: (state) {
        if (state is ProductRegistrationData) {
          return (state.selectedCategory, state.allowedUnits, state.taxRate);
        }
        return (null, [], null);
      },
      builder: (context, data) {
        final (selectedCategory, allowedUnits, taxRate) = data;

        if (selectedCategory == null) {
          return const SizedBox.shrink();
        }

        return Container(
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
              Text('• Allowed units: ${allowedUnits.join(", ")}'),
              if (taxRate != null)
                Text('• Tax rate: ${(taxRate * 100).toStringAsFixed(1)}%'),
            ],
          ),
        );
      },
    );
  }
}

class SupplierDropdown extends StatelessWidget {
  const SupplierDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      ProductRegistrationBloc,
      ProductRegistrationState,
      (Supplier?, List<Supplier>, bool, String?, bool)
    >(
      selector: (state) {
        if (state is ProductRegistrationData) {
          return (
            state.selectedSupplier,
            state.suppliers,
            state.canSelectSupplier,
            state.formData.validationErrors['supplier'],
            state.isLoadingSuppliers, // 🔥 Add loading flag
          );
        }
        return (null, [], false, null, false);
      },
      builder: (context, data) {
        final (
          selectedSupplier,
          suppliers,
          canSelectSupplier,
          errorText,
          isLoadingSuppliers,
        ) = data;

        // Show loading spinner if loading suppliers
        if (isLoadingSuppliers) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Supplier', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Container(
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text('Loading suppliers...'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        }

        return CustomDropdown<Supplier>(
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
          errorText: errorText,
          required: true,
        );
      },
    );
  }
}

class SupplierInfoWidget extends StatelessWidget {
  const SupplierInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      ProductRegistrationBloc,
      ProductRegistrationState,
      (Supplier?, double?)
    >(
      selector: (state) {
        if (state is ProductRegistrationData) {
          return (state.selectedSupplier, state.supplierDiscountRate);
        }
        return (null, null);
      },
      builder: (context, data) {
        final (selectedSupplier, discountRate) = data;

        if (selectedSupplier == null) {
          return const SizedBox.shrink();
        }

        return Container(
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
              if (discountRate != null)
                Text('• Discount: ${(discountRate * 100).toStringAsFixed(1)}%'),
            ],
          ),
        );
      },
    );
  }
}

class ProductPriceField extends StatelessWidget {
  const ProductPriceField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      ProductRegistrationBloc,
      ProductRegistrationState,
      (String, String?)
    >(
      selector: (state) {
        if (state is ProductRegistrationData) {
          return (
            state.formData.price?.toString() ?? '',
            state.formData.validationErrors['price'],
          );
        }
        return ('', null);
      },
      builder: (context, data) {
        final (price, errorText) = data;

        return CustomFormField(
          label: 'Price',
          value: price,
          onChanged: (value) =>
              context.read<ProductRegistrationBloc>().add(PriceChanged(value)),
          hintText: 'Enter price',
          errorText: errorText,
          keyboardType: TextInputType.number,
          required: true,
          suffix: const Text('IDR'),
        );
      },
    );
  }
}

class ProductImagesWidget extends StatelessWidget {
  const ProductImagesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      ProductRegistrationBloc,
      ProductRegistrationState,
      List<File>
    >(
      selector: (state) {
        if (state is ProductRegistrationData) {
          return state.formData.selectedImages;
        }
        return [];
      },
      builder: (context, selectedImages) {
        return ProductImagePicker(
          selectedImages: selectedImages,
          onImageSelected: (image) =>
              context.read<ProductRegistrationBloc>().add(ImageSelected(image)),
          onImageRemoved: (index) =>
              context.read<ProductRegistrationBloc>().add(ImageRemoved(index)),
        );
      },
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      ProductRegistrationBloc,
      ProductRegistrationState,
      (bool, bool)
    >(
      selector: (state) {
        if (state is ProductRegistrationData) {
          return (state.canSubmit, state.isSubmitting);
        }
        return (false, false);
      },
      builder: (context, data) {
        final (canSubmit, isSubmitting) = data;

        return SizedBox(
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        );
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
