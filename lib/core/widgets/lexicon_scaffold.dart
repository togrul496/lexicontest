import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routing/app_routes.dart';

class LexiconScaffold extends StatelessWidget {
  const LexiconScaffold({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.floatingActionButton,
    this.showBackButton,
    this.onBack,
    this.fallbackRoute,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  final String title;
  final Widget child;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool? showBackButton;
  final VoidCallback? onBack;
  final String? fallbackRoute;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    const bgDark = Color(0xFF0F172A);
    const bgCard = Color(0xFF1E293B);
    const textPrimary = Color(0xFFF1F5F9);
    const primary = Color(0xFF2563EB);
    const green = Color(0xFF10B981);

    final canPop = GoRouter.of(context).canPop();
    final shouldShowBack = showBackButton ?? canPop;

    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        backgroundColor: bgCard,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        leading: shouldShowBack
            ? IconButton(
                onPressed: onBack ?? () {
                  if (canPop) {
                    context.pop();
                  } else {
                    context.go(fallbackRoute ?? AppRoutes.home.path);
                  }
                },
                icon: const Icon(Icons.arrow_back_rounded),
              )
            : null,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: actions,
      ),
      floatingActionButton: floatingActionButton,
      body: DecoratedBox(
        decoration: const BoxDecoration(color: bgDark),
        child: Stack(
          children: [
            Positioned(
              left: -60,
              top: -60,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primary.withValues(alpha: 0.10),
                ),
              ),
            ),
            Positioned(
              right: -40,
              bottom: -40,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: green.withValues(alpha: 0.08),
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: padding,
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

