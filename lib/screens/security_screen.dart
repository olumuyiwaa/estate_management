import 'dart:convert';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../data/dummy_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import 'visitor_details_screen.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});
  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Security & Access'),
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: AppTheme.accent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [Tab(text: 'My Visitors'), Tab(text: 'Access Log')],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'register_visitor_fab',
        onPressed: () => _showRegisterVisitor(context),
        backgroundColor: AppTheme.accent,
        icon: const Icon(Icons.person_add_rounded, color: Colors.white),
        label: const Text('Register Visitor', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _VisitorsTab(),
          _AccessLogTab(),
        ],
      ),
    );
  }

  void _showRegisterVisitor(BuildContext context) {
    final outerContext = context;
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final hostController = TextEditingController(text: DummyData.currentUser.unitNumber);
    final purposeController = TextEditingController();
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
              Text('Register Visitor', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              const Text('Visitor Photo', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
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
                      Icon(Icons.image_outlined, size: 28, color: AppTheme.textMid),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Tap to select a visitor photo',
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
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Visitor Name')),
              const SizedBox(height: 12),
              TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone Number')),
              const SizedBox(height: 12),
              TextField(controller: hostController, decoration: const InputDecoration(labelText: 'Host Unit (e.g. Z-991)')),
              const SizedBox(height: 12),
              TextField(controller: purposeController, decoration: const InputDecoration(labelText: 'Purpose of Visit')),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.no_encryption_outlined),
                      label: const Text('Gate Pass'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.secondary,
                        side: const BorderSide(color: AppTheme.secondary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (nameController.text.isEmpty || phoneController.text.isEmpty || hostController.text.isEmpty || purposeController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill all fields')),
                          );
                          return;
                        }
                        final url = 'https://citiview.netlify.app/qrpage?name=${Uri.encodeComponent(nameController.text)}&phone=${Uri.encodeComponent(phoneController.text)}&host=${Uri.encodeComponent(hostController.text)}&purpose=${Uri.encodeComponent(purposeController.text)}';
                        Navigator.pop(context);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          showDialog(
                            context: outerContext,
                            builder: (_) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(8)),
                              title: const Text('Visitor QR Code'),
                              content: SizedBox(
                                width: 240,
                                height: 240,
                                child: QrImageView(
                                  data: url,
                                  size: 200,
                                ),
                              ),
                            ),
                          );
                        });
                      },
                      icon: const Icon(Icons.qr_code_rounded, size: 18),
                      label: const Text('Generate QR'),
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

class _VisitorsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = DummyData.currentUser;
    final userVisitors = DummyData.visitors.where((visitor) {
      return visitor.hostUnit == user.unitNumber || visitor.hostName == user.name;
    }).toList();

    if (userVisitors.isEmpty) {
      return EmptyState(icon: Icons.person_search_outlined, message: 'No visitors found for your unit');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: userVisitors.length,
      itemBuilder: (_, i) => _VisitorCard(visitor: userVisitors[i]),
    );
  }
}

class _VisitorCard extends StatelessWidget {
  final Visitor visitor;
  const _VisitorCard({required this.visitor});

  @override
  Widget build(BuildContext context) {
    final isIn = visitor.lastAction == AccessType.entry;
    final color = isIn ? AppTheme.success : AppTheme.error;
    final timeFmt = DateFormat('h:mm a').format(visitor.timestamp);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VisitorDetailsScreen(visitor: visitor),
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Row(
          children: [
            MemberAvatar(initials: visitor.name.substring(0, 2).toUpperCase(), size: 46, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(visitor.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
                      if (visitor.hasQrPass)
                        const Icon(Icons.qr_code_rounded, size: 16, color: AppTheme.info),
                    ],
                  ),
                  Text('Host: ${visitor.hostName} · ${visitor.hostUnit}', style: const TextStyle(fontSize: 11, color: AppTheme.textMid)),
                  Text('${visitor.purpose} · $timeFmt', style: const TextStyle(fontSize: 11, color: AppTheme.textMid)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(isIn ? Icons.login_rounded : Icons.logout_rounded, color: color, size: 14),
                  const SizedBox(width: 4),
                  Text(isIn ? 'IN' : 'OUT', style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccessLogTab extends StatelessWidget {
  static final List<Map<String, dynamic>> _log = [
    {'time': '10:32 AM', 'name': 'Chidi Anyanwu', 'unit': 'A-102', 'action': 'Entry', 'method': 'QR Code'},
    {'time': '10:15 AM', 'name': 'DHL Delivery', 'unit': 'D-402', 'action': 'Exit', 'method': 'Gate Pass'},
    {'time': '10:05 AM', 'name': 'Laundry Delivery', 'unit': 'A-101', 'action': 'Entry', 'method': 'Manual'},
    {'time': '09:55 AM', 'name': 'Mrs. Ifeoma Uzo', 'unit': 'A-101', 'action': 'Exit', 'method': 'QR Code'},
    {'time': '09:20 AM', 'name': 'Plumber – Jimoh', 'unit': 'B-201', 'action': 'Entry', 'method': 'Manual'},
    {'time': '09:12 AM', 'name': 'Mrs. Grace Obi', 'unit': 'C-301', 'action': 'Exit', 'method': 'QR Code'},
    {'time': '08:55 AM', 'name': 'Mr. Olumide Benson', 'unit': 'A-101', 'action': 'Entry', 'method': 'QR Code'},
    {'time': '08:30 AM', 'name': 'Adanna Cleaning Staff', 'unit': 'Estate', 'action': 'Entry', 'method': 'Staff Badge'},
    {'time': '07:15 AM', 'name': 'Newspaper Vendor', 'unit': 'Gate', 'action': 'Exit', 'method': 'Manual'},
    {'time': '06:45 AM', 'name': 'Night Guard Relief', 'unit': 'Guard Post', 'action': 'Entry', 'method': 'Staff Badge'},
  ];

  @override
  Widget build(BuildContext context) {
    final user = DummyData.currentUser;
    final userLog = _log.where((entry) => entry['unit'] == user.unitNumber).toList();

    if (userLog.isEmpty) {
      return EmptyState(icon: Icons.lock_outline, message: 'No access log entries found for your unit');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: userLog.length,
      itemBuilder: (_, i) {
        final e = userLog[i];
        final isIn = e['action'] == 'Entry';
        final color = isIn ? AppTheme.success : AppTheme.error;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.divider),
          ),
          child: Row(
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(isIn ? Icons.login_rounded : Icons.logout_rounded, color: color, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e['name'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    Text('Unit ${e['unit']} · ${e['method']}', style: const TextStyle(fontSize: 11, color: AppTheme.textMid)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(e['time'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
                  Text(e['action'] as String, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
