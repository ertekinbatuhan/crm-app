import 'package:flutter/material.dart';
import '../core/components/layout/app_scaffold.dart';
import '../core/components/base/base_card.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _notifications = true;
  bool _darkMode = false;
  bool _biometric = false;
  String _currency = 'USD';
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Settings',
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          children: [
            // Profile Settings
            BaseCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile',
                    style: AppTypography.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacing.gapV3,
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary100,
                      child: Icon(
                        Icons.person,
                        color: AppColors.primary700,
                      ),
                    ),
                    title: Text(
                      'John Doe',
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'john.doe@company.com',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                    ),
                    onTap: _editProfile,
                  ),
                ],
              ),
            ),

            AppSpacing.gapV4,

            // Preferences
            BaseCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preferences',
                    style: AppTypography.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacing.gapV3,
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Push Notifications',
                      style: AppTypography.bodyMedium,
                    ),
                    subtitle: Text(
                      'Receive notifications for important updates',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    value: _notifications,
                    onChanged: (value) {
                      setState(() {
                        _notifications = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Dark Mode',
                      style: AppTypography.bodyMedium,
                    ),
                    subtitle: Text(
                      'Use dark theme',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    value: _darkMode,
                    onChanged: (value) {
                      setState(() {
                        _darkMode = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Biometric Login',
                      style: AppTypography.bodyMedium,
                    ),
                    subtitle: Text(
                      'Use fingerprint or face ID',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    value: _biometric,
                    onChanged: (value) {
                      setState(() {
                        _biometric = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            AppSpacing.gapV4,

            // App Settings
            BaseCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'App Settings',
                    style: AppTypography.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacing.gapV3,
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Currency',
                      style: AppTypography.bodyMedium,
                    ),
                    subtitle: Text(
                      _currency,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                    ),
                    onTap: _selectCurrency,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Language',
                      style: AppTypography.bodyMedium,
                    ),
                    subtitle: Text(
                      _language,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                    ),
                    onTap: _selectLanguage,
                  ),
                ],
              ),
            ),

            AppSpacing.gapV4,

            // Support & Help
            BaseCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Support & Help',
                    style: AppTypography.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacing.gapV3,
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.help_outline, color: AppColors.textSecondary),
                    title: Text(
                      'Help Center',
                      style: AppTypography.bodyMedium,
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                    ),
                    onTap: _openHelpCenter,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.feedback_outlined, color: AppColors.textSecondary),
                    title: Text(
                      'Send Feedback',
                      style: AppTypography.bodyMedium,
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                    ),
                    onTap: _sendFeedback,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.info_outline, color: AppColors.textSecondary),
                    title: Text(
                      'About',
                      style: AppTypography.bodyMedium,
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                    ),
                    onTap: _showAbout,
                  ),
                ],
              ),
            ),

            AppSpacing.gapV4,

            // Account Actions
            BaseCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account',
                    style: AppTypography.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacing.gapV3,
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.logout, color: AppColors.error),
                    title: Text(
                      'Sign Out',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                    onTap: _signOut,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editProfile() {
    print('Edit profile');
    // TODO: Navigate to profile edit screen
  }

  void _selectCurrency() {
    print('Select currency');
    // TODO: Show currency selection dialog
  }

  void _selectLanguage() {
    print('Select language');
    // TODO: Show language selection dialog
  }

  void _openHelpCenter() {
    print('Open help center');
    // TODO: Open help center
  }

  void _sendFeedback() {
    print('Send feedback');
    // TODO: Open feedback form
  }

  void _showAbout() {
    print('Show about');
    // TODO: Show about dialog
  }

  void _signOut() {
    print('Sign out');
    // TODO: Implement sign out functionality
  }
}