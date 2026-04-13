import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class MemberProfileScreen extends StatelessWidget {
  final EstateMember member;

  const MemberProfileScreen({super.key, required this.member});

  Color _roleColor(MemberRole role) {
    switch (role) {
      case MemberRole.exco:
        return AppTheme.accent;
      case MemberRole.owner:
        return AppTheme.secondary;
      case MemberRole.tenant:
        return AppTheme.info;
      case MemberRole.facilityManager:
        return AppTheme.success;
      case MemberRole.securityPersonnel:
        return AppTheme.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,###');
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppTheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primary, AppTheme.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 18),
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppTheme.accent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: Center(
                          child: Text(
                            member.avatarInitials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(member.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text('Unit ${member.unitNumber} · ${member.roleLabel}', style: TextStyle(color: Colors.white.withOpacity(0.82), fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ),
            title: const Text('Member Profile'),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppTheme.divider),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Contact', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 14),
                      _infoRow(Icons.email_outlined, 'Email', member.email),
                      const Divider(height: 1, color: AppTheme.divider),
                      _infoRow(Icons.phone_outlined, 'Phone', member.phone),
                      const Divider(height: 1, color: AppTheme.divider),
                      _infoRow(Icons.home_outlined, 'Unit', member.unitNumber),
                      const SizedBox(height: 20),
                      const Text('Member details', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 14),
                      _infoRow(Icons.calendar_month_outlined, 'Member Since', DateFormat('MMMM yyyy').format(member.joinDate)),
                      const Divider(height: 1, color: AppTheme.divider),
                      Row(
                        children: [
                          const Icon(Icons.verified_outlined, size: 18, color: AppTheme.success),
                          const SizedBox(width: 10),
                          Text(
                            member.isVerified ? 'Verified member' : 'Unverified member',
                            style: const TextStyle(fontSize: 13, color: AppTheme.textMid),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppTheme.textMid),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textMid)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
