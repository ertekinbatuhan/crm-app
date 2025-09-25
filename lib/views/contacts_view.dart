import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/contacts_viewmodel.dart';
import '../models/contact_model.dart';
import '../core/components/contacts/contact_search_bar.dart';
import '../core/components/contacts/contact_stats_card.dart';
import '../core/components/contacts/contacts_list.dart';
import '../core/components/view_state_handler.dart';
import '../core/components/modal/add_contact_modal.dart';
import '../core/components/modal/delete_contact_dialog.dart';
import '../core/constants/app_constants.dart';

class ContactsView extends StatefulWidget {
  const ContactsView({super.key});

  @override
  State<ContactsView> createState() => ContactsViewWidgetState();
}

class ContactsViewWidgetState extends State<ContactsView> {
  void showAddContactDialog() {
    final viewModel = context.read<ContactsViewModel>();
    showDialog(
      context: context,
      builder: (context) => AddContactModal(viewModel: viewModel),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactsViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          children: [
            ContactSearchBar(
              onChanged: viewModel.updateSearchQuery,
            ),
            Expanded(
              child: ListViewStateHandler<Contact>(
                state: viewModel.currentState,
                items: viewModel.contacts,
                loadingMessage: AppStrings.loadingContacts,
                emptyTitle: AppStrings.noContactsFound,
                emptySubtitle: AppStrings.startByAddingContact,
                emptyIcon: Icons.people_outline,
                emptyActionLabel: AppStrings.addContact,
                onEmptyAction: showAddContactDialog,
                errorMessage: viewModel.errorMessage,
                onRetry: () {
                  // Stream will automatically retry on error
                },
                listBuilder: (contacts) => _buildSuccessContent(viewModel, contacts),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSuccessContent(ContactsViewModel viewModel, List<Contact> contacts) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContactStatsCard(
            title: AppStrings.totalContacts,
            value: '${viewModel.totalContactsCount}',
            icon: Icons.people,
          ),
          const SizedBox(height: 24),
          ContactsList(
            contacts: contacts,
            onEditContact: (contact) => _showEditContactDialog(viewModel, contact),
            onDeleteContact: (contact) => _showDeleteConfirmationDialog(viewModel, contact),
            onAddContact: showAddContactDialog,
          ),
        ],
      ),
    );
  }

  void _showEditContactDialog(ContactsViewModel viewModel, Contact contact) {
    showDialog(
      context: context,
      builder: (context) => AddContactModal(
        viewModel: viewModel,
        existingContact: contact,
      ),
    );
  }

  void _showDeleteConfirmationDialog(ContactsViewModel viewModel, Contact contact) {
    showDialog(
      context: context,
      builder: (context) => DeleteContactDialog(
        viewModel: viewModel,
        contact: contact,
      ),
    );
  }
}