import 'package:flutter/material.dart';
import 'more_screens.dart';
import 'change_password_screen.dart';
import 'activity_log_screen.dart';
import 'help_feedback_screen.dart';
import 'about_app_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailAlerts = true;
  bool _biometricLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EstateAppBar(title: 'Settings'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Preferences', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          _buildCard(
            children: [
              _buildToggle(
                label: 'Enable Notifications',
                description: 'Receive estate alerts and updates.',
                value: _notificationsEnabled,
                onChanged: (value) => setState(() => _notificationsEnabled = value),
              ),
              const Divider(height: 1),
              _buildToggle(
                label: 'Email Alerts',
                description: 'Send important updates to your inbox.',
                value: _emailAlerts,
                onChanged: (value) => setState(() => _emailAlerts = value),
              ),
              const Divider(height: 1),
              _buildToggle(
                label: 'Biometric Login',
                description: 'Use fingerprint or face unlock for access.',
                value: _biometricLogin,
                onChanged: (value) => setState(() => _biometricLogin = value),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          _buildCard(
            children: [
              _buildActionTile(Icons.person_outline_rounded, 'Manage Profile', 'Update your contact details and unit information.', const ProfileScreen()),
              const Divider(height: 1),
              _buildActionTile(Icons.lock_outline_rounded, 'Change Password', 'Secure your account with a new password.', const ChangePasswordScreen()),
              const Divider(height: 1),
              _buildActionTile(Icons.history_rounded, 'Activity Log', 'Review your recent estate activity.', const ActivityLogScreen()),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Support', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          _buildCard(
            children: [
              _buildActionTile(Icons.help_outline_rounded, 'Help & Feedback', 'Get assistance or send feedback.', const HelpFeedbackScreen()),
              const Divider(height: 1),
              _buildActionTile(Icons.info_outline_rounded, 'About Estate App', 'View app version and terms.', const AboutAppScreen()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildToggle({
    required String label,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle: Text(description, style: const TextStyle(fontSize: 12, color: AppTheme.textMid)),
      activeColor: AppTheme.accent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  Widget _buildActionTile(IconData icon, String title, String subtitle, Widget page) {
    return ListTile(
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(color: AppTheme.secondary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: AppTheme.secondary, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppTheme.textMid)),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppTheme.textMid),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
    );
  }
}
