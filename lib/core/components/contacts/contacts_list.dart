import 'package:flutter/material.dart';
import '../../../models/contact_model.dart';
import 'contact_card.dart';

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