import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/dummy_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';

enum PaymentGatewayMethod { card, bankTransfer}

class DuePaymentScreen extends StatefulWidget {
  final PaymentRecord? initialPayment;

  const DuePaymentScreen({super.key, this.initialPayment});

  @override
  State<DuePaymentScreen> createState() => _DuePaymentScreenState();
}

class _DuePaymentScreenState extends State<DuePaymentScreen> {
  final NumberFormat _fmt = NumberFormat('#,###', 'en_US');
  late PaymentGatewayMethod _selectedMethod;
  late String _selectedCategory;
  late TextEditingController _amountController;
  late Map<String, double> _categoryAmounts;
  PaymentRecord? _focusedPayment;

  List<PaymentRecord> get _duePayments => DummyData.payments.where((p) => p.status != PaymentStatus.paid && p.memberId == DummyData.currentUser.id).toList();
  List<PaymentRecord> get _paidPayments => DummyData.payments.where((p) => p.status == PaymentStatus.paid && p.memberId == DummyData.currentUser.id).toList();

  @override
  void initState() {
    super.initState();
    _selectedMethod = PaymentGatewayMethod.card;
    _categoryAmounts = _buildCategoryAmounts();
    _selectedCategory = _categoryAmounts.keys.first;
    _amountController = TextEditingController(text: _categoryAmounts[_selectedCategory]!.toStringAsFixed(0));
    _focusedPayment = widget.initialPayment ?? (_duePayments.isNotEmpty ? _duePayments.first : null);
  }

  Map<String, double> _buildCategoryAmounts() {
    final totals = <String, double>{};
    for (final item in _duePayments) {
      totals[item.category] = (totals[item.category] ?? 0) + item.amount;
    }
    if (totals.isEmpty) {
      totals['Service Charge'] = 0.0;
    }
    return totals;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EstateAppBar(title: 'Due Payments', showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16,16,16,52),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const SectionHeader(title: 'Recent Receipts'),
            const SizedBox(height: 12),
            ..._paidPayments.take(3).map((payment) => _buildReceiptRow(payment)).toList(),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Outstanding Dues'),
            const SizedBox(height: 12),
            if (_duePayments.isEmpty) ...[
              const EmptyState(icon: Icons.check_circle_outline_rounded, message: 'No outstanding dues at this time.'),
            ] else ..._duePayments.map((payment) => _buildPaymentRow(payment)).toList(),
          ],
        ),
      ),
    );
  }



  Widget _buildPaymentRow(PaymentRecord payment) {
    final color = paymentStatusColor(payment.status);
    return GestureDetector(
      onTap: () => _selectPayment(payment),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _focusedPayment == payment ? AppTheme.primary.withOpacity(0.25) : AppTheme.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
              child: Icon(payment.status == PaymentStatus.overdue ? Icons.warning_amber_rounded : Icons.schedule_rounded, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(payment.description, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('${payment.category} · Unit ${payment.unitNumber}', style: const TextStyle(fontSize: 11, color: AppTheme.textMid)),
                  const SizedBox(height: 4),
                  Text('Due: ${DateFormat('dd MMM yyyy').format(payment.dueDate)}', style: const TextStyle(fontSize: 11, color: AppTheme.textMid)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('₦${_fmt.format(payment.amount)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textDark)),
                const SizedBox(height: 6),
                StatusBadge(label: paymentStatusLabel(payment.status), color: color),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () => payment.status == PaymentStatus.paid ? _showReceipt(payment) : _showPaymentGatewaySheet(payment),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: payment.status == PaymentStatus.paid ? AppTheme.primary : AppTheme.accent,
                    side: BorderSide(color: payment.status == PaymentStatus.paid ? AppTheme.primary : AppTheme.accent),
                    minimumSize: const Size(92, 34),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text(payment.status == PaymentStatus.paid ? 'Receipt' : 'Pay now', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(PaymentRecord payment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        children: [
          const Icon(Icons.receipt_long_rounded, color: AppTheme.secondary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Receipt for ${payment.memberName}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                Text('${payment.description} · Unit ${payment.unitNumber}', style: const TextStyle(fontSize: 11, color: AppTheme.textMid)),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _showReceipt(payment),
            child: const Text('View', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _selectPayment(PaymentRecord payment) {
    setState(() {
      _focusedPayment = payment;
      _selectedCategory = payment.category;
      _amountController.text = _categoryAmounts[payment.category]?.toStringAsFixed(0) ?? payment.amount.toStringAsFixed(0);
    });
  }

  void _showPaymentGatewaySheet(PaymentRecord payment) {
    _selectPayment(payment);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        var selectedMethod = _selectedMethod;
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 52),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(color: AppTheme.divider, borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text('Choose payment method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  const Text('Select how you want to pay for this invoice.', style: TextStyle(fontSize: 13, color: AppTheme.textMid)),
                  const SizedBox(height: 18),
                  ...PaymentGatewayMethod.values.map((method) {
                    final selected = method == selectedMethod;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () => setSheetState(() => selectedMethod = method),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: selected ? AppTheme.primary.withOpacity(0.12) : AppTheme.surface,
                            border: Border.all(color: selected ? AppTheme.primary : AppTheme.divider),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: selected ? AppTheme.primary : AppTheme.secondary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(_gatewayMethodIcon(method), color: selected ? Colors.white : AppTheme.secondary, size: 24),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_gatewayMethodLabel(method), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: selected ? AppTheme.primary : AppTheme.textDark)),
                                    const SizedBox(height: 4),
                                    const Text('Secure and easy checkout', style: TextStyle(fontSize: 12, color: AppTheme.textMid)),
                                  ],
                                ),
                              ),
                              if (selected)
                                const Icon(Icons.check_circle_rounded, color: AppTheme.accent, size: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => _selectedMethod = selectedMethod);
                        Navigator.pop(sheetContext);
                        _payCurrentSelection();
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent, padding: const EdgeInsets.symmetric(vertical: 14)),
                      child: Text('Continue with ${_gatewayMethodLabel(selectedMethod)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _payCurrentSelection() {
    if (_focusedPayment == null) return;
    final selectedAmount = double.tryParse(_amountController.text.replaceAll(',', '')) ?? _focusedPayment!.amount;
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Payment'),
        content: Text('Pay ₦${_fmt.format(selectedAmount)} for ${_focusedPayment!.description} using ${_gatewayMethodLabel(_selectedMethod)}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment successful via ${_gatewayMethodLabel(_selectedMethod)}.')));
              _showReceipt(_focusedPayment!);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent),
            child: const Text('Pay Now'),
          ),
        ],
      ),
    );
  }

  void _showReceipt(PaymentRecord payment) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentReceiptScreen(payment: payment)));
  }

  String _gatewayMethodLabel(PaymentGatewayMethod method) {
    switch (method) {
      case PaymentGatewayMethod.card:
        return 'Card Payment';
      case PaymentGatewayMethod.bankTransfer:
        return 'Bank Transfer';
    }
  }

  IconData _gatewayMethodIcon(PaymentGatewayMethod method) {
    switch (method) {
      case PaymentGatewayMethod.card:
        return Icons.credit_card_rounded;
      case PaymentGatewayMethod.bankTransfer:
        return Icons.account_balance_rounded;
    }
  }
}

