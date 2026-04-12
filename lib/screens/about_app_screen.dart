import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EstateAppBar(title: 'About Estate App'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Estate App', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            const Text('Version 1.0.0', style: TextStyle(fontSize: 14, color: AppTheme.textMid)),
            const SizedBox(height: 24),
            const Text('This app helps manage estate operations including payments, incidents, group chats, and meetings.', style: TextStyle(fontSize: 14, height: 1.6)),
            const SizedBox(height: 24),
            const Text('Terms', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            const Text('By using this app, you agree to the estate terms and conditions of service.', style: TextStyle(fontSize: 14, height: 1.6)),
          ],
        ),
      ),
    );
  }
}
