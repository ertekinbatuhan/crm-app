import 'package:flutter/material.dart';
import '../../../models/contact_model.dart';
import '../../../viewmodels/contacts_viewmodel.dart';
import '../../constants/app_constants.dart';
import '../form/contact_form.dart';

class AddContactModal extends StatelessWidget {
  final ContactsViewModel viewModel;
  final Contact? existingContact;

  const AddContactModal({
    super.key,
    required this.viewModel,
    this.existingContact,
  });

  bool get isEditing => existingContact != null;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * AppSizes.dialogWidthFactor,
        padding: const EdgeInsets.all(AppSizes.paddingL),
        decoration: AppDecorations.modal,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: AppSizes.paddingL),
            ContactForm(
              existingContact: existingContact,
              onSubmit: (contact) => _handleSubmit(context, contact),
              onCancel: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      isEditing ? AppStrings.editContact : AppStrings.addNewContact,
      style: AppTextStyles.dialogTitle,
    );
  }

  Future<void> _handleSubmit(BuildContext context, Contact contact) async {
    final success = isEditing
        ? await viewModel.updateContact(contact)
        : await viewModel.createContact(contact);

    if (success && context.mounted) {
      Navigator.pop(context);
    }
  }
}