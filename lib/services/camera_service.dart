import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

class CameraService {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;

  CameraController? get controller => _controller;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    // Request camera permission
    final cameraPermission = await Permission.camera.request();
    if (cameraPermission.isDenied) {
      throw Exception('Camera permission denied');
    }

    try {
      // Get available cameras
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        throw Exception('No cameras available');
      }

      // Initialize camera controller with the back camera
      final backCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras.first,
      );

      _controller = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      // Initialize the controller
      await _controller!.initialize();
      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
      rethrow;
    }
  }

  Future<String> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      throw Exception('Camera controller not initialized');
    }

    try {
      // Take the picture
      final XFile image = await _controller!.takePicture();

      // Save image to app directory for better management
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName =
          'plant_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String filePath = path.join(appDir.path, fileName);

      // Copy taken image to application directory
      await File(image.path).copy(filePath);

      return filePath;
    } catch (e) {
      throw Exception('Failed to take picture: ${e.toString()}');
    }
  }

  Future<void> dispose() async {
    if (_controller != null) {
      await _controller!.dispose();
      _controller = null;
      _isInitialized = false;
    }
  }

  Future<void> toggleFlash() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    if (_controller!.value.flashMode == FlashMode.off) {
      await _controller!.setFlashMode(FlashMode.torch);
    } else {
      await _controller!.setFlashMode(FlashMode.off);
    }
  }
}
