import 'dart:async';

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _showPassword = false;
  String? _errorMessage;

  final PageController _sliderController = PageController();
  Timer? _sliderTimer;
  int _slideIndex = 0;
  static const _sliderImages = [
    'assets/img2.jpeg',
    'assets/img1.jpeg',
    'assets/img3.jpeg',
  ];

  static const _demoCredentials = {
    'adaeze@email.com': 'password123',
  };

  @override
  void initState() {
    super.initState();
    _sliderTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final nextPage = (_slideIndex + 1) % _sliderImages.length;
      _sliderController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _sliderTimer?.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    _sliderController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final expected = _demoCredentials[email];

      if (expected == null || expected != password) {
        setState(() {
          _loading = false;
          _errorMessage = 'Invalid email or password. Try adaeze@email.com / password123';
        });
        return;
      }

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/main');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: SizedBox(
                      width: 380,
                      height: 380,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            PageView.builder(
                              controller: _sliderController,
                              itemCount: _sliderImages.length,
                              onPageChanged: (index) => setState(() => _slideIndex = index),
                              itemBuilder: (context, index) => Image.asset(
                                _sliderImages[index],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.25),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                            Center(
                              child:  Container(
                                width: 72, height: 72,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.4), blurRadius: 24, offset: const Offset(0, 8))],
                                ),
                                child: Image.asset('assets/logo.png'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text('Welcome back', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.textDark)),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to view your estate dashboard and activities.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textMid),
                  ),
                  const SizedBox(height: 32),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _inputDecoration(icon: Icons.email_outlined, label: 'Email address'),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Enter your email address';
                            if (!value.contains('@')) return 'Enter a valid email address';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_showPassword,
                          decoration: _inputDecoration(icon: Icons.lock_outline, label: 'Password').copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showPassword ? Icons.visibility : Icons.visibility_off,
                                color: AppTheme.textMid,
                              ),
                              onPressed: () => setState(() => _showPassword = !_showPassword),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Enter your password';
                            if (value.length < 6) return 'Password must be at least 6 characters';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 18),
                    Text(_errorMessage!, style: const TextStyle(color: AppTheme.error, fontSize: 13), textAlign: TextAlign.center),
                  ],
                  const SizedBox(height: 28),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: _loading
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('Log in', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Need help? Contact estate admin to set up your account.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textMid),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '...powered by Corvanta',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppTheme.textMid),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Demo credentials: adaeze@email.com / password123',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppTheme.textMid),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required IconData icon, required String label}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppTheme.textMid),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppTheme.accent, width: 1.5),
      ),
    );
  }
}
