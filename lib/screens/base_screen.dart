import 'package:flutter/material.dart';

class BaseScreen extends StatefulWidget {
  final List<Widget> screens;
  final int initialIndex;

  const BaseScreen({
    super.key,
    required this.screens,
    this.initialIndex = 0,
  });

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  late int _currentTab;
  late int _previousTab;

  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialIndex;
    _previousTab = widget.initialIndex;
  }

  void _onTabChanged(int index) {
    if (index == _currentTab || index < 0 || index >= widget.screens.length) return;
    setState(() {
      _previousTab = _currentTab;
      _currentTab = index;
    });
  }

  void _goBack() {
    _onTabChanged(_previousTab);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentTab,
        children: widget.screens,
      ),
      bottomNavigationBar: _currentTab == 1 
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
                currentIndex: _currentTab,
                onTap: _onTabChanged,
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
                      decoration: _currentTab == 0
                          ? BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(12),
                            )
                          : null,
                      child: Icon(
                        _currentTab == 0 ? Icons.eco : Icons.eco_outlined,
                        size: 24,
                      ),
                    ),
                    label: 'Garden',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: _currentTab == 1
                          ? BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(12),
                            )
                          : null,
                      child: Icon(
                        _currentTab == 1 ? Icons.camera_alt : Icons.camera_alt_outlined,
                        size: 24,
                      ),
                    ),
                    label: 'Camera',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: _currentTab == 2
                          ? BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(12),
                            )
                          : null,
                      child: Icon(
                        _currentTab == 2 ? Icons.settings : Icons.settings_outlined,
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

extension BaseScreenNavigation on BuildContext {
  void navigateToTab(int index) {
    final state = findAncestorStateOfType<_BaseScreenState>();
    state?._onTabChanged(index);
  }

  void navigateBack() {
    final state = findAncestorStateOfType<_BaseScreenState>();
    state?._goBack();
  }
}

