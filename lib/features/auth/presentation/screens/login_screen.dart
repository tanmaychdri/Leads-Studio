import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leads_studio/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:leads_studio/core/widgets/glass/ambient_background.dart';
import 'package:leads_studio/core/widgets/glass/glass_container.dart';
import 'package:leads_studio/core/widgets/glass/glass_button.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Stack(
      children: [
        const AmbientBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: GlassContainer(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/Leads Studio Dark.png',
                          height: 64,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.business_center, size: 64, color: Color(0xFF107C41)),
                        ),
                      ).animate().fade(duration: 600.ms, curve: Curves.easeOut).scale(delay: 100.ms),
                      
                      const SizedBox(height: 32),
                      
                      // App Title
                      Text(
                        'Leads Studio',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fade(duration: 600.ms, delay: 200.ms).slideY(begin: 0.2, end: 0),
                      
                      const SizedBox(height: 8),
                      Text(
                        'Manage your leads from Google Drive',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fade(duration: 600.ms, delay: 300.ms),
                      
                      const SizedBox(height: 48),
                      
                      // Status/Error Messages
                      if (authState.error != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: Theme.of(context).colorScheme.onErrorContainer),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  authState.error!,
                                  style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
                                ),
                              ),
                            ],
                          ),
                        ).animate().fade(duration: 300.ms),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        child: GlassButton(
                          isPrimary: false,
                          onPressed: authState.isLoading ? () {} : () => ref.read(authProvider.notifier).signIn(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: authState.isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/google_logo.png',
                                      height: 24,
                                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.account_circle, size: 24),
                                    ),
                                    const SizedBox(width: 12),
                                    const Flexible(
                                      child: Text(
                                        'Continue with Google',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                          ),
                        ),
                      ).animate().fade(duration: 600.ms, delay: 400.ms).slideY(begin: 0.2, end: 0),
                      
                      const SizedBox(height: 32),
                      
                      // Footer
                      Text(
                        'By continuing, you agree to our Terms of Service\nand Privacy Policy.',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fade(duration: 600.ms, delay: 500.ms),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}