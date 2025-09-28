import 'package:flutter/material.dart';
import '../../../models/contact_model.dart';
import '../../constants/app_constants.dart';
import '../common/action_menu.dart';

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
        title: Text(contact.name, style: AppTextStyles.cardTitle),
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
    return ActionMenu(
      onSelected: (action) {
        if (action == ActionMenuAction.edit && onEdit != null) {
          onEdit!();
        } else if (action == ActionMenuAction.delete && onDelete != null) {
          onDelete!();
        }
      },
    );
  }
}
