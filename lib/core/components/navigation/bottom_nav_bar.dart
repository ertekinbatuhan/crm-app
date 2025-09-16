import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../base/base_badge.dart';

/// Navigation item model for bottom navigation
class NavItem {
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final String? badge;
  final int? badgeCount;
  final bool showDot;

  const NavItem({
    required this.label,
    required this.icon,
    this.activeIcon,
    this.badge,
    this.badgeCount,
    this.showDot = false,
  });
}

/// A custom bottom navigation bar component with consistent styling
class BottomNavBar extends StatelessWidget {
  final List<NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onItemSelected;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? elevation;
  final bool showLabels;
  final NavBarType type;
  final double? iconSize;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;

  const BottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onItemSelected,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation,
    this.showLabels = true,
    this.type = NavBarType.fixed,
    this.iconSize,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
  }) : assert(items.length >= 2, 'At least 2 navigation items required'),
       assert(currentIndex >= 0 && currentIndex < items.length);

  @override
  Widget build(BuildContext context) {
    if (type == NavBarType.material3) {
      return _buildMaterial3NavBar(context);
    }
    return _buildClassicNavBar(context);
  }

  Widget _buildClassicNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.backgroundPrimary,
        boxShadow: elevation != null && elevation! > 0
            ? [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: elevation!,
                  offset: Offset(0, -elevation! / 2),
                ),
              ]
            : null,
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: AppSpacing.bottomNavHeight,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;
              
              return Expanded(
                child: _NavBarItem(
                  item: item,
                  isSelected: isSelected,
                  onTap: () => onItemSelected(index),
                  selectedColor: selectedItemColor ?? AppColors.primary700,
                  unselectedColor: unselectedItemColor ?? AppColors.textSecondary,
                  showLabel: showLabels,
                  iconSize: iconSize,
                  selectedLabelStyle: selectedLabelStyle,
                  unselectedLabelStyle: unselectedLabelStyle,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildMaterial3NavBar(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onItemSelected,
      backgroundColor: backgroundColor ?? AppColors.backgroundPrimary,
      elevation: elevation ?? 0,
      height: AppSpacing.bottomNavHeight + 16,
      labelBehavior: showLabels
          ? NavigationDestinationLabelBehavior.alwaysShow
          : NavigationDestinationLabelBehavior.onlyShowSelected,
      destinations: items.map((item) {
        Widget icon = Icon(item.icon);
        Widget selectedIcon = Icon(item.activeIcon ?? item.icon);
        
        // Add badge if needed
        if (item.badgeCount != null || item.showDot || item.badge != null) {
          icon = BaseBadge.withBadge(
            child: icon,
            count: item.badgeCount,
            badgeText: item.badge,
            showDot: item.showDot && item.badgeCount == null && item.badge == null,
          );
          selectedIcon = BaseBadge.withBadge(
            child: selectedIcon,
            count: item.badgeCount,
            badgeText: item.badge,
            showDot: item.showDot && item.badgeCount == null && item.badge == null,
          );
        }
        
        return NavigationDestination(
          icon: icon,
          selectedIcon: selectedIcon,
          label: item.label,
        );
      }).toList(),
    );
  }

  /// Factory constructor for default navigation items
  factory BottomNavBar.crm({
    Key? key,
    required int currentIndex,
    required ValueChanged<int> onItemSelected,
    int? notificationCount,
    NavBarType type = NavBarType.fixed,
  }) {
    return BottomNavBar(
      key: key,
      items: [
        const NavItem(
          label: 'Dashboard',
          icon: Icons.dashboard_outlined,
          activeIcon: Icons.dashboard,
        ),
        const NavItem(
          label: 'Contacts',
          icon: Icons.people_outline,
          activeIcon: Icons.people,
        ),
        const NavItem(
          label: 'Deals',
          icon: Icons.handshake_outlined,
          activeIcon: Icons.handshake,
        ),
        NavItem(
          label: 'Tasks',
          icon: Icons.task_alt,
          activeIcon: Icons.task_alt,
          badgeCount: notificationCount,
        ),
        const NavItem(
          label: 'Reports',
          icon: Icons.bar_chart_outlined,
          activeIcon: Icons.bar_chart,
        ),
      ],
      currentIndex: currentIndex,
      onItemSelected: onItemSelected,
      type: type,
    );
  }

  /// Factory constructor for minimal navigation (icon only)
  factory BottomNavBar.minimal({
    Key? key,
    required List<NavItem> items,
    required int currentIndex,
    required ValueChanged<int> onItemSelected,
    Color? selectedItemColor,
    Color? unselectedItemColor,
  }) {
    return BottomNavBar(
      key: key,
      items: items,
      currentIndex: currentIndex,
      onItemSelected: onItemSelected,
      showLabels: false,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
    );
  }

  /// Factory constructor for floating bottom nav bar
  static Widget floating({
    Key? key,
    required List<NavItem> items,
    required int currentIndex,
    required ValueChanged<int> onItemSelected,
    Color? backgroundColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      margin: margin ?? const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: AppSpacing.borderRadiusXL,
        child: BottomNavBar(
          key: key,
          items: items,
          currentIndex: currentIndex,
          onItemSelected: onItemSelected,
          backgroundColor: backgroundColor ?? AppColors.surface,
          selectedItemColor: selectedItemColor,
          unselectedItemColor: unselectedItemColor,
          elevation: AppSpacing.elevation8,
        ),
      ),
    );
  }
}

/// Individual navigation bar item widget
class _NavBarItem extends StatelessWidget {
  final NavItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color unselectedColor;
  final bool showLabel;
  final double? iconSize;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;

  const _NavBarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.selectedColor,
    required this.unselectedColor,
    required this.showLabel,
    this.iconSize,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? selectedColor : unselectedColor;
    final icon = isSelected && item.activeIcon != null 
        ? item.activeIcon! 
        : item.icon;
    
    Widget iconWidget = Icon(
      icon,
      size: iconSize ?? AppSpacing.iconSizeM,
      color: color,
    );

    // Add badge if needed
    if (item.badgeCount != null || item.showDot || item.badge != null) {
      iconWidget = BaseBadge.withBadge(
        child: iconWidget,
        count: item.badgeCount,
        badgeText: item.badge,
        showDot: item.showDot && item.badgeCount == null && item.badge == null,
        variant: BadgeVariant.error,
        size: BadgeSize.small,
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.borderRadiusS,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            if (showLabel) ...[
              AppSpacing.gapV1,
              Text(
                item.label,
                style: isSelected
                    ? (selectedLabelStyle ?? AppTypography.navLabel.copyWith(
                        color: selectedColor,
                        fontWeight: FontWeight.w600,
                      ))
                    : (unselectedLabelStyle ?? AppTypography.navLabel.copyWith(
                        color: unselectedColor,
                      )),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Navigation bar type enum
enum NavBarType {
  /// Classic bottom navigation bar
  fixed,
  
  /// Material 3 navigation bar with pill indicator
  material3,
  
  /// Shifting navigation bar (selected item grows)
  shifting,
}