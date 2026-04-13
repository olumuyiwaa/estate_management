import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';

class HelpFeedbackScreen extends StatelessWidget {
  const HelpFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EstateAppBar(title: 'Help & Feedback'),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16,16,16,52),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Need help or want to send feedback?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            const Text('Message our support team directly and we will respond shortly.', style: TextStyle(fontSize: 14, color: AppTheme.textMid)),
            const SizedBox(height: 24),
            const TextField(
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Your message',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Send Feedback'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
