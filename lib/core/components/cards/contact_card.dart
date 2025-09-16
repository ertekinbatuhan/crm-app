import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../base/base_card.dart';
import '../base/base_avatar.dart';
import '../base/base_badge.dart';

/// A card component for displaying contact information
class ContactCard extends StatelessWidget {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? company;
  final String? avatarUrl;
  final VoidCallback? onTap;
  final VoidCallback? onCall;
  final VoidCallback? onEmail;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  const ContactCard({
    super.key,
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.company,
    this.avatarUrl,
    this.onTap,
    this.onCall,
    this.onEmail,
    this.onEdit,
    this.onDelete,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard.clickable(
      onTap: onTap ?? () {},
      margin: const EdgeInsets.only(bottom: AppSpacing.sp3),
      child: Row(
        children: [
          // Avatar
          _buildAvatar(),
          AppSpacing.gapH3,
          
          // Contact Info
          Expanded(
            child: _buildContactInfo(),
          ),
          
          // Actions
          if (showActions) ...[
            AppSpacing.gapH2,
            _buildActions(context),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return BaseAvatar(
      text: name,
      imageUrl: avatarUrl,
      size: AvatarSize.medium,
      backgroundColor: AppColors.primary100,
      foregroundColor: AppColors.primary700,
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name
        Text(
          name,
          style: AppTypography.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        
        if (company != null) ...[
          AppSpacing.gapV1,
          Row(
            children: [
              Icon(
                Icons.business,
                size: AppSpacing.iconSizeXS,
                color: AppColors.textSecondary,
              ),
              AppSpacing.gapH1,
              Expanded(
                child: Text(
                  company!,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
        
        AppSpacing.gapV1,
        _buildContactMethods(),
      ],
    );
  }

  Widget _buildContactMethods() {
    final methods = <Widget>[];
    
    if (email != null) {
      methods.add(
        _ContactMethod(
          icon: Icons.email,
          text: email!,
          onTap: onEmail,
        ),
      );
    }
    
    if (phone != null) {
      methods.add(
        _ContactMethod(
          icon: Icons.phone,
          text: phone!,
          onTap: onCall,
        ),
      );
    }
    
    if (methods.isEmpty) {
      return Text(
        'No contact info',
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.textTertiary,
          fontStyle: FontStyle.italic,
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: methods,
    );
  }

  Widget _buildActions(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: AppColors.textSecondary,
        size: AppSpacing.iconSizeS,
      ),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit?.call();
            break;
          case 'delete':
            onDelete?.call();
            break;
          case 'call':
            if (phone != null) onCall?.call();
            break;
          case 'email':
            if (email != null) onEmail?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        if (phone != null)
          const PopupMenuItem(
            value: 'call',
            child: Row(
              children: [
                Icon(Icons.phone, size: 18),
                SizedBox(width: 12),
                Text('Call'),
              ],
            ),
          ),
        if (email != null)
          const PopupMenuItem(
            value: 'email',
            child: Row(
              children: [
                Icon(Icons.email, size: 18),
                SizedBox(width: 12),
                Text('Email'),
              ],
            ),
          ),
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: 18),
              SizedBox(width: 12),
              Text('Edit'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: 18, color: Colors.red),
              SizedBox(width: 12),
              Text('Delete', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  /// Factory constructor for creating from Contact model
  factory ContactCard.fromModel({
    required String id,
    required String name,
    String? email,
    String? phone,
    String? company,
    String? avatarUrl,
    VoidCallback? onTap,
    VoidCallback? onCall,
    VoidCallback? onEmail,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
    bool showActions = true,
  }) {
    return ContactCard(
      id: id,
      name: name,
      email: email,
      phone: phone,
      company: company,
      avatarUrl: avatarUrl,
      onTap: onTap,
      onCall: onCall,
      onEmail: onEmail,
      onEdit: onEdit,
      onDelete: onDelete,
      showActions: showActions,
    );
  }
}

/// Individual contact method widget
class _ContactMethod extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const _ContactMethod({
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Widget content = Row(
      children: [
        Icon(
          icon,
          size: AppSpacing.iconSizeXS,
          color: AppColors.textSecondary,
        ),
        AppSpacing.gapH1,
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.borderRadiusXS,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: content,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: content,
    );
  }
}