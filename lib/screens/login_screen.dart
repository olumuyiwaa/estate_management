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

  static const _demoCredentials = {
    'adaeze@email.com': 'password123',
  };

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                    child: Container(
                    width: 380,
                    height: 380,
                    decoration: BoxDecoration(
                      color: AppTheme.accent,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: AppTheme.accent.withOpacity(0.25), blurRadius: 16, offset: const Offset(0, 8)),
                      ],
                    ),
                    child: const Icon(Icons.domain_rounded, size: 40, color: Colors.white),
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
                        backgroundColor: AppTheme.primary,
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
