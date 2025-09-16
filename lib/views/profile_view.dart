import 'package:flutter/material.dart';
import '../core/components/layout/app_scaffold.dart';
import '../core/components/base/base_card.dart';
import '../core/components/base/base_button.dart';
import '../core/components/base/base_avatar.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Profile',
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          children: [
            // Profile Header
            BaseCard(
              child: Column(
                children: [
                  // Avatar
                  BaseAvatar(
                    text: 'John Doe',
                    size: AvatarSize.extraLarge,
                    backgroundColor: AppColors.primary100,
                    foregroundColor: AppColors.primary700,
                  ),
                  
                  AppSpacing.gapV3,
                  
                  Text(
                    'John Doe',
                    style: AppTypography.headlineMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  AppSpacing.gapV1,
                  
                  Text(
                    'Sales Manager',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  
                  AppSpacing.gapV1,
                  
                  Text(
                    'Acme Corporation',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  
                  AppSpacing.gapV4,
                  
                  BaseButton(
                    text: 'Edit Profile',
                    variant: ButtonVariant.outlined,
                    onPressed: _editProfile,
                  ),
                ],
              ),
            ),

            AppSpacing.gapV4,

            // Contact Information
            BaseCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Information',
                    style: AppTypography.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacing.gapV3,
                  _buildInfoRow(Icons.email, 'Email', 'john.doe@company.com'),
                  _buildInfoRow(Icons.phone, 'Phone', '+1 (555) 123-4567'),
                  _buildInfoRow(Icons.location_on, 'Location', 'New York, NY'),
                ],
              ),
            ),

            AppSpacing.gapV4,

            // Work Information
            BaseCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Work Information',
                    style: AppTypography.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacing.gapV3,
                  _buildInfoRow(Icons.business, 'Company', 'Acme Corporation'),
                  _buildInfoRow(Icons.work, 'Department', 'Sales'),
                  _buildInfoRow(Icons.badge, 'Employee ID', 'EMP001'),
                  _buildInfoRow(Icons.calendar_today, 'Join Date', 'January 2020'),
                ],
              ),
            ),

            AppSpacing.gapV4,

            // Statistics
            BaseCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Performance',
                    style: AppTypography.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacing.gapV3,
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem('Deals Closed', '127'),
                      ),
                      Expanded(
                        child: _buildStatItem('Revenue', '\$2.4M'),
                      ),
                    ],
                  ),
                  AppSpacing.gapV3,
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem('Contacts', '1,234'),
                      ),
                      Expanded(
                        child: _buildStatItem('Tasks', '89'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            AppSpacing.gapV4,

            // Actions
            BaseCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Actions',
                    style: AppTypography.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacing.gapV3,
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.security, color: AppColors.textSecondary),
                    title: Text(
                      'Change Password',
                      style: AppTypography.bodyMedium,
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                    ),
                    onTap: _changePassword,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.notifications, color: AppColors.textSecondary),
                    title: Text(
                      'Notification Settings',
                      style: AppTypography.bodyMedium,
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                    ),
                    onTap: _notificationSettings,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.privacy_tip, color: AppColors.textSecondary),
                    title: Text(
                      'Privacy Settings',
                      style: AppTypography.bodyMedium,
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                    ),
                    onTap: _privacySettings,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppSpacing.iconSizeS,
            color: AppColors.textSecondary,
          ),
          AppSpacing.gapH3,
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary700,
          ),
        ),
        AppSpacing.gapV1,
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _editProfile() {
    print('Edit profile');
    // TODO: Navigate to profile edit screen
  }

  void _changePassword() {
    print('Change password');
    // TODO: Navigate to change password screen
  }

  void _notificationSettings() {
    print('Notification settings');
    // TODO: Navigate to notification settings
  }

  void _privacySettings() {
    print('Privacy settings');
    // TODO: Navigate to privacy settings
  }
}