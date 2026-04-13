import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/dummy_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';

class MeetingsScreen extends StatelessWidget {
  const MeetingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EstateAppBar(title: 'Meetings'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16,16,16,52),
        children: [
          const SectionHeader(title: 'Summary - Minutes'),
          const SizedBox(height: 12),
          ...DummyData.meetingMinutes.map((minute) => _MinuteCard(minute: minute)),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Scheduler'),
          const SizedBox(height: 12),
          ...DummyData.upcomingMeetings.map((meeting) => _MeetingCard(meeting: meeting)),
        ],
      ),
    );
  }
}

class _MinuteCard extends StatelessWidget {
  final MeetingMinute minute;
  const _MinuteCard({required this.minute});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(minute.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(DateFormat('dd MMM yyyy').format(minute.date), style: const TextStyle(fontSize: 12, color: AppTheme.textMid)),
          const SizedBox(height: 10),
          Text(minute.summary, style: const TextStyle(fontSize: 13, color: AppTheme.textDark, height: 1.5)),
          const SizedBox(height: 10),
          Text('Recorded by ${minute.author}', style: const TextStyle(fontSize: 11, color: AppTheme.textLight)),
        ],
      ),
    );
  }
}

class _MeetingCard extends StatelessWidget {
  final MeetingEvent meeting;
  const _MeetingCard({required this.meeting});

  Future<void> _addToCalendar(BuildContext context) async {
    final uri = Platform.isIOS
        ? Uri.parse('calshow:${meeting.start.millisecondsSinceEpoch ~/ 1000}')
        : Uri.parse('content://com.android.calendar/time/${meeting.start.millisecondsSinceEpoch}');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Unable to open phone calendar. Please add the event manually.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(meeting.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Row(
            children: [
              _chip(Icons.location_on_rounded, meeting.location),
              const SizedBox(width: 8),
              _chip(Icons.calendar_today_rounded, DateFormat('dd MMM · hh:mm a').format(meeting.start)),
            ],
          ),
          const SizedBox(height: 10),
          Text(meeting.agenda, style: const TextStyle(fontSize: 13, color: AppTheme.textMid, height: 1.5)),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _addToCalendar(context),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent),
              child: const Text('Add to Phone Calendar'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.textMid),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textMid)),
        ],
      ),
    );
  }
}
