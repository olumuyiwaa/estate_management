import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/members_screen.dart';
import 'screens/finance_screen.dart';
import 'screens/security_screen.dart';
import 'screens/incidents_screen.dart';
import 'screens/more_screens.dart';
import 'screens/group_chat_screen.dart';
import 'screens/meetings_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/notifications_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const EstateApp());
}

class EstateApp extends StatelessWidget {
  const EstateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emerald Gardens Estate',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (_) => const LoginScreen(),
        '/main': (_) => MainApp(),
      },
      home: const SplashScreen(),
    );
  }
}

// ── Splash ─────────────────────────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade, _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _scale = Tween(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _ctrl.forward();
    Future.delayed(const Duration(seconds: 2, milliseconds: 500), () {
      if (mounted) Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primary, AppTheme.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 90, height: 90,
                    decoration: BoxDecoration(
                      color: AppTheme.accent,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: AppTheme.accent.withOpacity(0.4), blurRadius: 24, offset: const Offset(0, 8))],
                    ),
                    child: const Icon(Icons.domain_rounded, size: 48, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Emerald Gardens',
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Estate Management',
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 15),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: 32,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation(AppTheme.accent),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Main Shell ─────────────────────────────────────────────────────────────
class MainApp extends StatefulWidget {
  final int pageIndex;

  const MainApp({super.key, this.pageIndex = 0});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late int _idx;

  @override
  void initState() {
    super.initState();
    _idx = widget.pageIndex;
  }

  // Pages accessible via more drawer
  static final _pages = <Widget>[
    const DashboardScreen(),
    const MembersScreen(),
    const FinanceScreen(),
    const SecurityScreen(),
    const IncidentsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _idx, children: _pages),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppTheme.divider)),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, -2))],
        ),
        child: BottomNavigationBar(
          currentIndex: _idx,
          onTap: (i) => setState(() => _idx = i),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard_rounded), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.people_outline_rounded), activeIcon: Icon(Icons.people_rounded), label: 'Members'),
            BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), activeIcon: Icon(Icons.account_balance_wallet_rounded), label: 'Finance'),
            BottomNavigationBarItem(icon: Icon(Icons.security_outlined), activeIcon: Icon(Icons.security_rounded), label: 'Security'),
            BottomNavigationBarItem(icon: Icon(Icons.report_problem_outlined), activeIcon: Icon(Icons.report_problem_rounded), label: 'Issues'),
          ],
        ),
      ),
      // FAB-style "More" button to access extra sections
      floatingActionButton: _idx == 0 ? FloatingActionButton(
        onPressed: () => _showMoreMenu(context),
        backgroundColor: AppTheme.primary,
        mini: true,
        child: const Icon(Icons.grid_view_rounded, color: Colors.white, size: 20),
      ) : null,
    );
  }

  void _showMoreMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8, bottom: 16),
              child: Text('More Features', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _moreItem(context, Icons.notifications_rounded, 'Notifications', AppTheme.secondary, const NotificationsScreen()),
                _moreItem(context, Icons.book_online_rounded, 'Facilities', AppTheme.info, const FacilitiesScreen()),
                _moreItem(context, Icons.store_rounded, 'Market', AppTheme.success, const MarketplaceScreen()),
                _moreItem(context, Icons.business_center_rounded, 'Vendors', AppTheme.accent, const VendorsScreen()),
                _moreItem(context, Icons.person_rounded, 'Profile', AppTheme.secondary, const ProfileScreen()),
                _moreItem(context, Icons.chat_bubble_outline_rounded, 'Group Chat', const Color(0xFF8E44AD), const GroupChatScreen()),
                _moreItem(context, Icons.groups_rounded, 'Meetings', AppTheme.error, const MeetingsScreen()),
                _moreItem(context, Icons.settings_rounded, 'Settings', AppTheme.textMid, const SettingsScreen()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _moreItem(BuildContext ctx, IconData icon, String label, Color color, Widget? screen) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(ctx);
        if (screen != null) {
          Navigator.push(ctx, MaterialPageRoute(builder: (_) => screen));
        }
      },
      child: Column(
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppTheme.textDark), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
