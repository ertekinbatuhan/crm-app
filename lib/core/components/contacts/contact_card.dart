import 'package:flutter/material.dart';
import '../../../models/contact_model.dart';
import '../../constants/app_constants.dart';

class ContactCard extends StatelessWidget {
  final Contact contact;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ContactCard({
    super.key,
    required this.contact,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingS),
      color: AppColors.cardBackgroundColor,
      elevation: AppSizes.elevationS,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
      ),
      child: ListTile(
        onTap: onTap,
        leading: _buildAvatar(),
        title: Text(
          contact.name,
          style: AppTextStyles.cardTitle,
        ),
        subtitle: _buildSubtitle(),
        trailing: _buildPopupMenu(context),
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      backgroundColor: AppColors.primary,
      child: Text(
        contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
        style: AppTextStyles.avatarText,
      ),
    );
  }

  Widget _buildSubtitle() {
    final List<Widget> subtitleItems = [];
    
    if (contact.email != null) {
      subtitleItems.add(Text(contact.email!));
    }
    if (contact.phone != null) {
      subtitleItems.add(Text(contact.phone!));
    }
    if (contact.company != null) {
      subtitleItems.add(Text(contact.company!));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: subtitleItems,
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
      ),
      onSelected: (value) {
        if (value == 'edit' && onEdit != null) {
          onEdit!();
        } else if (value == 'delete' && onDelete != null) {
          onDelete!();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: AppSizes.iconM),
              const SizedBox(width: AppSizes.paddingS),
              const Text(AppStrings.edit),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: AppSizes.iconM, color: AppColors.red),
              const SizedBox(width: AppSizes.paddingS),
              const Text(AppStrings.delete, style: TextStyle(color: AppColors.red)),
            ],
          ),
        ),
      ],
    );
  }
}