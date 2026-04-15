import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../data/dummy_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import 'due_payment_screen.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});
  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabs;
  late final List<int> _availableYears;
  late int _selectedYear;
  final fmt = NumberFormat('#,###', 'en_US');

  @override
  void initState() {
    super.initState();
    _availableYears = DummyData.yearlyIncome.keys.toList()..sort((a, b) => b.compareTo(a));
    _selectedYear = _availableYears.first;
    _tabs = TabController(length: 3, vsync: this);
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
        title: const Text('Finance'),
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: AppTheme.accent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [Tab(text: 'Overview'), Tab(text: 'Income'), Tab(text: 'Expenses')],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const DuePaymentScreen()));},
        backgroundColor: AppTheme.accent,
        icon: const Icon(Icons.payments, color: Colors.white),
        label: const Text('Pay Dues', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _OverviewTab(
            fmt: fmt,
            selectedYear: _selectedYear,
            availableYears: _availableYears,
            onYearChanged: (year) => setState(() => _selectedYear = year),
          ),
          _PaymentsTab(fmt: fmt),
          _ExpensesTab(fmt: fmt),
        ],
      ),
    );
  }
}

// ── Overview Tab ──────────────────────────────────────────────────────────
class _OverviewTab extends StatelessWidget {
  final NumberFormat fmt;
  final int selectedYear;
  final List<int> availableYears;
  final ValueChanged<int> onYearChanged;

  const _OverviewTab({
    required this.fmt,
    required this.selectedYear,
    required this.availableYears,
    required this.onYearChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildBalanceCard(),
          const SizedBox(height: 20),
          Row(
            children: [
              const Expanded(child: SectionHeader(title: 'Yearly Income')),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.divider),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: selectedYear,
                    items: availableYears
                        .map((year) => DropdownMenuItem(value: year, child: Text(year.toString(), style: const TextStyle(fontSize: 13))))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) onYearChanged(value);
                    },
                    icon: const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(Icons.calendar_today_rounded, size: 18, color: AppTheme.textMid),
                    ),
                    style: const TextStyle(color: AppTheme.textDark),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildBarChart(),
          const SizedBox(height: 20),
          const SectionHeader(title: 'Expense Breakdown'),
          const SizedBox(height: 12),
          _buildPieSection(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, AppTheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Estate Balance', style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 8),
          Text(
            '₦${NumberFormat('#,###').format(DummyData.totalCollected - DummyData.totalExpenses)}',
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _mini('Income', DummyData.totalCollected, AppTheme.accentLight),
              const SizedBox(width: 24),
              _mini('Expenses', DummyData.totalExpenses, Colors.red[200]!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mini(String label, double amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
        Text('₦${NumberFormat('#,###').format(amount)}', style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _buildBarChart() {
    final data = DummyData.yearlyIncome[selectedYear] ?? DummyData.monthlyIncome;
    final maxAmount = data.fold<double>(0, (prev, element) => math.max(prev, element['amount'] as double));

    return Container(
      height: 220,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.divider),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (maxAmount * 1.15).ceilToDouble(),
          barGroups: data.asMap().entries.map((e) => BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: e.value['amount'] as double,
                color: AppTheme.secondary,
                width: 16,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
              ),
            ],
          )).toList(),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => const FlLine(color: AppTheme.divider, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, _) {
                  final index = v.toInt();
                  if (index < 0 || index >= data.length) return const SizedBox();
                  return Text(data[index]['month'] as String, style: const TextStyle(fontSize: 11, color: AppTheme.textMid));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPieSection() {
    final cats = DummyData.expenseCategories;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 140, height: 140,
            child: PieChart(PieChartData(
              sections: cats.map((c) => PieChartSectionData(
                color: Color(c['color'] as int),
                value: c['amount'] as double,
                showTitle: false,
                radius: 20,
              )).toList(),
              sectionsSpace: 2,
              centerSpaceRadius: 50,
            )),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              children: cats.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(width: 10, height: 10, decoration: BoxDecoration(color: Color(c['color'] as int), borderRadius: BorderRadius.circular(3))),
                    const SizedBox(width: 8),
                    Expanded(child: Text(c['name'] as String, style: const TextStyle(fontSize: 12, color: AppTheme.textDark))),
                    Text('₦${NumberFormat('#,###').format((c['amount'] as double) / 1000)}K', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textMid)),
                  ],
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Payments Tab ──────────────────────────────────────────────────────────
class _PaymentsTab extends StatelessWidget {
  final NumberFormat fmt;
  const _PaymentsTab({required this.fmt});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: DummyData.payments.length,
      itemBuilder: (_, i) {
        final p = DummyData.payments[i];
        final color = paymentStatusColor(p.status);
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.divider),
          ),
          child: Row(
            children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(
                  p.status == PaymentStatus.paid ? Icons.check_circle_outline : Icons.pending_outlined,
                  color: color, size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.memberName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    Text('${p.description} · Unit ${p.unitNumber}', style: const TextStyle(fontSize: 11, color: AppTheme.textMid)),
                    Text('Due: ${DateFormat('dd MMM yyyy').format(p.dueDate)}', style: const TextStyle(fontSize: 11, color: AppTheme.textMid)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('₦${fmt.format(p.amount)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textDark)),
                    StatusBadge(label: paymentStatusLabel(p.status), color: color),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Expenses Tab ──────────────────────────────────────────────────────────
class _ExpensesTab extends StatelessWidget {
  final NumberFormat fmt;
  const _ExpensesTab({required this.fmt});

  static final List<Map<String, dynamic>> _expenses = [
    {'desc': 'GuardPro Security – April', 'category': 'Security', 'date': '01 Apr 2025', 'amount': 180000.0, 'status': 'Paid'},
    {'desc': 'Diesel Purchase – Generator', 'category': 'Generator', 'date': '03 Apr 2025', 'amount': 75000.0, 'status': 'Paid'},
    {'desc': 'CleanPro Monthly Contract', 'category': 'Cleaning', 'date': '05 Apr 2025', 'amount': 65000.0, 'status': 'Paid'},
    {'desc': 'Elevator Maintenance – Block C', 'category': 'Maintenance', 'date': '08 Apr 2025', 'amount': 120000.0, 'status': 'Pending'},
    {'desc': 'Street Light Repairs', 'category': 'Maintenance', 'date': '09 Apr 2025', 'amount': 45000.0, 'status': 'Pending'},
    {'desc': 'Office Supplies & Stationery', 'category': 'Admin', 'date': '02 Apr 2025', 'amount': 22000.0, 'status': 'Paid'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _expenses.length,
      itemBuilder: (_, i) {
        final e = _expenses[i];
        final isPaid = e['status'] == 'Paid';
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.divider),
          ),
          child: Row(
            children: [
              const Icon(Icons.arrow_upward_rounded, color: AppTheme.error, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e['desc'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    Text('${e['category']} · ${e['date']}', style: const TextStyle(fontSize: 11, color: AppTheme.textMid)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₦${fmt.format(e['amount'] as double)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.error)),
                  const SizedBox(height: 4),
                  StatusBadge(label: e['status'] as String, color: isPaid ? AppTheme.success : AppTheme.warning),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
