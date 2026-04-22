import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/dummy_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';

class IncidentsScreen extends StatefulWidget {
  const IncidentsScreen({super.key});
  @override
  State<IncidentsScreen> createState() => _IncidentsScreenState();
}

class _IncidentsScreenState extends State<IncidentsScreen> {
  IncidentStatus? _filter;

  List<Incident> get _filtered => DummyData.incidents.where((i) => (_filter == null || i.status == _filter) && i.reportedBy.toLowerCase() == DummyData.currentUser.name.toLowerCase()).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EstateAppBar(title: 'Incidents & Tickets'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showReportSheet(context),
        backgroundColor: AppTheme.accent,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Report Issue', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: Column(
        children: [
          _buildSummaryRow(),
          _buildFilter(),
          Expanded(
            child: _filtered.isEmpty
                ? const EmptyState(icon: Icons.inbox_outlined, message: 'No incidents found')
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) => _IncidentCard(incident: _filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow() {
    final open = DummyData.incidents.where((i) => (i.status == IncidentStatus.open)&& i.reportedBy.toLowerCase() == DummyData.currentUser.name.toLowerCase()).length;
    final prog = DummyData.incidents.where((i) => (i.status == IncidentStatus.inProgress)&& i.reportedBy.toLowerCase() == DummyData.currentUser.name.toLowerCase()).length;
    final done = DummyData.incidents.where((i) => (i.status == IncidentStatus.resolved)&& i.reportedBy.toLowerCase() == DummyData.currentUser.name.toLowerCase()).length;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryItem('$open', 'Open', AppTheme.error),
          Container(width: 1, height: 36, color: AppTheme.divider),
          _summaryItem('$prog', 'In Progress', AppTheme.warning),
          Container(width: 1, height: 36, color: AppTheme.divider),
          _summaryItem('$done', 'Resolved', AppTheme.success),
        ],
      ),
    );
  }

  Widget _summaryItem(String count, String label, Color color) {
    return Column(
      children: [
        Text(count, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: color)),
        Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textMid)),
      ],
    );
  }

  Widget _buildFilter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _chip('All', null),
            _chip('Open', IncidentStatus.open),
            _chip('In Progress', IncidentStatus.inProgress),
            _chip('Resolved', IncidentStatus.resolved),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, IncidentStatus? s) {
    final selected = _filter == s;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => setState(() => _filter = s),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: selected ? AppTheme.primary : AppTheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: selected ? AppTheme.primary : AppTheme.divider),
          ),
          child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? Colors.white : AppTheme.textMid)),
        ),
      ),
    );
  }

  void _showReportSheet(BuildContext context) {
    XFile? selectedImage;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 52),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Report an Issue', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              const Text('Photo', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final image = await openFile(
                    acceptedTypeGroups: [const XTypeGroup(label: 'images', extensions: ['jpg', 'jpeg', 'png'])],
                  );
                  if (image != null) {
                    setModalState(() {
                      selectedImage = image;
                    });
                  }
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  height: 160,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.divider.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.divider),
                  ),
                  child: selectedImage == null
                      ? const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_outlined, size: 28, color: AppTheme.textMid),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Tap to add a photo',
                          style: TextStyle(color: AppTheme.textMid),
                        ),
                      ),
                    ],
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(selectedImage!.path),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const TextField(decoration: InputDecoration(labelText: 'Title / Summary')),
              const SizedBox(height: 12),
              const TextField(decoration: InputDecoration(labelText: 'Location'), ),
              const SizedBox(height: 12),
              const TextField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final image = await openFile(
                          acceptedTypeGroups: [const XTypeGroup(label: 'images', extensions: ['jpg', 'jpeg', 'png'])],
                        );
                        if (image != null) {
                          setModalState(() {
                            selectedImage = image;
                          });
                        }
                      },
                      icon: const Icon(Icons.camera_alt_outlined, size: 18),
                      label: const Text('Add Photo'),
                      style: OutlinedButton.styleFrom(foregroundColor: AppTheme.secondary, side: const BorderSide(color: AppTheme.secondary), padding: const EdgeInsets.symmetric(vertical: 14)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Submit Report'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IncidentCard extends StatelessWidget {
  final Incident incident;
  const _IncidentCard({required this.incident});

  @override
  Widget build(BuildContext context) {
    final pColor = priorityColor(incident.priority);
    final sColor = incidentStatusColor(incident.status);
    final dateFmt = DateFormat('dd MMM, h:mm a').format(incident.reportedAt);

    return GestureDetector(
      onTap: () => showIncidentDetailSheet(context, incident),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
              decoration: BoxDecoration(
                color: pColor.withOpacity(0.05),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                border: Border(left: BorderSide(color: pColor, width: 4)),
              ),
              child: Row(
                children: [
                  Expanded(child: Text(incident.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700))),
                  StatusBadge(label: incidentStatusLabel(incident.status), color: sColor),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(incident.description, style: const TextStyle(fontSize: 12, color: AppTheme.textMid), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 13, color: AppTheme.textMid),
                      const SizedBox(width: 4),
                      Text(incident.location, style: const TextStyle(fontSize: 11, color: AppTheme.textMid)),
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time_rounded, size: 13, color: AppTheme.textMid),
                      const SizedBox(width: 4),
                      Text(dateFmt, style: const TextStyle(fontSize: 11, color: AppTheme.textMid)),
                    ],
                  ),
                  if (incident.assignedTo != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.person_outline_rounded, size: 13, color: AppTheme.info),
                        const SizedBox(width: 4),
                        Text('Assigned to: ${incident.assignedTo}', style: const TextStyle(fontSize: 11, color: AppTheme.info, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

void showIncidentDetailSheet(BuildContext context, Incident incident) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, ctrl) => Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          controller: ctrl,
          children: [
            Row(
              children: [
                Expanded(child: Text(incident.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
                StatusBadge(label: incidentStatusLabel(incident.status), color: incidentStatusColor(incident.status)),
              ],
            ),
            const SizedBox(height: 16),
            _detailRow(Icons.location_on_outlined, 'Location', incident.location),
            _detailRow(Icons.person_outline_rounded, 'Reported By', incident.reportedBy),
            _detailRow(Icons.access_time_rounded, 'Reported At', DateFormat('dd MMM yyyy, h:mm a').format(incident.reportedAt)),
            if (incident.assignedTo != null)
              _detailRow(Icons.engineering_outlined, 'Assigned To', incident.assignedTo!),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12)),
              child: Text(incident.description, style: const TextStyle(fontSize: 13, color: AppTheme.textMid, height: 1.5)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Update Status')),
          ],
        ),
      ),
    ),
  );
}

Widget _detailRow(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.textMid),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(fontSize: 12, color: AppTheme.textMid)),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textDark))),
      ],
    ),
  );
}
