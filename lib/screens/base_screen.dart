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
          : NavigationBar(
              selectedIndex: _currentTab,
              onDestinationSelected: _onTabChanged,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.eco),
                  label: 'Garden',
                ),
                NavigationDestination(
                  icon: Icon(Icons.camera_alt),
                  label: 'Camera',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
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
