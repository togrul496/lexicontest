import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../data/auth_repository.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _submitting = false;
  bool _obscurePassword = true;
  String? _error;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final result = await ref.read(authRepositoryProvider).login(
            username: _usernameController.text.trim(),
            password: _passwordController.text,
          );
      await ref.read(sessionControllerProvider.notifier).signIn(result);
      if (!mounted) return;
      context.go(
        result.user.status == 'pending'
            ? AppRoutes.pending.path
            : result.user.role == 'admin'
                ? AppRoutes.adminRoot.path
                : AppRoutes.home.path,
      );
    } catch (error) {
      setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const bgDark = Color(0xFF0F172A);
    const bgCard = Color(0xFF1E293B);
    const primary = Color(0xFF2563EB);
    const green = Color(0xFF10B981);
    const textPrimary = Color(0xFFF1F5F9);
    const textSecondary = Color(0xFF94A3B8);
    const fieldBg = Color(0xFF0B1220);

    return Scaffold(
      backgroundColor: bgDark,
      body: Stack(
        children: [
          Positioned(
            left: -80,
            top: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primary.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            right: -40,
            bottom: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: green.withValues(alpha: 0.08),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: const LinearGradient(
                            colors: [primary, Color(0xFF1D4ED8), Color(0xFF0EA5E9)],
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.school_rounded, color: Colors.white, size: 42),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Xos Geldiniz',
                        style: TextStyle(color: textPrimary, fontSize: 30, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'English Academy hesab?n?za daxil olun',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: textSecondary, fontSize: 14),
                      ),
                      const SizedBox(height: 28),
                      Card(
                        color: bgCard,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: _usernameController,
                                  style: const TextStyle(color: textPrimary),
                                  decoration: const InputDecoration(
                                    labelText: 'Istifadeci adi',
                                    prefixIcon: Icon(Icons.person_rounded),
                                    fillColor: fieldBg,
                                  ),
                                  validator: (value) => value == null || value.trim().isEmpty ? 'Istifadeci adini daxil edin' : null,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  style: const TextStyle(color: textPrimary),
                                  decoration: InputDecoration(
                                    labelText: 'Sifre',
                                    prefixIcon: const Icon(Icons.lock_rounded),
                                    fillColor: fieldBg,
                                    suffixIcon: IconButton(
                                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                      icon: Icon(_obscurePassword ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                                    ),
                                  ),
                                  validator: (value) => value == null || value.isEmpty ? 'Sifreni daxil edin' : null,
                                ),
                                if (_error != null) ...[
                                  const SizedBox(height: 14),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(_error!, style: const TextStyle(color: Colors.redAccent)),
                                  ),
                                ],
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton.icon(
                                    onPressed: _submitting ? null : _submit,
                                    icon: _submitting
                                        ? const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                          )
                                        : const Icon(Icons.login_rounded),
                                    label: Text(_submitting ? 'Daxil olunur...' : 'Daxil ol'),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                OutlinedButton.icon(
                                  onPressed: () => context.push(AppRoutes.register.path),
                                  icon: const Icon(Icons.person_add_alt_1_rounded),
                                  label: const Text('Hesab yarat'),
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(52),
                                    foregroundColor: green,
                                    side: BorderSide(color: green.withValues(alpha: 0.5)),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


