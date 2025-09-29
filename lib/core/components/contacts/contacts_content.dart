import 'package:flutter/material.dart';
import '../../../viewmodels/contacts_viewmodel.dart';
import '../../../models/contact_model.dart';
import '../../constants/app_constants.dart';
import '../common/generic_metric_card.dart';
import '../contacts/contacts_list.dart';
import '../modal/add_contact_modal.dart';
import '../modal/delete_contact_dialog.dart';

class ContactsContent extends StatelessWidget {
  final ContactsViewModel viewModel;
  final List<Contact> contacts;
  final VoidCallback onAddContact;

  const ContactsContent({
    super.key,
    required this.viewModel,
    required this.contacts,
    required this.onAddContact,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GenericMetricCard.stats(
            title: AppStrings.totalContacts,
            value: '${viewModel.totalContactsCount}',
            icon: Icons.people,
            iconColor: AppColors.info,
          ),
          const SizedBox(height: 24),
          ContactsList(
            contacts: contacts,
            onEditContact: (contact) => _showEditContactDialog(context, viewModel, contact),
            onDeleteContact: (contact) => _showDeleteConfirmationDialog(context, viewModel, contact),
            onAddContact: onAddContact,
          ),
        ],
      ),
    );
  }

  void _showEditContactDialog(BuildContext context, ContactsViewModel viewModel, Contact contact) {
    showDialog(
      context: context,
      builder: (context) => AddContactModal(
        viewModel: viewModel,
        existingContact: contact,
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, ContactsViewModel viewModel, Contact contact) {
    showDialog(
      context: context,
      builder: (context) => DeleteContactDialog(
        viewModel: viewModel,
        contact: contact,
      ),
    );
  }
}