import 'package:flutter/material.dart';
import '../services/theme_service.dart';

// ignore_for_file: deprecated_member_use

class ThemePickerWidget extends StatelessWidget {
  final ThemeService themeService;

  const ThemePickerWidget({
    super.key,
    required this.themeService,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeService,
      builder: (context, child) {
        final currentMode = themeService.themeMode;
        
        return ListTile(
          leading: Icon(themeService.getThemeModeIcon(currentMode)),
          title: const Text('Theme'),
          subtitle: Text(themeService.getThemeModeDisplayName(currentMode)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            _showThemeDialog(context);
          },
        );
      },
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Choose Theme'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: AppThemeMode.values.map((AppThemeMode mode) {
                  return RadioListTile<AppThemeMode>(
                    title: Row(
                      children: [
                        Icon(themeService.getThemeModeIcon(mode), size: 20),
                        const SizedBox(width: 12),
                        Text(themeService.getThemeModeDisplayName(mode)),
                      ],
                    ),
                    value: mode,
                    groupValue: themeService.themeMode,
                    onChanged: (AppThemeMode? value) {
                      if (value != null) {
                        setDialogState(() {});
                        themeService.setThemeMode(value);
                        Navigator.of(context).pop();
                      }
                    },
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}