import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/lexicon_scaffold.dart';
import '../../auth/data/auth_repository.dart';
import '../data/profile_repository.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _seedControllers(AsyncValue<dynamic> profile) {
    profile.whenData((user) {
      if (_initialized) return;
      _nameController.text = user.name ?? '';
      _surnameController.text = user.surname ?? '';
      _usernameController.text = user.username;
      _emailController.text = user.email;
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    const textPrimary = Color(0xFFF1F5F9);
    const textSecondary = Color(0xFF94A3B8);
    const primary = Color(0xFF2563EB);
    const amber = Color(0xFFF59E0B);
    const red = Color(0xFFEF4444);

    final profile = ref.watch(profileProvider);
    _seedControllers(profile);

    return LexiconScaffold(
      title: 'Profilim',
      fallbackRoute: '/home',
      actions: [
        IconButton(
          onPressed: () => ref.read(sessionControllerProvider.notifier).signOut(),
          icon: const Icon(Icons.logout_rounded),
        ),
      ],
      child: AsyncValueView(
        value: profile,
        data: (user) => ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundImage: user.profileImage != null ? NetworkImage(user.profileImage!) : null,
                      child: user.profileImage == null
                          ? Text(user.displayName.characters.first.toUpperCase(), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800))
                          : null,
                    ),
                    const SizedBox(height: 14),
                    Text(user.displayName, style: const TextStyle(color: textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text('@${user.username}', style: const TextStyle(color: textSecondary)),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        _InfoChip(label: user.role, color: primary),
                        _InfoChip(label: user.status, color: amber),
                      ],
                    ),
                    const SizedBox(height: 18),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if (picked == null) return;
                        await ref.read(profileRepositoryProvider).uploadAvatar(picked);
                        ref.invalidate(profileProvider);
                      },
                      icon: const Icon(Icons.photo_camera_back_rounded),
                      label: const Text('Sekli deyis'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const _SectionTitle('MELUMATLAR'),
            const SizedBox(height: 12),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Ad')),
            const SizedBox(height: 12),
            TextField(controller: _surnameController, decoration: const InputDecoration(labelText: 'Soyad')),
            const SizedBox(height: 12),
            TextField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Istifadeci adi')),
            const SizedBox(height: 12),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'E-poct')),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () async {
                final updated = await ref.read(profileRepositoryProvider).updateProfile(
                      name: _nameController.text.trim(),
                      surname: _surnameController.text.trim(),
                      username: _usernameController.text.trim(),
                      email: _emailController.text.trim(),
                    );
                await ref.read(sessionControllerProvider.notifier).updateUser(updated);
                ref.invalidate(profileProvider);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil yenilendi')));
                }
              },
              icon: const Icon(Icons.save_rounded),
              label: const Text('Melumatlari yadda saxla'),
            ),
            const SizedBox(height: 24),
            const _SectionTitle('HESAB'),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => ref.read(sessionControllerProvider.notifier).signOut(),
              icon: const Icon(Icons.logout_rounded, color: red),
              label: const Text('Cixis et', style: TextStyle(color: red)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: red.withValues(alpha: 0.5)),
                minimumSize: const Size.fromHeight(52),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFF334155))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(text, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.1)),
        ),
        const Expanded(child: Divider(color: Color(0xFF334155))),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700)),
    );
  }
}