class PaymentReceiptScreen extends StatelessWidget {
  final PaymentRecord payment;

  const PaymentReceiptScreen({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EstateAppBar(title: 'Payment Receipt', showBack: true),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16,16,16,52),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Receipt #${payment.id.toUpperCase()}', style: const TextStyle(fontSize: 12, color: AppTheme.textMid)),
                  const SizedBox(height: 12),
                  Text(payment.description, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textDark)),
                  const SizedBox(height: 8),
                  Text('Unit ${payment.unitNumber} · ${payment.memberName}', style: const TextStyle(fontSize: 13, color: AppTheme.textMid)),
                  const SizedBox(height: 16),
                  _buildReceiptItem('Amount Paid', '₦${_format(payment.amount)}'),
                  _buildReceiptItem('Category', payment.category),
                  _buildReceiptItem('Status', paymentStatusLabel(payment.status)),
                  _buildReceiptItem('Invoice Date', _formatDate(DateTime.now())),
                  if (payment.paidDate != null) _buildReceiptItem('Paid On', _formatDate(payment.paidDate!)),
                  _buildReceiptItem('Due Date', _formatDate(payment.dueDate)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Thank you for keeping your estate account in good standing.', style: TextStyle(fontSize: 13, color: AppTheme.textMid, height: 1.5)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent, padding: const EdgeInsets.symmetric(vertical: 14)),
                child: const Text('Close Receipt', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textMid)),
          Flexible(child: Text(value, textAlign: TextAlign.right, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  String _format(double value) => NumberFormat('#,###', 'en_US').format(value);
  String _formatDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);
}
