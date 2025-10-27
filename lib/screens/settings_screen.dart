import 'package:flutter/material.dart';
import '../services/theme_service.dart';
import '../widgets/theme_picker_widget.dart';

class SettingsScreen extends StatelessWidget {
  final ThemeService themeService;

  const SettingsScreen({super.key, required this.themeService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _buildAppearanceSection(context),
          const Divider(),
          _buildAboutSection(context),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Appearance',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ThemePickerWidget(themeService: themeService),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'About',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('About Plantyze'),
          subtitle: const Text('Plant identification app powered by Pl@ntNet'),
          onTap: () => _showAboutDialog(context),
        ),
        ListTile(
          leading: const Icon(Icons.feedback_outlined),
          title: const Text('Feedback'),
          subtitle: const Text('Help us improve the app'),
          onTap: () => _showFeedbackDialog(context),
        ),
        const ListTile(
          leading: Icon(Icons.code),
          title: Text('Version'),
          subtitle: Text('1.0.0'),
        ),
      ],
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About Plantyze'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Plantyze helps you identify plants using advanced image recognition powered by the Pl@ntNet API.',
              ),
              const SizedBox(height: 16),
              const Text(
                'Simply take a photo or select an image from your gallery, and discover the name and details of the plant.',
              ),
              const SizedBox(height: 16),
              Text(
                'Data provided by Pl@ntNet collaborative database.',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Feedback'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Help us improve Plantyze!'),
              SizedBox(height: 16),
              Text('Your feedback is valuable to us:'),
              SizedBox(height: 8),
              Text('• Report bugs or issues'),
              Text('• Suggest new features'),
              Text('• Share your experience'),
              SizedBox(height: 16),
              Text(
                'Contact us through the app store or our support channels.',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
