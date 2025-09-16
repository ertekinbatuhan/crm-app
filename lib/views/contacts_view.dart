import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/contact_model.dart';
import '../viewmodels/contacts_viewmodel.dart';
import '../core/components/layout/page_container.dart';
import '../core/components/layout/empty_state.dart';
import '../core/components/cards/contact_card.dart';
import '../core/components/cards/stat_card.dart';
import '../core/theme/app_spacing.dart';
import 'contact_detail_view.dart';
import 'modals/add_contact_modal.dart';

class ContactsView extends StatefulWidget {
  const ContactsView({super.key});

  @override
  State<ContactsView> createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContactsViewModel>().loadContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactsViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddContactModal(viewModel),
          child: const Icon(Icons.add),
        ),
          body: PageContainer(
            scrollable: false,
            child: CustomScrollView(
            slivers: [
              // Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: AppSpacing.screenPadding,
                  child: TextField(
                    onChanged: viewModel.updateSearchQuery,
                    decoration: InputDecoration(
                      hintText: 'Search contacts...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      contentPadding: AppSpacing.inputPadding,
                    ),
                  ),
                ),
              ),
              
              // Stats Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: AppSpacing.screenPadding,
                  child: StatCard.contacts(
                    value: viewModel.totalContacts.toString(),
                    onTap: () => print('Contacts stat tapped'),
                  ),
                ),
              ),
              
              // Spacing
              SliverToBoxAdapter(
                child: AppSpacing.gapV4,
              ),
              
              // Loading State
              if (viewModel.isLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              
              // Error State
              if (viewModel.hasError && !viewModel.isLoading)
                SliverFillRemaining(
                  child: EmptyState.error(
                    message: viewModel.errorMessage ?? 'Failed to load contacts',
                    onRetry: viewModel.loadContacts,
                  ),
                ),
              
              // Empty State
              if (viewModel.contacts.isEmpty && !viewModel.isLoading && !viewModel.hasError)
                const SliverFillRemaining(
                  child: EmptyState(
                    iconData: Icons.people_outline,
                    title: 'No contacts yet',
                    message: 'Add your first contact to get started',
                  ),
                ),
              
              // Contacts List
              if (viewModel.contacts.isNotEmpty && !viewModel.isLoading && !viewModel.hasError)
                SliverPadding(
                  padding: AppSpacing.screenPadding,
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final contact = viewModel.contacts[index];
                        return ContactCard.fromModel(
                          id: contact.id,
                          name: contact.name,
                          email: contact.email,
                          phone: contact.phone,
                          company: contact.company,
                          onTap: () => _navigateToContactDetail(contact),
                          onCall: () => _makeCall(contact.phone),
                          onEmail: () => _sendEmail(contact.email),
                          onEdit: () => _showEditContactModal(viewModel, contact),
                          onDelete: () => _showDeleteConfirmation(viewModel, contact),
                        );
                      },
                      childCount: viewModel.contacts.length,
                    ),
                  ),
                ),
            ],
            ),
          ),
        );
      },
    );
  }

  void _showAddContactModal(ContactsViewModel viewModel) async {
    final result = await Navigator.push<Contact>(
      context,
      MaterialPageRoute(
        builder: (context) => AddContactModal(
          onSave: (contact) {
            viewModel.createContact(contact);
          },
        ),
        fullscreenDialog: true,
      ),
    );
    
    if (result != null) {
      // Contact was saved successfully
    }
  }

  // Navigation and action methods
  void _navigateToContactDetail(Contact contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactDetailView(contact: contact),
      ),
    );
  }

  void _makeCall(String? phone) {
    if (phone != null) {
      print('Making call to: $phone');
      // TODO: Implement phone call functionality
    }
  }

  void _sendEmail(String? email) {
    if (email != null) {
      print('Sending email to: $email');
      // TODO: Implement email functionality
    }
  }

  void _showEditContactModal(ContactsViewModel viewModel, Contact contact) async {
    final result = await Navigator.push<Contact>(
      context,
      MaterialPageRoute(
        builder: (context) => AddContactModal(
          contact: contact,
          onSave: (updatedContact) {
            // TODO: viewModel.updateContact(updatedContact);
            print('Update contact: ${updatedContact.name}');
          },
        ),
        fullscreenDialog: true,
      ),
    );
    
    if (result != null) {
      // Contact was updated successfully
    }
  }

  void _showDeleteConfirmation(ContactsViewModel viewModel, Contact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Contact'),
        content: Text('Are you sure you want to delete ${contact.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              viewModel.deleteContact(contact.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
