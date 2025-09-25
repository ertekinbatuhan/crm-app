import 'package:flutter/material.dart';
import '../../../models/contact_model.dart';
import '../../../viewmodels/contacts_viewmodel.dart';

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text(
        'Delete Contact',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      content: Text(
        'Are you sure you want to delete "${contact.name}"? This action cannot be undone.',
        style: const TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[600],
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text('Cancel', style: TextStyle(fontSize: 16)),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(context);
            await viewModel.deleteContact(contact.id);
            // Real-time stream will automatically update the UI
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[600],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Delete', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}