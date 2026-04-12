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
        padding: const EdgeInsets.all(16),
        itemCount: notices.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, index) {
          final notice = notices[index];
          return GestureDetector(
            onTap: () => _showNoticeDetails(context, notice),
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

  void _showNoticeDetails(BuildContext context, Notice notice) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(top: 24, left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(color: AppTheme.accent.withOpacity(0.14), borderRadius: BorderRadius.circular(14)),
                    child: const Icon(Icons.notifications_rounded, color: AppTheme.accent, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(notice.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  StatusBadge(label: notice.category, color: AppTheme.accent),
                  const SizedBox(width: 10),
                  Text('Posted by ${notice.postedBy}', style: const TextStyle(fontSize: 12, color: AppTheme.textMid)),
                  const Spacer(),
                  Text(DateFormat('dd MMM yyyy · h:mm a').format(notice.postedAt), style: const TextStyle(fontSize: 12, color: AppTheme.textMid)),
                ],
              ),
              const SizedBox(height: 18),
              Text(notice.body, style: const TextStyle(fontSize: 14, height: 1.7, color: AppTheme.textDark)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Dismiss'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
