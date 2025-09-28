import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/contact_model.dart';
import '../../constants/app_constants.dart';
import '../../utils/form_validators.dart';
import '../base/base_input.dart';

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
    nameController = TextEditingController(
      text: widget.existingContact?.name ?? '',
    );
    emailController = TextEditingController(
      text: widget.existingContact?.email ?? '',
    );
    phoneController = TextEditingController(
      text: widget.existingContact?.phone ?? '',
    );
    companyController = TextEditingController(
      text: widget.existingContact?.company ?? '',
    );
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
        BaseInput(
          label: AppStrings.nameRequired,
          controller: nameController,
          validator: FormValidators.validateName,
          textCapitalization: TextCapitalization.words,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
          ],
        ),
        const SizedBox(height: 16),
        BaseInput(
          label: AppStrings.email,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
          validator: FormValidators.validateEmail,
        ),
        const SizedBox(height: 16),
        BaseInput(
          label: AppStrings.phone,
          hint: AppStrings.phoneHint,
          controller: phoneController,
          keyboardType: TextInputType.phone,
          validator: FormValidators.validatePhone,
          prefixIcon: const Icon(Icons.phone_outlined),
        ),
        const SizedBox(height: 16),
        BaseInput(
          label: AppStrings.company,
          controller: companyController,
          validator: FormValidators.validateCompany,
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
    final nameError = FormValidators.validateName(nameController.text);
    final emailError = FormValidators.validateEmail(emailController.text);
    final phoneError = FormValidators.validatePhone(phoneController.text);
    final companyError = FormValidators.validateCompany(companyController.text);

    if (nameError != null) {
      setState(() {});
      return;
    }

    final contact =
        widget.existingContact?.copyWith(
          name: nameController.text.trim(),
          email: emailController.text.trim().isEmpty
              ? null
              : emailController.text.trim(),
          phone: phoneController.text.trim().isEmpty
              ? null
              : phoneController.text.trim(),
          company: companyController.text.trim().isEmpty
              ? null
              : companyController.text.trim(),
        ) ??
        Contact(
          id: '',
          name: nameController.text.trim(),
          email: emailController.text.trim().isEmpty
              ? null
              : emailController.text.trim(),
          phone: phoneController.text.trim().isEmpty
              ? null
              : phoneController.text.trim(),
          company: companyController.text.trim().isEmpty
              ? null
              : companyController.text.trim(),
        );

    widget.onSubmit(contact);
  }
}
