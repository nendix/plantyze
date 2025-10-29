import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantyze/screens/result_screen.dart';
import 'package:plantyze/services/camera_service.dart';
import 'package:plantyze/services/plant_api_service.dart';
import 'package:plantyze/services/garden_service.dart';
import 'package:plantyze/screens/base_screen.dart';
import 'package:plantyze/widgets/camera_preview_widget.dart';

class CameraScreen extends StatefulWidget {
  final GardenService gardenService;
  final CameraService cameraService;
  final PlantApiService plantApiService;

  const CameraScreen({
    super.key,
    required this.gardenService,
    required this.cameraService,
    required this.plantApiService,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  late CameraService _cameraService;
  late PlantApiService _plantApiService;
  bool _isInitialized = false;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    // Use the injected services
    _cameraService = widget.cameraService;
    _plantApiService = widget.plantApiService;
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      await _cameraService.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      // Ensure camera service is disposed if initialization fails
      await _cameraService.dispose();
      if (mounted) {
        setState(() {
          _isInitialized = false;
        });
        _showErrorDialog('Camera initialization failed: ${e.toString()}');
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle changes
    if (state == AppLifecycleState.inactive) {
      // Always dispose when app goes inactive, regardless of initialization state
      _cameraService.dispose();
      if (mounted) {
        setState(() {
          _isInitialized = false;
        });
      }
    } else if (state == AppLifecycleState.resumed && !_isInitialized) {
      // Only reinitialize if we're not already initialized
      _initializeCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Ensure camera service is always disposed, even if not initialized
    _cameraService.dispose();
    super.dispose();
  }

  Future<void> _toggleFlash() async {
    try {
      await _cameraService.toggleFlash();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Failed to toggle flash: ${e.toString()}');
      }
    }
  }

  Future<void> _takePicture() async {
    if (_isCapturing) return;

    setState(() {
      _isCapturing = true;
    });

    try {
      // Take the picture
      final imagePath = await _cameraService.takePicture();

      // Identify the plant
      final result = await _plantApiService.identifyPlant(imagePath);

      if (mounted) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              result: result,
              gardenService: widget.gardenService,
            ),
          ),
        );
        
        if (mounted) {
          await _cameraService.dispose();
          await _initializeCamera();
        }
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
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    setState(() {
      _isCapturing = true;
    });

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        // Identify the plant
        final result = await _plantApiService.identifyPlant(image.path);

        if (mounted) {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ResultScreen(
                result: result,
                gardenService: widget.gardenService,
              ),
            ),
          );
          
          if (mounted) {
            await _cameraService.dispose();
            await _initializeCamera();
          }
        }
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
                onPressed: () => context.navigateBack(),
              ),
            ),

            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: Icon(_cameraService.isFlashOn ? Icons.flash_on : Icons.flash_off),
                color: Colors.white,
                iconSize: 28,
                onPressed: _isInitialized ? _toggleFlash : null,
              ),
            ),

            // Capture Button - Bottom center
            Positioned(
              bottom: 16,
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
                    child: _isCapturing
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

            // Gallery Button - Bottom left
            Positioned(
              bottom: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.photo_library),
                color: Colors.white,
                iconSize: 28,
                onPressed: _isInitialized && !_isCapturing ? _pickImageFromGallery : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
