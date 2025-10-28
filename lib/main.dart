import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plantyze/screens/main_navigation_screen.dart';
import 'package:plantyze/services/theme_service.dart';
import 'package:plantyze/services/garden_service.dart';
import 'package:plantyze/services/camera_service.dart';
import 'package:plantyze/services/plant_api_service.dart';
import 'package:plantyze/config/theme_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  await dotenv.load(fileName: ".env");

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const PlantyzeApp());
}

class PlantyzeApp extends StatefulWidget {
  const PlantyzeApp({super.key});

  @override
  State<PlantyzeApp> createState() => _PlantyzeAppState();
}

class _PlantyzeAppState extends State<PlantyzeApp> {
  late ThemeService _themeService;
  late GardenService _gardenService;
  late CameraService _cameraService;
  late PlantApiService _plantApiService;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    _themeService = ThemeService();
    _gardenService = GardenService();
    _cameraService = CameraService();
    _plantApiService = PlantApiService();
    
    // Initialize services that need async initialization
    await Future.wait([
      _themeService.initialize(),
      _gardenService.initialize(),
    ]);
    
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    // Clean up camera service when app is disposed
    _cameraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_florist,
                  size: 64,
                  color: Colors.green[600],
                ),
                const SizedBox(height: 16),
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                const Text('Loading Plantyze...'),
              ],
            ),
          ),
        ),
      );
    }

    return ListenableBuilder(
      listenable: _themeService,
      builder: (context, child) {
        return MaterialApp(
          title: 'Plantyze',
          debugShowCheckedModeBanner: false,
          theme: ThemeConfig.lightTheme,
          darkTheme: ThemeConfig.darkTheme,
          themeMode: _themeService.materialThemeMode,
          home: MainNavigationScreen(
            themeService: _themeService,
            gardenService: _gardenService,
            cameraService: _cameraService,
            plantApiService: _plantApiService,
          ),
        );
      },
    );
  }
}
