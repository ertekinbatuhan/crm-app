import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/contacts_viewmodel.dart';
import '../models/contact_model.dart';
import '../core/components/contacts/contact_search_bar.dart';
import '../core/components/contacts/contact_stats_card.dart';
import '../core/components/contacts/contacts_list.dart';
import '../core/components/contacts/contacts_loading_state.dart';
import '../core/components/contacts/contacts_error_state.dart';

class ContactsView extends StatefulWidget {
  const ContactsView({super.key});

  @override
  State<ContactsView> createState() => ContactsViewWidgetState();
}

class ContactsViewWidgetState extends State<ContactsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContactsViewModel>().loadContacts();
    });
  }

  void showAddContactDialog() {
    final viewModel = context.read<ContactsViewModel>();
    _showContactDialog(viewModel);
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
              child: _buildContent(viewModel),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent(ContactsViewModel viewModel) {
    if (viewModel.isLoading) {
      return const ContactsLoadingState(
        message: 'Loading contacts...',
      );
    }

    if (viewModel.hasError) {
      return ContactsErrorState(
        message: viewModel.errorMessage,
        onRetry: () => viewModel.loadContacts(),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContactStatsCard(
            title: 'Total Contacts',
            value: '${viewModel.totalContactsCount}',
            icon: Icons.people,
          ),
          const SizedBox(height: 24),
          ContactsList(
            contacts: viewModel.contacts,
            onEditContact: (contact) => _showEditContactDialog(viewModel, contact),
            onDeleteContact: (contact) => _showDeleteConfirmationDialog(viewModel, contact),
            onAddContact: showAddContactDialog,
          ),
        ],
      ),
    );
  }


  void _showContactDialog(ContactsViewModel viewModel, [Contact? existingContact]) {
    final nameController = TextEditingController(text: existingContact?.name ?? '');
    final emailController = TextEditingController(text: existingContact?.email ?? '');
    final phoneController = TextEditingController(text: existingContact?.phone ?? '');
    final companyController = TextEditingController(text: existingContact?.company ?? '');

    final isEditing = existingContact != null;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? 'Edit Contact' : 'Add New Contact',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              _buildContactForm(
                nameController,
                emailController,
                phoneController,
                companyController,
              ),
              const SizedBox(height: 32),
              _buildDialogActions(
                viewModel,
                existingContact,
                nameController,
                emailController,
                phoneController,
                companyController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactForm(
    TextEditingController nameController,
    TextEditingController emailController,
    TextEditingController phoneController,
    TextEditingController companyController,
  ) {
    return Column(
      children: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Name *',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone',
            hintText: '+90 5XX XXX XX XX',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: companyController,
          decoration: const InputDecoration(
            labelText: 'Company',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildDialogActions(
    ContactsViewModel viewModel,
    Contact? existingContact,
    TextEditingController nameController,
    TextEditingController emailController,
    TextEditingController phoneController,
    TextEditingController companyController,
  ) {
    final isEditing = existingContact != null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[600],
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('Cancel', style: TextStyle(fontSize: 16)),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () => _handleContactSubmit(
            viewModel,
            existingContact,
            nameController,
            emailController,
            phoneController,
            companyController,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF34C759),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            isEditing ? 'Update' : 'Add',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Future<void> _handleContactSubmit(
    ContactsViewModel viewModel,
    Contact? existingContact,
    TextEditingController nameController,
    TextEditingController emailController,
    TextEditingController phoneController,
    TextEditingController companyController,
  ) async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name is required')),
      );
      return;
    }

    final contact = existingContact?.copyWith(
      name: nameController.text.trim(),
      email: emailController.text.trim().isEmpty ? null : emailController.text.trim(),
      phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
      company: companyController.text.trim().isEmpty ? null : companyController.text.trim(),
    ) ?? Contact(
      id: '',
      name: nameController.text.trim(),
      email: emailController.text.trim().isEmpty ? null : emailController.text.trim(),
      phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
      company: companyController.text.trim().isEmpty ? null : companyController.text.trim(),
    );

    final success = existingContact != null
        ? await viewModel.updateContact(contact)
        : await viewModel.createContact(contact);

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(existingContact != null 
              ? 'Contact updated successfully' 
              : 'Contact added successfully'),
        ),
      );
    }
  }

  void _showEditContactDialog(ContactsViewModel viewModel, Contact contact) {
    _showContactDialog(viewModel, contact);
  }

  void _showDeleteConfirmationDialog(ContactsViewModel viewModel, Contact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${contact.name} deleted successfully'),
                    backgroundColor: Colors.red[600],
                  ),
                );
              }
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
      ),
    );
  }
}