import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});
  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  String _search = '';
  MemberRole? _filterRole;

  List<EstateMember> get filtered => DummyData.members.where((m) {
    final matchSearch = _search.isEmpty || m.name.toLowerCase().contains(_search.toLowerCase()) || m.unitNumber.toLowerCase().contains(_search.toLowerCase());
    final matchRole = _filterRole == null || m.role == _filterRole;
    return matchSearch && matchRole;
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EstateAppBar(
        title: 'Members',
        actions: [
          if (DummyData.currentUser.role == MemberRole.exco)
          IconButton(icon: const Icon(Icons.person_add_alt_rounded, color: Colors.white), onPressed: () => _showAddMemberSheet(context)),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: filtered.isEmpty
                ? const EmptyState(icon: Icons.people_outline, message: 'No members found')
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => _MemberCard(member: filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        children: [
          TextField(
            onChanged: (v) => setState(() => _search = v),
            decoration: const InputDecoration(
              hintText: 'Search by name or unit…',
              prefixIcon: Icon(Icons.search_rounded, color: AppTheme.textMid),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _chip('All', null),
                _chip('Owners', MemberRole.owner),
                _chip('Tenants', MemberRole.tenant),
                _chip('Excos', MemberRole.exco),
                _chip('FM Staffs', MemberRole.facilityManager),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, MemberRole? role) {
    final selected = _filterRole == role;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => setState(() => _filterRole = role),
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

  void _showAddMemberSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add New Member', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            const TextField(decoration: InputDecoration(labelText: 'Full Name')),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Email Address')),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Phone Number')),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Unit Number (e.g. A-101)')),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Send Invitation'))),
          ],
        ),
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final EstateMember member;
  const _MemberCard({required this.member});

  Color _roleColor() {
    switch (member.role) {
      case MemberRole.exco: return AppTheme.accent;
      case MemberRole.owner: return AppTheme.secondary;
      case MemberRole.tenant: return AppTheme.info;
      case MemberRole.facilityManager: return AppTheme.success;
      case MemberRole.securityPersonnel: return AppTheme.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Stack(
          children: [
            MemberAvatar(initials: member.avatarInitials, color: _roleColor()),
            if (member.isVerified)
              Positioned(
                right: 0, bottom: 0,
                child: Container(
                  width: 14, height: 14,
                  decoration: const BoxDecoration(color: AppTheme.success, shape: BoxShape.circle),
                  child: const Icon(Icons.check, color: Colors.white, size: 9),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Text(member.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${member.unitNumber} · ${member.phone}', style: const TextStyle(fontSize: 12, color: AppTheme.textMid)),
            const SizedBox(height: 4),
            StatusBadge(label: member.roleLabel, color: _roleColor()),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert_rounded, color: AppTheme.textMid),
          onPressed: () => _showMemberOptions(context),
        ),
      ),
    );
  }

  void _showMemberOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 16),
              child: Text(member.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
            _option(context, Icons.visibility_outlined, 'View Profile', AppTheme.secondary),
            _option(context, Icons.chat_outlined, 'Send Message', AppTheme.info),
            _option(context, Icons.block_outlined, 'Report Account', AppTheme.error),
          ],
        ),
      ),
    );
  }

  Widget _option(BuildContext ctx, IconData icon, String label, Color color) {
    return ListTile(
      leading: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(9)),
        child: Icon(icon, color: color, size: 18),
      ),
      title: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      onTap: () => Navigator.pop(ctx),
    );
  }
}
