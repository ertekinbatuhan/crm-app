import 'package:flutter/material.dart';
import '../../../models/contact_model.dart';
import '../../constants/app_constants.dart';
import 'contact_card.dart';
import 'contacts_empty_state.dart';

class ContactsList extends StatelessWidget {
  final List<Contact> contacts;
  final Function(Contact) onEditContact;
  final Function(Contact) onDeleteContact;
  final VoidCallback? onAddContact;

  const ContactsList({
    super.key,
    required this.contacts,
    required this.onEditContact,
    required this.onDeleteContact,
    this.onAddContact,
  });

  @override
  Widget build(BuildContext context) {
    if (contacts.isEmpty) {
      return ContactsEmptyState(
        title: AppStrings.noContactsFound,
        subtitle: AppStrings.startByAddingContact,
        onActionPressed: onAddContact,
        actionLabel: AppStrings.addContact,
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return ContactCard(
          contact: contact,
          onEdit: () => onEditContact(contact),
          onDelete: () => onDeleteContact(contact),
        );
      },
    );
  }
}