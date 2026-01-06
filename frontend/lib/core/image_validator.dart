import 'dart:io';
import 'package:flutter/material.dart';

class ImageValidationResult {
  final bool isValid;
  final String? errorMessage;
  final IconData? errorIcon;

  ImageValidationResult({
    required this.isValid,
    this.errorMessage,
    this.errorIcon,
  });

  static ImageValidationResult success() {
    return ImageValidationResult(isValid: true);
  }

  static ImageValidationResult error(String message, IconData icon) {
    return ImageValidationResult(
      isValid: false,
      errorMessage: message,
      errorIcon: icon,
    );
  }
}

class ImageValidator {
  // Max 5 MB
  static const int maxSizeInBytes = 5 * 1024 * 1024;
  
  // Min dimensions
  static const int minWidth = 200;
  static const int minHeight = 200;
  
  // Max dimensions (untuk hindari file terlalu besar)
  static const int maxWidth = 4000;
  static const int maxHeight = 4000;

  // Allowed extensions
  static const List<String> allowedExtensions = [
    'jpg',
    'jpeg',
    'png',
  ];

  /// Validasi format file berdasarkan extension
  static ImageValidationResult validateFormat(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    
    if (!allowedExtensions.contains(extension)) {
      return ImageValidationResult.error(
        'Format tidak didukung!\nHanya JPG atau PNG',
        Icons.image_not_supported_rounded,
      );
    }
    
    return ImageValidationResult.success();
  }

  /// Validasi ukuran file
  static ImageValidationResult validateSize(File file) {
    final fileSize = file.lengthSync();
    
    if (fileSize > maxSizeInBytes) {
      final sizeMB = (fileSize / (1024 * 1024)).toStringAsFixed(1);
      return ImageValidationResult.error(
        'Ukuran terlalu besar!\nMaksimal 5 MB (file: $sizeMB MB)',
        Icons.sd_storage_rounded,
      );
    }
    
    if (fileSize < 1024) {
      return ImageValidationResult.error(
        'File terlalu kecil!\nMinimal 1 KB',
        Icons.broken_image_rounded,
      );
    }
    
    return ImageValidationResult.success();
  }

  /// Validasi dimensi gambar (async karena harus decode image)
  static Future<ImageValidationResult> validateDimensions(File file) async {
    try {
      final decodedImage = await decodeImageFromList(file.readAsBytesSync());
      
      final width = decodedImage.width;
      final height = decodedImage.height;
      
      if (width < minWidth || height < minHeight) {
        return ImageValidationResult.error(
          'Resolusi terlalu kecil!\nMinimal ${minWidth}x$minHeight px (file: ${width}x$height px)',
          Icons.photo_size_select_small_rounded,
        );
      }
      
      if (width > maxWidth || height > maxHeight) {
        return ImageValidationResult.error(
          'Resolusi terlalu besar!\nMaksimal ${maxWidth}x$maxHeight px (file: ${width}x$height px)',
          Icons.photo_size_select_large_rounded,
        );
      }
      
      return ImageValidationResult.success();
    } catch (e) {
      return ImageValidationResult.error(
        'Gagal membaca gambar!\nFile mungkin rusak atau tidak valid',
        Icons.error_outline_rounded,
      );
    }
  }

  /// Validasi lengkap (panggil semua validasi)
  static Future<ImageValidationResult> validateImage(File file) async {
    // 1. Validasi format
    final formatResult = validateFormat(file.path);
    if (!formatResult.isValid) return formatResult;

    // 2. Validasi ukuran file
    final sizeResult = validateSize(file);
    if (!sizeResult.isValid) return sizeResult;

    // 3. Validasi dimensi
    final dimensionResult = await validateDimensions(file);
    if (!dimensionResult.isValid) return dimensionResult;

    return ImageValidationResult.success();
  }

  /// Helper untuk format ukuran file yang user-friendly
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
