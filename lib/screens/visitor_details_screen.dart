import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';

class VisitorDetailsScreen extends StatefulWidget {
  final Visitor visitor;

  const VisitorDetailsScreen({super.key, required this.visitor});

  @override
  State<VisitorDetailsScreen> createState() => _VisitorDetailsScreenState();
}

class _VisitorDetailsScreenState extends State<VisitorDetailsScreen> {
  Future<void> _shareVisitorDetails() async {
    final visitor = widget.visitor;
    final qrUrl = 'https://citiview.netlify.app/qrpage?name=${Uri.encodeComponent(visitor.name)}&phone=${Uri.encodeComponent(visitor.phone)}&host=${Uri.encodeComponent(visitor.hostName)}&purpose=${Uri.encodeComponent(visitor.purpose)}';
    final shareText = '''Visitor Details:\nName: ${visitor.name}\nPhone: ${visitor.phone}\nHost: ${visitor.hostName} (${visitor.hostUnit})\nPurpose: ${visitor.purpose}\nLast Action: ${visitor.lastAction == AccessType.entry ? 'IN' : 'OUT'}\nTimestamp: ${DateFormat('MMM dd, yyyy h:mm a').format(visitor.timestamp)}\n\nQR Code URL: $qrUrl''';

    try {
      await Share.share(shareText, subject: 'Visitor Details for ${visitor.name}');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share visitor details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final visitor = widget.visitor;
    final isIn = visitor.lastAction == AccessType.entry;
    final color = isIn ? AppTheme.success : AppTheme.error;
    final timeFmt = DateFormat('h:mm a').format(visitor.timestamp);
    final dateFmt = DateFormat('MMM dd, yyyy').format(visitor.timestamp);

    final qrUrl = 'https://citiview.netlify.app/qrpage?name=${Uri.encodeComponent(visitor.name)}&phone=${Uri.encodeComponent(visitor.phone)}&host=${Uri.encodeComponent(visitor.hostName)}&purpose=${Uri.encodeComponent(visitor.purpose)}';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Visitor Details'),
        actions: [
          IconButton(
            onPressed: _shareVisitorDetails,
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Visitor Info Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.divider),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        MemberAvatar(
                          initials: visitor.name.substring(0, 2).toUpperCase(),
                          size: 60,
                          color: color,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                visitor.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                visitor.phone,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.textMid,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isIn ? Icons.login_rounded : Icons.logout_rounded,
                                color: color,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isIn ? 'IN' : 'OUT',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: color,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildDetailRow('Host', '${visitor.hostName} (${visitor.hostUnit})'),
                    _buildDetailRow('Purpose', visitor.purpose),
                    _buildDetailRow('Last Action', '$timeFmt on $dateFmt'),
                    if (visitor.hasQrPass) _buildDetailRow('Access Method', 'QR Code'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // QR Code Section
              if (visitor.hasQrPass) ...[
                const Text(
                  'QR Code',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.divider),
                    ),
                    child: QrImageView(
                      data: qrUrl,
                      size: 200,
                    ),
                  ),
                ),
              ],
            ],
          ),
        )
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.textMid,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}