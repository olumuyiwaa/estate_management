import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';

class ActivityLogScreen extends StatelessWidget {
  const ActivityLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      'Logged in from mobile',
      'Booked facility',
      'Reported incident',
      'Updated profile information',
    ];

    return Scaffold(
      appBar: const EstateAppBar(title: 'Activity Log'),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, index) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.divider),
            ),
            child: Text(items[index], style: const TextStyle(fontSize: 14, color: AppTheme.textDark)),
          );
        },
      ),
    );
  }
}
