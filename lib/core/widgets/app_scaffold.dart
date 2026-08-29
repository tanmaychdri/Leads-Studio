import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leads_studio/features/auth/presentation/providers/auth_provider.dart';
import 'package:leads_studio/core/widgets/glass/ambient_background.dart';
import 'package:leads_studio/core/widgets/glass/glass_navigation.dart';
import 'package:leads_studio/core/widgets/glass/glass_container.dart';
import 'package:leads_studio/core/theme/glass_theme.dart';
import 'package:leads_studio/app/theme/app_colors.dart';

class AppScaffold extends ConsumerWidget {
  const AppScaffold({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  void _onNavigate(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = MediaQuery.of(context).size.width >= 768; // Adjusted breakpoint for glass layout
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final profileMenu = GestureDetector(
      onTap: () {
        showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel: 'Dismiss',
          barrierColor: Colors.transparent, // No dimming for glassmorphism
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (context, animation, secondaryAnimation) {
            return Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 80, right: 16),
                child: Material(
                  color: Colors.transparent,
                  child: GlassContainer(
                    width: 250,
                    opacity: 0.2,
                    border: true,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.displayName ?? 'User',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                user?.email ?? '',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Divider(color: GlassTheme.getBorderColor(context)),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            context.push('/settings');
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                Icon(Icons.settings, size: 20),
                                SizedBox(width: 12),
                                Text('Settings'),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            ref.read(authProvider.notifier).signOut();
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                Icon(Icons.logout, color: Colors.red, size: 20),
                                SizedBox(width: 12),
                                Text('Sign Out', style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          transitionBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, -0.05), end: Offset.zero).animate(animation),
                child: child,
              ),
            );
          },
        );
      },
      child: CircleAvatar(
        radius: 20,
        backgroundColor: AppColors.primaryAccent.withValues(alpha: 0.2),
        backgroundImage: user?.photoUrl != null ? NetworkImage(user!.photoUrl!) : null,
        child: user?.photoUrl == null 
            ? const Icon(Icons.person, color: AppColors.primaryAccent)
            : null,
      ),
    );

    Widget scaffoldContent = isDesktop
        ? Row(
            children: [
              // Glass Sidebar
              Container(
                width: 250,
                margin: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
                child: GlassContainer(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.bubble_chart, color: AppColors.primaryAccent, size: 32),
                          const SizedBox(width: 12),
                          const Text(
                            'Leads Studio',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 48),
                      _SidebarItem(
                        icon: Icons.dashboard_outlined,
                        selectedIcon: Icons.dashboard,
                        label: 'Dashboard',
                        isSelected: navigationShell.currentIndex == 0,
                        onTap: () => _onNavigate(0),
                      ),
                      const SizedBox(height: 12),
                      _SidebarItem(
                        icon: Icons.people_outline,
                        selectedIcon: Icons.people,
                        label: 'Leads',
                        isSelected: navigationShell.currentIndex == 1,
                        onTap: () => _onNavigate(1),
                      ),
                      const SizedBox(height: 12),
                      _SidebarItem(
                        icon: Icons.calendar_today_outlined,
                        selectedIcon: Icons.calendar_today,
                        label: 'Follow-ups',
                        isSelected: navigationShell.currentIndex == 2,
                        onTap: () => _onNavigate(2),
                      ),
                      const Spacer(),
                      const Divider(color: Colors.white24),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          profileMenu,
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.displayName ?? 'User',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Text(
                                  'My Account',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: navigationShell,
                ),
              ),
            ],
          )
        : SafeArea(
            bottom: false,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Leads Studio',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      profileMenu,
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      navigationShell,
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: GlassNavigationBar(
                          selectedIndex: navigationShell.currentIndex,
                          onDestinationSelected: _onNavigate,
                          destinations: const [
                            GlassNavigationDestination(
                              icon: Icons.dashboard_outlined,
                              selectedIcon: Icons.dashboard,
                              label: 'Dashboard',
                            ),
                            GlassNavigationDestination(
                              icon: Icons.people_outline,
                              selectedIcon: Icons.people,
                              label: 'Leads',
                            ),
                            GlassNavigationDestination(
                              icon: Icons.calendar_today_outlined,
                              selectedIcon: Icons.calendar_today,
                              label: 'Follow-ups',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );

    return PopScope(
      canPop: navigationShell.currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (navigationShell.currentIndex != 0) {
          navigationShell.goBranch(0);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent, // Important for ambient background
        body: Stack(
          children: [
            AmbientBackground(pageIndex: navigationShell.currentIndex),
            scaffoldContent,
          ],
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryAccent.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected ? AppColors.primaryAccent : Colors.grey,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected 
                    ? AppColors.primaryAccent 
                    : (Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}