import 'package:flutter/material.dart';
import '../../../models/contact_model.dart';
import '../../../viewmodels/contacts_viewmodel.dart';
import '../../constants/app_constants.dart';
import '../common/danger_button.dart';

class DeleteContactDialog extends StatelessWidget {
  final ContactsViewModel viewModel;
  final Contact contact;

  const DeleteContactDialog({
    super.key,
    required this.viewModel,
    required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Delete Contact',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      content: Text(
        'Are you sure you want to delete "${contact.name}"? This action cannot be undone.',
        style: const TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.grey600,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingM,
              vertical: AppSizes.paddingS,
            ),
          ),
          child: const Text(AppStrings.cancel),
        ),
        DangerButton(
          label: AppStrings.delete,
          onPressed: () async {
            Navigator.pop(context);
            await viewModel.deleteContact(contact.id);
          },
        ),
      ],
    );
  }
}
