import 'package:estate_app/screens/more_screens.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/dummy_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  List<Notice> get _sortedNotices {
    final notices = List<Notice>.from(DummyData.notices);
    notices.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.postedAt.compareTo(a.postedAt);
    });
    return notices;
  }

  @override
  Widget build(BuildContext context) {
    final notices = _sortedNotices;

    return Scaffold(
      appBar: const EstateAppBar(title: 'Notifications'),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16,16,16,52),
        itemCount: notices.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, index) {
          final notice = notices[index];
          return GestureDetector(
            onTap: () => showNoticeOverlay(context, notice),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      StatusBadge(label: notice.category, color: AppTheme.accent),
                      const Spacer(),
                      Text(DateFormat('dd MMM').format(notice.postedAt), style: const TextStyle(fontSize: 12, color: AppTheme.textMid)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(notice.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textDark)),
                  const SizedBox(height: 8),
                  Text(notice.body, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, color: AppTheme.textMid, height: 1.5)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
