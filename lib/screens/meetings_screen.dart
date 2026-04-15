import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_selector/file_selector.dart';
import 'package:archive/archive_io.dart';

import '../data/dummy_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';

class MeetingsScreen extends StatefulWidget {
  const MeetingsScreen({super.key});

  @override
  State<MeetingsScreen> createState() => _MeetingsScreenState();
}

class _MeetingsScreenState extends State<MeetingsScreen> {
  bool _isImporting = false;

  Future<void> _importMinuteFile() async {
    setState(() => _isImporting = true);
    try {
      final typeGroup = XTypeGroup(
        label: 'documents',
        extensions: ['txt', 'md', 'docx'],
      );
      final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);
      if (file == null) return;

      final path = file.path;
      final extension = path?.split('.').last.toLowerCase();
      String fileText;
      if (extension == 'docx') {
        final bytes = await file.readAsBytes();
        fileText = _extractTextFromDocx(bytes);
      } else {
        fileText = await file.readAsString();
      }

      final summary = fileText.trim();
      await _confirmImportedMinute(context, summary);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Import failed: ${error.toString()}')),
      );
    } finally {
      setState(() => _isImporting = false);
    }
  }

  String _extractTextFromDocx(Uint8List bytes) {
    final archive = ZipDecoder().decodeBytes(bytes);
    final entry = archive.firstWhere(
      (file) => file.isFile && file.name == 'word/document.xml',
      orElse: () => throw Exception('DOCX document.xml not found.'),
    );
    final content = utf8.decode(entry.content as List<int>);
    return content
        .replaceAll(RegExp(r'<w:p[^>]*>'), '\n')
        .replaceAll(RegExp(r'<w:tab[^>]*\/?>'), '\t')
        .replaceAll(RegExp(r'<[^>]+>'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  Future<void> _confirmImportedMinute(BuildContext context, String summary) async {
    final titleController = TextEditingController();
    final summaryController = TextEditingController(text: summary);
    final formKey = GlobalKey<FormState>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (BuildContext sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(sheetContext).viewInsets.bottom + 52),
        child: StatefulBuilder(
          builder: (context, setModalState) {
            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 60,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppTheme.divider,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Confirm imported minute', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.textDark, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'Please enter a title';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: summaryController,
                      maxLines: 8,
                      decoration: const InputDecoration(labelText: 'Summary'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'Please enter a summary';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!formKey.currentState!.validate()) return;
                          final newMinute = MeetingMinute(
                            id: 'mm${DummyData.meetingMinutes.length + 1}',
                            title: titleController.text.trim(),
                            summary: summaryController.text.trim(),
                            date: DateTime.now(),
                            author: DummyData.currentUser.name,
                          );
                          setState(() {
                            DummyData.meetingMinutes.insert(0, newMinute);
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Minute file imported successfully.')),
                          );
                          _showMinuteDetails(context, newMinute);
                        },
                        child: const Text('Save minute'),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showMinuteDetails(BuildContext context, MeetingMinute minute) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (BuildContext sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(sheetContext).viewInsets.bottom + 52),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppTheme.divider,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(minute.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today_rounded, size: 14, color: AppTheme.textMid),
                  const SizedBox(width: 6),
                  Text(DateFormat('dd MMM yyyy').format(minute.date), style: const TextStyle(fontSize: 12, color: AppTheme.textMid)),
                  const SizedBox(width: 16),
                  const Icon(Icons.person_rounded, size: 14, color: AppTheme.textMid),
                  const SizedBox(width: 6),
                  Text(minute.author, style: const TextStyle(fontSize: 12, color: AppTheme.textMid)),
                ],
              ),
              const SizedBox(height: 20),
              Text('Meeting Summary', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Text(minute.summary, style: const TextStyle(fontSize: 13, color: AppTheme.textDark, height: 1.6)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EstateAppBar(
        title: 'Meetings',
        actions: [
          IconButton(
            onPressed: _isImporting ? null : _importMinuteFile,
            icon: _isImporting ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.upload_file),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 52),
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
    return GestureDetector(
      onTap: () => _showMinuteDetails(context),
      child: Container(
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
            Text(minute.summary, style: const TextStyle(fontSize: 13, color: AppTheme.textDark, height: 1.5), maxLines: 3, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 10),
            Text('Recorded by ${minute.author}', style: const TextStyle(fontSize: 11, color: AppTheme.textLight)),
          ],
        ),
      ),
    );
  }

  void _showMinuteDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (BuildContext sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(sheetContext).viewInsets.bottom + 52),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppTheme.divider,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(minute.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today_rounded, size: 14, color: AppTheme.textMid),
                  const SizedBox(width: 6),
                  Text(DateFormat('dd MMM yyyy').format(minute.date), style: const TextStyle(fontSize: 12, color: AppTheme.textMid)),
                  const SizedBox(width: 16),
                  const Icon(Icons.person_rounded, size: 14, color: AppTheme.textMid),
                  const SizedBox(width: 6),
                  Text(minute.author, style: const TextStyle(fontSize: 12, color: AppTheme.textMid)),
                ],
              ),
              const SizedBox(height: 20),
              Text('Meeting Summary', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Text(minute.summary, style: const TextStyle(fontSize: 13, color: AppTheme.textDark, height: 1.6)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
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

    await launchUrl(uri);
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
