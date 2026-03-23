import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../auth/data/auth_repository.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionControllerProvider);
    const bgDark = Color(0xFF0F172A);
    const bgCard = Color(0xFF1E293B);
    const primary = Color(0xFF2563EB);
    const green = Color(0xFF10B981);
    const amber = Color(0xFFF59E0B);
    const violet = Color(0xFF8B5CF6);
    const textPrimary = Color(0xFFF1F5F9);
    const textSecondary = Color(0xFF94A3B8);

    final quickLinks = [
      _QuickLink('Dersler', 'Movzularla davam et', Icons.menu_book_rounded, primary, () => context.push(AppRoutes.lessons.path)),
      _QuickLink('Lugat', 'Gunluk soz bloklari', Icons.translate_rounded, green, () => context.push(AppRoutes.dictionary.path)),
      _QuickLink('Testler', 'Imtahan ve neticeler', Icons.quiz_rounded, amber, () => context.push(AppRoutes.tests.path)),
      _QuickLink('Onlayn testler', 'Quiz sessiyalari', Icons.emoji_events_rounded, violet, () => context.push(AppRoutes.quizSessions.path)),
    ];

    return Scaffold(
      backgroundColor: bgDark,
      bottomNavigationBar: NavigationBar(
        backgroundColor: bgCard,
        selectedIndex: 0,
        indicatorColor: primary.withValues(alpha: 0.18),
        onDestinationSelected: (index) {
          switch (index) {
            case 1:
              context.push(AppRoutes.lessons.path);
              break;
            case 2:
              context.push(AppRoutes.dictionary.path);
              break;
            case 3:
              context.push(AppRoutes.tests.path);
              break;
            case 4:
              context.push(AppRoutes.profile.path);
              break;
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.menu_book_rounded), label: 'Lessons'),
          NavigationDestination(icon: Icon(Icons.translate_rounded), label: 'Dictionary'),
          NavigationDestination(icon: Icon(Icons.quiz_rounded), label: 'Tests'),
          NavigationDestination(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            left: -60,
            top: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(shape: BoxShape.circle, color: primary.withValues(alpha: 0.12)),
            ),
          ),
          Positioned(
            right: -50,
            bottom: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(shape: BoxShape.circle, color: green.withValues(alpha: 0.08)),
            ),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(colors: [primary, Color(0xFF1D4ED8), Color(0xFF0EA5E9)]),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white.withValues(alpha: 0.18),
                        child: Text(
                          (session.user?.displayName ?? 'L').characters.first.toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Salam, ${session.user?.displayName ?? 'Istifadeci'}',
                              style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Bu gun ne oyreneceksiniz?',
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => context.push(AppRoutes.notifications.path),
                        icon: const Icon(Icons.notifications_rounded, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Suretli kecid', style: TextStyle(color: textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.02,
                  ),
                  itemCount: quickLinks.length,
                  itemBuilder: (_, index) {
                    final item = quickLinks[index];
                    return Card(
                      color: bgCard,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: item.onTap,
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: item.color.withValues(alpha: 0.16),
                                child: Icon(item.icon, color: item.color),
                              ),
                              const Spacer(),
                              Text(item.title, style: const TextStyle(color: textPrimary, fontSize: 17, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 6),
                              Text(item.subtitle, style: const TextStyle(color: textSecondary, fontSize: 12.5)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 18),
                Card(
                  color: bgCard,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person_rounded, color: textPrimary),
                        title: const Text('Profil', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700)),
                        subtitle: const Text('Hesab melumatlarina bax ve redakte et', style: TextStyle(color: textSecondary)),
                        trailing: const Icon(Icons.chevron_right_rounded, color: textSecondary),
                        onTap: () => context.push(AppRoutes.profile.path),
                      ),
                      const Divider(height: 1, color: Color(0xFF334155)),
                      ListTile(
                        leading: const Icon(Icons.settings_rounded, color: textPrimary),
                        title: const Text('Tenzimlemeler', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700)),
                        subtitle: const Text('Dil, tema ve davranis secimleri', style: TextStyle(color: textSecondary)),
                        trailing: const Icon(Icons.chevron_right_rounded, color: textSecondary),
                        onTap: () => context.push(AppRoutes.settings.path),
                      ),
                      const Divider(height: 1, color: Color(0xFF334155)),
                      ListTile(
                        leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                        title: const Text('Cixis', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w700)),
                        onTap: () => ref.read(sessionControllerProvider.notifier).signOut(),
                      ),
                    ],
                  ),
                ),
                if (session.isAdmin) ...[
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => context.go(AppRoutes.adminRoot.path),
                    icon: const Icon(Icons.admin_panel_settings_rounded),
                    label: const Text('Admin paneli ac'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickLink {
  const _QuickLink(this.title, this.subtitle, this.icon, this.color, this.onTap);

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}

