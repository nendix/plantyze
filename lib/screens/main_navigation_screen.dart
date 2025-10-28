import 'package:flutter/material.dart';
import 'package:plantyze/screens/garden_screen.dart';
import 'package:plantyze/screens/camera_screen.dart';
import 'package:plantyze/screens/settings_screen.dart';
import 'package:plantyze/services/garden_service.dart';
import 'package:plantyze/services/theme_service.dart';
import 'package:plantyze/services/camera_service.dart';
import 'package:plantyze/services/plant_api_service.dart';

class MainNavigationScreen extends StatefulWidget {
  final ThemeService themeService;
  final GardenService gardenService;
  final CameraService cameraService;
  final PlantApiService plantApiService;

  const MainNavigationScreen({
    super.key,
    required this.themeService,
    required this.gardenService,
    required this.cameraService,
    required this.plantApiService,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  int _previousIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: _currentIndex,
    );
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.index != _currentIndex) {
      setState(() {
        _previousIndex = _currentIndex;
        _currentIndex = _tabController.index;
      });
    }
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _previousIndex = _currentIndex;
      _currentIndex = index;
    });
    _tabController.animateTo(index);
  }

  void _returnToPreviousTab() {
    setState(() {
      final temp = _currentIndex;
      _currentIndex = _previousIndex;
      _previousIndex = temp;
    });
    _tabController.animateTo(_currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TabBarView(
          controller: _tabController,
          children: [
            // Garden Tab (index 0)
            GardenScreen(
              gardenService: widget.gardenService,
              onNavigateToCamera: () => _onBottomNavTapped(1),
            ),
            
            // Camera Tab (index 1) - Camera Screen
            CameraScreen(
              gardenService: widget.gardenService,
              cameraService: widget.cameraService,
              plantApiService: widget.plantApiService,
              onNavigateBack: _returnToPreviousTab,
            ),
            
            // Settings Tab (index 2)
            SettingsScreen(themeService: widget.themeService),
          ],
        ),
        bottomNavigationBar: _currentIndex == 1 
            ? null 
            : Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: BottomNavigationBar(
                  currentIndex: _currentIndex,
                  onTap: _onBottomNavTapped,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  selectedItemColor: Theme.of(context).colorScheme.primary,
                  unselectedItemColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  selectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  items: [
                    BottomNavigationBarItem(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: _currentIndex == 0
                            ? BoxDecoration(
                                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(12),
                              )
                            : null,
                        child: Icon(
                          _currentIndex == 0 ? Icons.eco : Icons.eco_outlined,
                          size: 24,
                        ),
                      ),
                      label: 'Garden',
                    ),
                    BottomNavigationBarItem(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: _currentIndex == 1
                            ? BoxDecoration(
                                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(12),
                              )
                            : null,
                        child: Icon(
                          _currentIndex == 1 ? Icons.camera_alt : Icons.camera_alt_outlined,
                          size: 24,
                        ),
                      ),
                      label: 'Camera',
                    ),
                    BottomNavigationBarItem(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: _currentIndex == 2
                            ? BoxDecoration(
                                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(12),
                              )
                            : null,
                        child: Icon(
                          _currentIndex == 2 ? Icons.settings : Icons.settings_outlined,
                          size: 24,
                        ),
                      ),
                      label: 'Settings',
                    ),
                  ],
                ),
              ),
    );
  }
}