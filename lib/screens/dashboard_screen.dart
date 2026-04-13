import 'package:estate_app/screens/notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/dummy_data.dart';
import '../main.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';
import 'due_payment_screen.dart';
import 'more_screens.dart';
import 'group_chat_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _noticeController = PageController(viewportFraction: 0.96);
  final ScrollController _scrollController = ScrollController();
  int _noticeIndex = 0;
  bool _showNotifications = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final shouldShow = _scrollController.offset > 10;
      if (shouldShow != _showNotifications) {
        setState(() {
          _showNotifications = shouldShow;
        });
      }
    });
  }

  @override
  void dispose() {
    _noticeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = DummyData.currentUser;
    final fmt = NumberFormat('#,###', 'en_US');

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildSliverHeader(context, user, fmt),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 24),
                _buildQuickStats(fmt),
                const SizedBox(height: 24),
                _buildNoticesBanner(context),
                const SizedBox(height: 24),
                _buildQuickActions(context),
                const SizedBox(height: 24),
                SectionHeader(title: 'Recent Incidents', actionLabel: 'View All',
                  onAction: (){Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const MainApp(pageIndex: 4,)),
                        (route) => false,
                  );},
                ),
                const SizedBox(height: 12),
                _buildRecentIncidents(),
                const SizedBox(height: 24),
                SectionHeader(title: 'Payment Overview', actionLabel: 'View All',
                  onAction: (){Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const MainApp(pageIndex: 2,)),
                        (route) => false,
                  );},
                ),
                const SizedBox(height: 12),
                _buildPaymentOverview(fmt),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverHeader(BuildContext context, EstateMember user, NumberFormat fmt) {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      backgroundColor: AppTheme.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppTheme.primary, AppTheme.secondary],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 42, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good morning,',
                            style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 14),
                          ),
                          Text(
                            user.name.split(' ')[0],
                            style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
                            },
                            child: Container(
                            width: 42, height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 22),
                          )),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                            },
                            child: Container(
                            width: 42, height: 42,
                            decoration: BoxDecoration(
                              color: AppTheme.accent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(user.avatarInitials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                            ),
                          )),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_on_outlined, color: Colors.white70, size: 16),
                        SizedBox(width: 6),
                        Text(DummyData.estateName, style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      title: _showNotifications ? const Text(DummyData.estateName, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)) : null,
      actions: _showNotifications ? [
        IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.white), onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
        }),
        const SizedBox(width: 4),
      ] : null,
    );
  }

  Widget _buildQuickStats(NumberFormat fmt) {
    final paidCount = DummyData.payments.where((p) => p.status == PaymentStatus.paid).length;
    final openIncidents = DummyData.incidents.where((i) => i.status != IncidentStatus.resolved).length;
    final todayVisitors = DummyData.visitors.where((v) => v.lastAction == AccessType.entry && v.hostName == DummyData.currentUser.name).length;

    return GridView.count(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        StatCard(label: 'Total Members', value: '${DummyData.members.length}', icon: Icons.people_rounded, color: AppTheme.secondary, subtitle: '+2 this month'),
        StatCard(label: 'Collected (₦)', value: '${fmt.format(DummyData.totalCollected / 1000)}K', icon: Icons.account_balance_wallet_rounded, color: AppTheme.accent),
        StatCard(label: 'Open Issues', value: '$openIncidents', icon: Icons.report_problem_rounded, color: AppTheme.error),
        StatCard(label: 'Your Visitors Today', value: '$todayVisitors', icon: Icons.person_pin_rounded, color: AppTheme.info),
      ],
    );
  }

  Widget _buildNoticesBanner(BuildContext context) {
    final pinned = DummyData.notices.where((n) => n.isPinned).toList();
    if (pinned.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 120,
          child: PageView.builder(
            controller: _noticeController,
            itemCount: pinned.length,
            onPageChanged: (index) => setState(() => _noticeIndex = index),
            itemBuilder: (_, index) {
              final item = pinned[index];
              return GestureDetector(
                onTap: () => _showNoticeOverlay(context, item),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.accent.withOpacity(0.15), AppTheme.accent.withOpacity(0.05)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.accent.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(color: AppTheme.accent.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.campaign_rounded, color: AppTheme.accent, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: AppTheme.accent, borderRadius: BorderRadius.circular(4)),
                                  child: const Text('PINNED', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                                ),
                                const SizedBox(width: 6),
                                Text(item.category.toUpperCase(), style: const TextStyle(fontSize: 10, color: AppTheme.textMid, fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(item.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textDark), maxLines: 2, overflow: TextOverflow.ellipsis),
                            Text(item.body, style: const TextStyle(fontSize: 12, color: AppTheme.textMid), maxLines: 2, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppTheme.textMid),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(pinned.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _noticeIndex == index ? 22 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _noticeIndex == index ? AppTheme.accent : AppTheme.accent.withOpacity(0.35),
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        ),
      ],
    );
  }

  void _showNoticeOverlay(BuildContext context, Notice notice) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 52),
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
                    child: const Icon(Icons.campaign_rounded, color: AppTheme.accent, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(notice.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  StatusBadge(label: notice.category, color: AppTheme.accent),
                  const SizedBox(width: 10),
                  Text('Posted by ${notice.postedBy}', style: const TextStyle(fontSize: 12, color: AppTheme.textMid)),
                  const Spacer(),
                  Text(DateFormat('dd MMM yyyy').format(notice.postedAt), style: const TextStyle(fontSize: 12, color: AppTheme.textMid)),
                ],
              ),
              const SizedBox(height: 18),
              Text(notice.body, style: const TextStyle(fontSize: 14, height: 1.6, color: AppTheme.textDark)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'icon': Icons.payment_rounded, 'label': 'Pay Dues', 'color': AppTheme.success, 'page': const DuePaymentScreen()},
      {'icon': Icons.report_rounded, 'label': 'Report Issue', 'color': AppTheme.error, 'page': const MainApp(pageIndex: 4,)},
      {'icon': Icons.how_to_reg_rounded, 'label': 'Gate Pass', 'color': AppTheme.info, 'page': const MainApp(pageIndex: 3,)},
      {'icon': Icons.book_online_rounded, 'label': 'Book Facility', 'color': AppTheme.accent, 'page': const FacilitiesScreen()},
      {'icon': Icons.store_rounded, 'label': 'Marketplace', 'color': AppTheme.secondary, 'page': const MarketplaceScreen()},
      {'icon': Icons.chat_bubble_outline_rounded, 'label': 'Group Chat', 'color': const Color(0xFF8E44AD), 'page': const GroupChatScreen()},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Quick Actions'),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          padding: EdgeInsets.zero, 
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1,
          children: actions.map((a) {
            final color = a['color'] as Color;
            final page = a['page'] as Widget;
            return GestureDetector(
              onTap: () {
                if (page is MainApp) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => page),
                        (route) => false,
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => page),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.divider),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                      child: Icon(a['icon'] as IconData, color: color, size: 22),
                    ),
                    const SizedBox(height: 8),
                    Text(a['label'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textDark), textAlign: TextAlign.center),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRecentIncidents() {
    final recent = DummyData.incidents.where((i) => i.status != IncidentStatus.resolved).take(3).toList();
    return Column(
      children: recent.map((i) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.divider),
          ),
          child: Row(
            children: [
              Container(
                width: 8, height: 8,
                decoration: BoxDecoration(color: priorityColor(i.priority), shape: BoxShape.circle),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(i.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text('${i.location} · ${i.reportedBy.split(' ')[0]}', style: const TextStyle(fontSize: 11, color: AppTheme.textMid)),
                  ],
                ),
              ),
              StatusBadge(label: incidentStatusLabel(i.status), color: incidentStatusColor(i.status)),
            ],
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildPaymentOverview(NumberFormat fmt) {
    final paid = DummyData.payments.where((p) => p.status == PaymentStatus.paid).length;
    final pending = DummyData.payments.where((p) => p.status == PaymentStatus.pending).length;
    final overdue = DummyData.payments.where((p) => p.status == PaymentStatus.overdue).length;
    final total = DummyData.payments.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _paymentStat('${(paid / total * 100).round()}%', 'Paid', AppTheme.success),
              Container(width: 1, height: 40, color: AppTheme.divider),
              _paymentStat('$pending', 'Pending', AppTheme.warning),
              Container(width: 1, height: 40, color: AppTheme.divider),
              _paymentStat('$overdue', 'Overdue', AppTheme.error),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: paid / total,
              backgroundColor: AppTheme.divider,
              valueColor: const AlwaysStoppedAnimation(AppTheme.success),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('₦${fmt.format(DummyData.totalCollected)} collected', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.success)),
              Text('of ₦${fmt.format(DummyData.totalExpected)} expected', style: const TextStyle(fontSize: 12, color: AppTheme.textMid)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _paymentStat(String value, String label, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: color)),
        Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textMid)),
      ],
    );
  }
}
