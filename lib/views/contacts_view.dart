import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/contacts_viewmodel.dart';
import '../models/contact_model.dart';
import '../core/components/contacts/contact_search_bar.dart';
import '../core/components/contacts/contacts_content.dart';
import '../core/components/view_state_handler.dart';
import '../core/components/modal/add_contact_modal.dart';
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
                listBuilder: (contacts) => ContactsContent(
                  viewModel: viewModel,
                  contacts: contacts,
                  onAddContact: showAddContactDialog,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}