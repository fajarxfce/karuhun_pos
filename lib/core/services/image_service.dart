import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  /// Pick image from camera
  Future<File?> pickFromCamera() async {
    try {
      // Check camera permission
      final cameraPermission = await Permission.camera.request();
      if (!cameraPermission.isGranted) {
        throw Exception('Camera permission denied');
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      return image != null ? File(image.path) : null;
    } catch (e) {
      throw Exception('Failed to pick image from camera: $e');
    }
  }

  /// Pick image from gallery
  Future<File?> pickFromGallery() async {
    try {
      // Check gallery permission
      final galleryPermission = await Permission.photos.request();
      if (!galleryPermission.isGranted) {
        // Fallback to storage permission for Android
        final storagePermission = await Permission.storage.request();
        if (!storagePermission.isGranted) {
          throw Exception('Gallery permission denied');
        }
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      return image != null ? File(image.path) : null;
    } catch (e) {
      throw Exception('Failed to pick image from gallery: $e');
    }
  }

  /// Pick multiple images from gallery
  Future<List<File>> pickMultipleFromGallery({int maxImages = 5}) async {
    try {
      // Check gallery permission
      final galleryPermission = await Permission.photos.request();
      if (!galleryPermission.isGranted) {
        // Fallback to storage permission for Android
        final storagePermission = await Permission.storage.request();
        if (!storagePermission.isGranted) {
          throw Exception('Gallery permission denied');
        }
      }

      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      // Limit to maxImages
      final limitedImages = images.take(maxImages).toList();

      return limitedImages.map((xfile) => File(xfile.path)).toList();
    } catch (e) {
      throw Exception('Failed to pick multiple images: $e');
    }
  }

  /// Validate image file
  bool isValidImage(File file) {
    try {
      final extension = file.path.toLowerCase();
      return extension.endsWith('.jpg') ||
          extension.endsWith('.jpeg') ||
          extension.endsWith('.png') ||
          extension.endsWith('.gif') ||
          extension.endsWith('.webp');
    } catch (e) {
      return false;
    }
  }

  /// Get image file size in MB
  double getImageSizeInMB(File file) {
    try {
      final bytes = file.lengthSync();
      return bytes / (1024 * 1024);
    } catch (e) {
      return 0;
    }
  }

  /// Check if image size is within limit
  bool isImageSizeValid(File file, {double maxSizeMB = 5.0}) {
    final sizeInMB = getImageSizeInMB(file);
    return sizeInMB <= maxSizeMB;
  }
}
