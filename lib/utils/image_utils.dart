import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageUtils {
  // Optimize image for API request (resize and compress)
  static Future<String> optimizeImage(String imagePath) async {
    final File imageFile = File(imagePath);
    final Uint8List bytes = await imageFile.readAsBytes();

    // Decode the image
    final img.Image? originalImage = img.decodeImage(bytes);
    if (originalImage == null) {
      throw Exception('Failed to decode image');
    }

    // Resize image to a reasonable size for API (max 1024px width/height)
    img.Image resizedImage = originalImage;
    if (originalImage.width > 1024 || originalImage.height > 1024) {
      int targetWidth, targetHeight;

      if (originalImage.width > originalImage.height) {
        targetWidth = 1024;
        targetHeight =
            (originalImage.height * (1024 / originalImage.width)).round();
      } else {
        targetHeight = 1024;
        targetWidth =
            (originalImage.width * (1024 / originalImage.height)).round();
      }

      resizedImage = img.copyResize(
        originalImage,
        width: targetWidth,
        height: targetHeight,
      );
    }

    // Encode as JPEG with 85% quality
    final Uint8List optimizedBytes = img.encodeJpg(resizedImage, quality: 85);

    // Save the optimized image
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String optimizedFileName = 'optimized_${path.basename(imagePath)}';
    final String optimizedPath = path.join(appDir.path, optimizedFileName);

    await File(optimizedPath).writeAsBytes(optimizedBytes);
    return optimizedPath;
  }

  // Crop image to center focus (for square thumbnails)
  static Future<String> cropToSquare(String imagePath) async {
    final File imageFile = File(imagePath);
    final Uint8List bytes = await imageFile.readAsBytes();

    // Decode the image
    final img.Image? originalImage = img.decodeImage(bytes);
    if (originalImage == null) {
      throw Exception('Failed to decode image');
    }

    // Calculate dimensions for square crop
    final int size =
        originalImage.width < originalImage.height
            ? originalImage.width
            : originalImage.height;

    final int offsetX = (originalImage.width - size) ~/ 2;
    final int offsetY = (originalImage.height - size) ~/ 2;

    // Crop the image to a square
    final img.Image croppedImage = img.copyCrop(
      originalImage,
      x: offsetX,
      y: offsetY,
      width: size,
      height: size,
    );

    // Encode as JPEG
    final Uint8List croppedBytes = img.encodeJpg(croppedImage, quality: 90);

    // Save the cropped image
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String croppedFileName = 'cropped_${path.basename(imagePath)}';
    final String croppedPath = path.join(appDir.path, croppedFileName);

    await File(croppedPath).writeAsBytes(croppedBytes);
    return croppedPath;
  }

  static Future<void> cleanupOptimizedImage(String imagePath) async {
    try {
      final File file = File(imagePath);
      if (await file.exists()) {
        final String fileName = path.basename(imagePath);
        if (fileName.startsWith('optimized_') || fileName.startsWith('cropped_')) {
          await file.delete();
        }
      }
    } catch (e) {
      // Silently ignore cleanup errors
    }
  }

  static Future<void> cleanupAllOptimizedImages() async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final List<FileSystemEntity> files = appDir.listSync();
      
      for (var entity in files) {
        if (entity is File) {
          final String fileName = path.basename(entity.path);
          if (fileName.startsWith('optimized_') || fileName.startsWith('cropped_')) {
            await entity.delete();
          }
        }
      }
    } catch (e) {
      // Silently ignore cleanup errors
    }
  }
}
