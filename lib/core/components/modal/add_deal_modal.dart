import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/deal_model.dart';
import '../../../viewmodels/deals_viewmodel.dart';
import '../../constants/app_constants.dart';
import '../../utils/date_extensions.dart';
import '../../utils/deal_extensions.dart';
import '../../utils/form_validators.dart';

class AddDealModal extends StatefulWidget {
  final DealsViewModel viewModel;
  final Deal? existingDeal;

  const AddDealModal({
    super.key,
    required this.viewModel,
    this.existingDeal,
  });

  @override
  State<AddDealModal> createState() => _AddDealModalState();
}

class _AddDealModalState extends State<AddDealModal> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController titleController;
  late final TextEditingController valueController;
  late final TextEditingController descriptionController;
  late DealStatus selectedStatus;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.existingDeal?.title ?? '');
    valueController = TextEditingController(text: widget.existingDeal?.value.toString() ?? '');
    descriptionController = TextEditingController(text: widget.existingDeal?.description ?? '');
    selectedStatus = widget.existingDeal?.status ?? DealStatus.prospect;
  }

  @override
  void dispose() {
    titleController.dispose();
    valueController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  bool get isEditing => widget.existingDeal != null;

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
            _buildForm(),
            const SizedBox(height: AppSizes.paddingL),
            _buildStatusInfo(),
            const SizedBox(height: AppSizes.paddingL),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      isEditing ? AppStrings.editDeal : AppStrings.addNewDeal,
      style: AppTextStyles.dialogTitle,
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTitleField(),
          const SizedBox(height: AppSizes.paddingM),
          _buildValueField(),
          const SizedBox(height: AppSizes.paddingM),
          _buildStatusDropdown(),
          const SizedBox(height: AppSizes.paddingM),
          _buildDescriptionField(),
        ],
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: titleController,
      decoration: AppInputDecorations.standard.copyWith(
        labelText: 'Title *',
      ),
      validator: (value) => FormValidators.validateRequired(value, 'Title'),
    );
  }

  Widget _buildValueField() {
    return TextFormField(
      controller: valueController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
        LengthLimitingTextInputFormatter(15),
      ],
      decoration: AppInputDecorations.standard.copyWith(
        labelText: 'Value *',
        prefixText: '\$ ',
      ),
      validator: (value) => FormValidators.validatePositiveNumber(value, 'Value'),
    );
  }

  Widget _buildStatusDropdown() {
    return StatefulBuilder(
      builder: (context, setState) => Theme(
        data: Theme.of(context).copyWith(
          canvasColor: AppColors.white,
        ),
        child: DropdownButtonFormField<DealStatus>(
          value: selectedStatus,
          decoration: AppInputDecorations.standard.copyWith(
            labelText: AppStrings.status,
          ),
          dropdownColor: AppColors.white,
          items: DealStatus.values.map((status) {
            return DropdownMenuItem(
              value: status,
              child: Text(status.displayName),
            );
          }).toList(),
          onChanged: (DealStatus? newValue) {
            if (newValue != null) {
              setState(() {
                selectedStatus = newValue;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: descriptionController,
      decoration: AppInputDecorations.standard.copyWith(
        labelText: 'Description',
        hintText: 'Optional details about the deal...',
      ),
      maxLines: 3,
    );
  }

  Widget _buildStatusInfo() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.primary,
            size: AppSizes.iconM,
          ),
          const SizedBox(width: AppSizes.paddingS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Close date will be automatically set based on deal status',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey600,
                  ),
                ),
                if (widget.existingDeal?.closeDate != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Current close date: ${widget.existingDeal!.closeDate!.toUserFriendlyString(showFullDate: true)}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            AppStrings.cancel,
            style: AppTextStyles.buttonMedium.copyWith(
              color: AppColors.grey600,
            ),
          ),
        ),
        const SizedBox(width: AppSizes.paddingM),
        ElevatedButton(
          onPressed: _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.textOnPrimary,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingL,
              vertical: AppSizes.paddingM,
            ),
          ),
          child: Text(
            isEditing ? AppStrings.update : AppStrings.add,
            style: AppTextStyles.buttonMedium,
          ),
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final valueText = valueController.text.trim();
    final parsedValue = double.tryParse(valueText)!;

    if (isEditing) {
      final updatedDeal = widget.existingDeal!.copyWith(
        title: titleController.text.trim(),
        value: parsedValue,
        status: selectedStatus,
        description: descriptionController.text.trim().isEmpty
            ? null
            : descriptionController.text.trim(),
      );
      final success = await widget.viewModel.updateDeal(updatedDeal);
      if (success && context.mounted) {
        Navigator.pop(context);
      }
    } else {
      final deal = Deal(
        id: '', // Firebase will generate the ID
        title: titleController.text.trim(),
        value: parsedValue,
        status: selectedStatus,
        description: descriptionController.text.trim().isEmpty
            ? null
            : descriptionController.text.trim(),
      );
      final success = await widget.viewModel.createDeal(deal);
      if (success && context.mounted) {
        Navigator.pop(context);
      }
    }
  }
}