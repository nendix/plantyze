import 'package:flutter/material.dart';
import 'package:plantyze/services/camera_service.dart';
import 'package:plantyze/services/plant_api_service.dart';
import 'package:plantyze/screens/result_screen.dart';
import 'package:plantyze/utils/image_utils.dart';
import 'package:plantyze/widgets/camera_preview_widget.dart';
import 'package:plantyze/widgets/loading_indicator.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  final CameraService _cameraService = CameraService();
  final PlantApiService _plantApiService = PlantApiService();
  bool _isInitialized = false;
  bool _isCapturing = false;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      await _cameraService.initialize();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      _showErrorDialog('Camera initialization failed: ${e.toString()}');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle changes
    if (!_isInitialized || _cameraService.controller == null) return;

    if (state == AppLifecycleState.inactive) {
      _cameraService.dispose();
      _isInitialized = false;
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraService.dispose();
    super.dispose();
  }

  Future<void> _toggleFlash() async {
    await _cameraService.toggleFlash();
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
  }

  Future<void> _takePicture() async {
    if (_isCapturing) return;

    setState(() {
      _isCapturing = true;
    });

    try {
      // Take the picture
      final imagePath = await _cameraService.takePicture();

      // Optimize the image for API
      final optimizedImagePath = await ImageUtils.optimizeImage(imagePath);

      // Identify the plant
      final result = await _plantApiService.identifyPlant(optimizedImagePath);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ResultScreen(result: result)),
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Error: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Go back to previous screen
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera Preview
            if (_isInitialized && _cameraService.controller != null)
              CameraPreviewWidget(controller: _cameraService.controller!),

            // UI Controls
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
                iconSize: 28,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),

            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
                color: Colors.white,
                iconSize: 28,
                onPressed: _isInitialized ? _toggleFlash : null,
              ),
            ),

            // Capture Button
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _isInitialized && !_isCapturing ? _takePicture : null,
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child:
                        _isCapturing
                            ? const CircularProgressIndicator(
                              color: Colors.green,
                            )
                            : const Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: Colors.green,
                            ),
                  ),
                ),
              ),
            ),

            // Focus helper text
            Positioned(
              bottom: 140,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Focus on the plant',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            // Loading overlay
            if (!_isInitialized)
              Container(
                color: Colors.black,
                child: const Center(
                  child: LoadingIndicator(message: 'Initializing camera...'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
