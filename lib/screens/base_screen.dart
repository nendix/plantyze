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
          : Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _NavItem(
                      icon: Icons.eco,
                      isActive: _currentTab == 0,
                      onTap: () => _onTabChanged(0),
                    ),
                    _NavItem(
                      icon: Icons.camera_alt,
                      isActive: _currentTab == 1,
                      onTap: () => _onTabChanged(1),
                    ),
                    _NavItem(
                      icon: Icons.settings,
                      isActive: _currentTab == 2,
                      onTap: () => _onTabChanged(2),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Icon(
            icon,
            size: 28,
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
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

