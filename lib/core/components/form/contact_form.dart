import 'package:flutter/material.dart';
import '../../../models/contact_model.dart';

class ContactForm extends StatefulWidget {
  final Contact? existingContact;
  final Function(Contact) onSubmit;
  final VoidCallback onCancel;

  const ContactForm({
    super.key,
    this.existingContact,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController companyController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.existingContact?.name ?? '');
    emailController = TextEditingController(text: widget.existingContact?.email ?? '');
    phoneController = TextEditingController(text: widget.existingContact?.phone ?? '');
    companyController = TextEditingController(text: widget.existingContact?.company ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    companyController.dispose();
    super.dispose();
  }

  bool get isEditing => widget.existingContact != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFormFields(),
        const SizedBox(height: 32),
        _buildActions(),
      ],
    );
  }

  Widget _buildFormFields() {
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

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: widget.onCancel,
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[600],
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('Cancel', style: TextStyle(fontSize: 16)),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: _handleSubmit,
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

  void _handleSubmit() {
    if (nameController.text.trim().isEmpty) {
      return;
    }

    final contact = widget.existingContact?.copyWith(
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

    widget.onSubmit(contact);
  }
}