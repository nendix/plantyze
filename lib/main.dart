import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plantyze/screens/base_screen.dart';
import 'package:plantyze/screens/garden_screen.dart';
import 'package:plantyze/screens/camera_screen.dart';
import 'package:plantyze/screens/settings_screen.dart';
import 'package:plantyze/services/theme_service.dart';
import 'package:plantyze/services/garden_service.dart';
import 'package:plantyze/services/camera_service.dart';
import 'package:plantyze/services/plant_api_service.dart';
import 'package:plantyze/services/connectivity_service.dart';
import 'package:plantyze/config/theme_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final themeService = ThemeService();
  final gardenService = GardenService();

  await Future.wait([
    themeService.initialize(),
    gardenService.initialize(),
  ]);

  final cameraService = CameraService();
  final connectivityService = ConnectivityService();
  final plantApiService = PlantApiService(connectivityService: connectivityService);

  runApp(PlantyzeApp(
    themeService: themeService,
    gardenService: gardenService,
    cameraService: cameraService,
    plantApiService: plantApiService,
  ));
}

class PlantyzeApp extends StatefulWidget {
  final ThemeService themeService;
  final GardenService gardenService;
  final CameraService cameraService;
  final PlantApiService plantApiService;

  const PlantyzeApp({
    super.key,
    required this.themeService,
    required this.gardenService,
    required this.cameraService,
    required this.plantApiService,
  });

  @override
  State<PlantyzeApp> createState() => _PlantyzeAppState();
}

class _PlantyzeAppState extends State<PlantyzeApp> {
  @override
  void dispose() {
    widget.cameraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.themeService,
      builder: (context, child) {
        return MaterialApp(
          title: 'Plantyze',
          debugShowCheckedModeBanner: false,
          theme: ThemeConfig.lightTheme,
          darkTheme: ThemeConfig.darkTheme,
          themeMode: widget.themeService.materialThemeMode,
          home: BaseScreen(
            screens: [
              GardenScreen(
                gardenService: widget.gardenService,
              ),
              CameraScreen(
                gardenService: widget.gardenService,
                cameraService: widget.cameraService,
                plantApiService: widget.plantApiService,
              ),
              SettingsScreen(themeService: widget.themeService),
            ],
          ),
        );
      },
    );
  }
}
