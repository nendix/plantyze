import 'package:flutter/material.dart';
import 'package:plantyze/screens/camera_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantyze/services/plant_api_service.dart';
import 'package:plantyze/screens/result_screen.dart';
import 'package:plantyze/utils/image_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PlantApiService _plantApiService = PlantApiService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkApiKey();
  }

  void _checkApiKey() {
    final apiKey = dotenv.env['PLANTNET_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showApiKeyDialog();
      });
    }
  }

  void _showApiKeyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('API Key Required'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'A Pl@ntNet API key is required to use this app.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  '1. Visit https://my.plantnet.org/',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  '2. Create an account and request an API key',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  '3. Add the key to your .env file as PLANTNET_API_KEY=your_key',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  Future<void> _openCamera() async {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const CameraScreen()));
  }

  Future<void> _pickImageFromGallery() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        // Optimize the image for API
        final optimizedImagePath = await ImageUtils.optimizeImage(image.path);

        // Identify the plant
        final result = await _plantApiService.identifyPlant(optimizedImagePath);

        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ResultScreen(result: result),
            ),
          );
        }
      }
    } catch (e) {
      _showErrorDialog('Error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
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
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plantyze',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFE8F5E9), Colors.white],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Icon(
                      Icons.local_florist,
                      size: 120,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Discover Plants Around You',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Take a photo or choose from gallery to identify plants instantly',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _openCamera,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text(
                        'Take Photo',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _isLoading ? null : _pickImageFromGallery,
                      icon: const Icon(Icons.photo_library),
                      label: const Text(
                        'Choose from Gallery',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                        side: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
