import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/services/image_service.dart';

class ProductImagePicker extends StatelessWidget {
  final List<File> selectedImages;
  final Function(File) onImageSelected;
  final Function(int) onImageRemoved;
  final bool isLoading;
  final int maxImages;
  final double maxSizeMB;

  const ProductImagePicker({
    Key? key,
    required this.selectedImages,
    required this.onImageSelected,
    required this.onImageRemoved,
    this.isLoading = false,
    this.maxImages = 5,
    this.maxSizeMB = 5.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Product Images', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),

        // Image grid
        if (selectedImages.isNotEmpty)
          Container(
            height: 120,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: selectedImages.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          selectedImages[index],
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                                size: 40,
                              ),
                            );
                          },
                        ),
                      ),
                      // Image overlay for better button visibility
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.center,
                            colors: [
                              Colors.black.withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      // Remove button
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => onImageRemoved(index),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                      // Image index indicator
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

        // Add image button
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: isLoading
                  ? null
                  : () => _showImageSourceDialog(context),
              icon: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.add_photo_alternate),
              label: Text(isLoading ? 'Uploading...' : 'Add Image'),
            ),
            const SizedBox(width: 8),
            Text(
              '${selectedImages.length}/$maxImages images • Max ${maxSizeMB}MB each',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    if (selectedImages.length >= maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Maximum $maxImages images allowed')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Image Source',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Photo Library'),
                      subtitle: const Text('Choose from existing photos'),
                      onTap: () {
                        Navigator.pop(context);
                        _pickFromGallery(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo_camera),
                      title: const Text('Camera'),
                      subtitle: const Text('Take a new photo'),
                      onTap: () {
                        Navigator.pop(context);
                        _pickFromCamera(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo_library_outlined),
                      title: const Text('Multiple Photos'),
                      subtitle: Text(
                        'Select up to ${maxImages - selectedImages.length} photos',
                      ),
                      enabled: selectedImages.length < maxImages,
                      onTap: selectedImages.length < maxImages
                          ? () {
                              Navigator.pop(context);
                              _pickMultipleFromGallery(context);
                            }
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickFromCamera(BuildContext context) async {
    try {
      final imageService = ImageService();
      final File? image = await imageService.pickFromCamera();

      if (image != null) {
        if (!imageService.isValidImage(image)) {
          _showErrorSnackBar(
            context,
            'Invalid image format. Please select JPG, PNG, or WebP.',
          );
          return;
        }

        if (!imageService.isImageSizeValid(image, maxSizeMB: maxSizeMB)) {
          _showErrorSnackBar(
            context,
            'Image size too large. Maximum size is ${maxSizeMB}MB.',
          );
          return;
        }

        onImageSelected(image);
        _showSuccessSnackBar(context, 'Image added successfully!');
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Failed to take photo: ${e.toString()}');
    }
  }

  Future<void> _pickFromGallery(BuildContext context) async {
    try {
      final imageService = ImageService();
      final File? image = await imageService.pickFromGallery();

      if (image != null) {
        if (!imageService.isValidImage(image)) {
          _showErrorSnackBar(
            context,
            'Invalid image format. Please select JPG, PNG, or WebP.',
          );
          return;
        }

        if (!imageService.isImageSizeValid(image, maxSizeMB: maxSizeMB)) {
          _showErrorSnackBar(
            context,
            'Image size too large. Maximum size is ${maxSizeMB}MB.',
          );
          return;
        }

        onImageSelected(image);
        _showSuccessSnackBar(context, 'Image added successfully!');
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Failed to pick image: ${e.toString()}');
    }
  }

  Future<void> _pickMultipleFromGallery(BuildContext context) async {
    try {
      final imageService = ImageService();
      final remainingSlots = maxImages - selectedImages.length;
      final List<File> images = await imageService.pickMultipleFromGallery(
        maxImages: remainingSlots,
      );

      if (images.isNotEmpty) {
        int addedCount = 0;
        int skippedCount = 0;

        for (final image in images) {
          if (selectedImages.length + addedCount >= maxImages) break;

          if (!imageService.isValidImage(image)) {
            skippedCount++;
            continue;
          }

          if (!imageService.isImageSizeValid(image, maxSizeMB: maxSizeMB)) {
            skippedCount++;
            continue;
          }

          onImageSelected(image);
          addedCount++;
        }

        if (addedCount > 0) {
          _showSuccessSnackBar(
            context,
            '$addedCount image${addedCount > 1 ? 's' : ''} added successfully!',
          );
        }

        if (skippedCount > 0) {
          _showErrorSnackBar(
            context,
            '$skippedCount image${skippedCount > 1 ? 's' : ''} skipped due to invalid format or size.',
          );
        }
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Failed to pick images: ${e.toString()}');
    }
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

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
