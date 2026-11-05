import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/models/models.dart';
import '../../core/widgets/campus_drawer.dart';
import '../auth/auth_controller.dart';

class _ShellTab {
  const _ShellTab({
    required this.branch,
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final int branch;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

/// Students keep the personal attendance tab. Staff do not.
List<_ShellTab> _tabsFor(AuthState auth) {
  final studentTabs = auth.initialized && auth.role.isStudent;
  return [
    const _ShellTab(
      branch: 0,
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
    ),
    if (studentTabs)
      const _ShellTab(
        branch: 1,
        label: 'Attendance',
        icon: Icons.fact_check_outlined,
        selectedIcon: Icons.fact_check_rounded,
      ),
    const _ShellTab(
      branch: 2,
      label: 'Timetable',
      icon: Icons.schedule_outlined,
      selectedIcon: Icons.schedule_rounded,
    ),
    const _ShellTab(
      branch: 3,
      label: 'Notices',
      icon: Icons.article_outlined,
      selectedIcon: Icons.article_rounded,
    ),
    const _ShellTab(
      branch: 4,
      label: 'More',
      icon: Icons.grid_view_outlined,
      selectedIcon: Icons.grid_view_rounded,
    ),
  ];
}

class MainShell extends ConsumerWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = ref.watch(authControllerProvider);
    final tabs = _tabsFor(auth);
    var selected = tabs.indexWhere(
      (tab) => tab.branch == navigationShell.currentIndex,
    );
    if (selected < 0) selected = 0;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      drawer: const CampusDrawer(),
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkNavBar : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.borderLight,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: selected,
          onDestinationSelected: (index) {
            final branch = tabs[index].branch;
            navigationShell.goBranch(
              branch,
              initialLocation: branch == navigationShell.currentIndex,
            );
          },
          destinations: [
            for (final tab in tabs)
              NavigationDestination(
                icon: Icon(tab.icon),
                selectedIcon: Icon(tab.selectedIcon),
                label: tab.label,
              ),
          ],
        ),
      ),
    );
  }
}
