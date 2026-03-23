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
    final profile = ref.watch(profileProvider);
    _seedControllers(profile);
    return LexiconScaffold(
      title: 'Profile',
      child: AsyncValueView(
        value: profile,
        data: (user) => ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 38,
                          backgroundImage: user.profileImage != null ? NetworkImage(user.profileImage!) : null,
                          child: user.profileImage == null ? Text(user.displayName.characters.first.toUpperCase()) : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.displayName, style: Theme.of(context).textTheme.headlineMedium),
                              Text('${user.role} • ${user.status}'),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
                            if (picked == null) return;
                            await ref.read(profileRepositoryProvider).uploadAvatar(picked);
                            ref.invalidate(profileProvider);
                          },
                          icon: const Icon(Icons.photo_camera_back_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
                    const SizedBox(height: 16),
                    TextField(controller: _surnameController, decoration: const InputDecoration(labelText: 'Surname')),
                    const SizedBox(height: 16),
                    TextField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Username')),
                    const SizedBox(height: 16),
                    TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
                    const SizedBox(height: 20),
                    FilledButton(
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profile updated')),
                          );
                        }
                      },
                      child: const Text('Save profile'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
