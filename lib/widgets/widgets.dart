import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

// ── Stat Card ──────────────────────────────────────────────────────────────
class StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  final String? subtitle;

  const StatCard({
    super.key,
    required this.label, required this.value,
    required this.icon, required this.color, this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              if (subtitle != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(subtitle!, style: const TextStyle(fontSize: 11, color: AppTheme.success, fontWeight: FontWeight.w600)),
                ),
            ],
          ),
              const Spacer(),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.textDark)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textMid)),
        ],
      ),
    );
  }
}

// ── Avatar ─────────────────────────────────────────────────────────────────
class MemberAvatar extends StatelessWidget {
  final String initials;
  final double size;
  final Color? color;

  const MemberAvatar({super.key, required this.initials, this.size = 44, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        color: (color ?? AppTheme.secondary).withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: size * 0.35,
            fontWeight: FontWeight.w700,
            color: color ?? AppTheme.secondary,
          ),
        ),
      ),
    );
  }
}

// ── Status Badge ───────────────────────────────────────────────────────────
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const StatusBadge({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }
}

// ── Section Header ─────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({super.key, required this.title, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            child: Text(actionLabel!, style: const TextStyle(fontSize: 13, color: AppTheme.accent, fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }
}

// ── Payment Status Color ───────────────────────────────────────────────────
Color paymentStatusColor(PaymentStatus s) {
  switch (s) {
    case PaymentStatus.paid: return AppTheme.success;
    case PaymentStatus.pending: return AppTheme.warning;
    case PaymentStatus.overdue: return AppTheme.error;
  }
}

String paymentStatusLabel(PaymentStatus s) {
  switch (s) {
    case PaymentStatus.paid: return 'Paid';
    case PaymentStatus.pending: return 'Pending';
    case PaymentStatus.overdue: return 'Overdue';
  }
}

Color incidentStatusColor(IncidentStatus s) {
  switch (s) {
    case IncidentStatus.open: return AppTheme.error;
    case IncidentStatus.inProgress: return AppTheme.warning;
    case IncidentStatus.resolved: return AppTheme.success;
  }
}

String incidentStatusLabel(IncidentStatus s) {
  switch (s) {
    case IncidentStatus.open: return 'Open';
    case IncidentStatus.inProgress: return 'In Progress';
    case IncidentStatus.resolved: return 'Resolved';
  }
}

Color priorityColor(TicketPriority p) {
  switch (p) {
    case TicketPriority.low: return AppTheme.info;
    case TicketPriority.medium: return AppTheme.warning;
    case TicketPriority.high: return AppTheme.error;
    case TicketPriority.urgent: return const Color(0xFF8E44AD);
  }
}

// ── App Bar with avatar ────────────────────────────────────────────────────
class EstateAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;

  const EstateAppBar({super.key, required this.title, this.showBack = false, this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: showBack
          ? IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => Navigator.pop(context))
          : null,
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: Colors.white.withOpacity(0.1)),
      ),
    );
  }
}

// ── Empty State ────────────────────────────────────────────────────────────
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const EmptyState({super.key, required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppTheme.textLight),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: AppTheme.textMid, fontSize: 14)),
        ],
      ),
    );
  }
}
