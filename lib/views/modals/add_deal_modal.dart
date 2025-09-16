import 'package:flutter/material.dart';
import '../../models/deal_model.dart';
import '../../core/components/base/base_card.dart';
import '../../core/components/base/base_button.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class AddDealModal extends StatefulWidget {
  final Deal? deal; // null for add, deal object for edit
  final Function(Deal)? onSave;

  const AddDealModal({
    super.key,
    this.deal,
    this.onSave,
  });

  @override
  State<AddDealModal> createState() => _AddDealModalState();
}

class _AddDealModalState extends State<AddDealModal> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _valueController = TextEditingController();
  final _nameController = TextEditingController();
  final _companyController = TextEditingController();
  final _contactController = TextEditingController();
  final _probabilityController = TextEditingController();
  final _competitorsController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  // Dropdowns
  String? _currency = 'USD - US Dollar';
  String? _pipeline = 'Sales Pipeline';
  String? _stage = 'Qualification';
  String? _type = 'New Business';
  String? _leadSource = 'Web';
  String? _dealOwner = 'Jane Smith';
  String? _teamMembers;
  
  // Date
  DateTime? _expectedCloseDate;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.deal != null) {
      _populateFields();
    } else {
      // Default value for new deals
      _valueController.text = '5,000.00';
    }
  }

  void _populateFields() {
    final deal = widget.deal!;
    _nameController.text = deal.title;
    _valueController.text = deal.value.toStringAsFixed(2);
    _descriptionController.text = deal.description ?? '';
    _stage = deal.status.displayName;
  }

  @override
  void dispose() {
    _valueController.dispose();
    _nameController.dispose();
    _companyController.dispose();
    _contactController.dispose();
    _probabilityController.dispose();
    _competitorsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.deal != null;
    
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Header
            _buildHeader(isEdit),
            
            // Form content
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.screenPadding,
                child: Column(
                  children: [
                    _buildDealInformationSection(),
                    AppSpacing.gapV8,
                    _buildPipelineSettingsSection(),
                    AppSpacing.gapV8,
                    _buildDetailsSection(),
                    AppSpacing.gapV8,
                    _buildAssignmentSection(),
                    AppSpacing.gapV8,
                    _buildProductsServicesSection(),
                    // Extra bottom padding for action bar
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
            
            // Bottom action bar
            _buildBottomActionBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isEdit) {
    return Container(
      color: AppColors.backgroundPrimary,
      child: SafeArea(
        child: Column(
          children: [
            // Top bar with close and title
            Container(
              padding: AppSpacing.screenPadding,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    color: AppColors.textSecondary,
                  ),
                  Expanded(
                    child: Text(
                      isEdit ? 'Edit Deal' : 'New Deal',
                      textAlign: TextAlign.center,
                      style: AppTypography.headlineSmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the close button
                ],
              ),
            ),
            
            // Deal value input
            Container(
              padding: AppSpacing.screenPadding,
              child: TextFormField(
                controller: _valueController,
                keyboardType: TextInputType.number,
                style: AppTypography.headlineLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: Text(
                      '\$',
                      style: AppTypography.headlineLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                  hintText: 'Deal value',
                  hintStyle: AppTypography.headlineLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textTertiary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.backgroundCard,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deal value is required';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDealInformationSection() {
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deal Information',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          
          AppSpacing.gapV4,
          
          // Deal name
          _buildFormField(
            label: 'Deal name',
            controller: _nameController,
            hintText: 'e.g. Website Redesign Project',
            required: true,
          ),
          
          AppSpacing.gapV4,
          
          // Company
          _buildFormField(
            label: 'Company/Account',
            controller: _companyController,
            hintText: 'e.g. Globex Corporation',
          ),
          
          AppSpacing.gapV4,
          
          // Primary contact
          _buildFormField(
            label: 'Primary contact',
            controller: _contactController,
            hintText: 'e.g. John Doe',
          ),
          
          AppSpacing.gapV4,
          
          // Currency
          _buildDropdownField(
            label: 'Currency',
            value: _currency,
            items: const [
              'USD - US Dollar',
              'EUR - Euro',
              'GBP - British Pound',
            ],
            onChanged: (value) => setState(() => _currency = value),
          ),
        ],
      ),
    );
  }

  Widget _buildPipelineSettingsSection() {
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pipeline Settings',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          
          AppSpacing.gapV4,
          
          // Pipeline
          _buildDropdownField(
            label: 'Pipeline',
            value: _pipeline,
            items: const [
              'Sales Pipeline',
              'Support Pipeline',
            ],
            onChanged: (value) => setState(() => _pipeline = value),
          ),
          
          AppSpacing.gapV4,
          
          // Current stage
          _buildDropdownField(
            label: 'Current stage',
            value: _stage,
            items: const [
              'Qualification',
              'Needs Analysis',
              'Proposal',
              'Negotiation',
              'Closed Won',
              'Closed Lost',
            ],
            onChanged: (value) => setState(() => _stage = value),
          ),
          
          AppSpacing.gapV4,
          
          // Probability
          _buildFormField(
            label: 'Probability (%)',
            controller: _probabilityController,
            hintText: 'e.g. 75',
            keyboardType: TextInputType.number,
          ),
          
          AppSpacing.gapV4,
          
          // Expected close date
          _buildDateField(),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Details',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          
          AppSpacing.gapV4,
          
          // Type
          _buildDropdownField(
            label: 'Type',
            value: _type,
            items: const [
              'New Business',
              'Existing Business',
            ],
            onChanged: (value) => setState(() => _type = value),
          ),
          
          AppSpacing.gapV4,
          
          // Lead source
          _buildDropdownField(
            label: 'Lead source',
            value: _leadSource,
            items: const [
              'Web',
              'Referral',
              'Partner',
              'Advertisement',
            ],
            onChanged: (value) => setState(() => _leadSource = value),
          ),
          
          AppSpacing.gapV4,
          
          // Competitors
          _buildFormField(
            label: 'Competitors',
            controller: _competitorsController,
            hintText: 'e.g. Initech, Vandelay Industries',
          ),
          
          AppSpacing.gapV4,
          
          // Description
          _buildFormField(
            label: 'Description',
            controller: _descriptionController,
            hintText: 'Add a description...',
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentSection() {
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Assignment',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          
          AppSpacing.gapV4,
          
          // Deal owner
          _buildDropdownField(
            label: 'Deal owner',
            value: _dealOwner,
            items: const [
              'Jane Smith',
              'Mike Johnson',
            ],
            onChanged: (value) => setState(() => _dealOwner = value),
          ),
          
          AppSpacing.gapV4,
          
          // Team members
          _buildDropdownField(
            label: 'Team members',
            value: _teamMembers,
            items: const [
              'Select team members',
              'Marketing Team',
              'Sales Engineers',
            ],
            onChanged: (value) => setState(() => _teamMembers = value),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsServicesSection() {
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Products/Services',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          
          AppSpacing.gapV4,
          
          // Products table placeholder
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: AppSpacing.cardPadding,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundCard,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Product',
                          style: AppTypography.bodySmall.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Qty',
                          style: AppTypography.bodySmall.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Price',
                          style: AppTypography.bodySmall.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Total',
                          textAlign: TextAlign.right,
                          style: AppTypography.bodySmall.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Add line item button
                InkWell(
                  onTap: _addLineItem,
                  child: Container(
                    padding: AppSpacing.cardPadding,
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: AppColors.border)),
                      color: AppColors.backgroundCard,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_circle,
                          color: AppColors.primary700,
                          size: 20,
                        ),
                        AppSpacing.gapH2,
                        Text(
                          'Add line item',
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          required ? '$label *' : label,
          style: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        AppSpacing.gapV1,
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
          ),
          validator: required ? (value) {
            if (value == null || value.isEmpty) {
              return '$label is required';
            }
            return null;
          } : null,
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        AppSpacing.gapV1,
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((item) => DropdownMenuItem(
            value: item,
            child: Text(item),
          )).toList(),
          onChanged: onChanged,
          decoration: const InputDecoration(),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Expected close date',
          style: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        AppSpacing.gapV1,
        InkWell(
          onTap: _selectDate,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
              color: AppColors.backgroundCard,
            ),
            child: Text(
              _expectedCloseDate != null 
                ? '${_expectedCloseDate!.day}/${_expectedCloseDate!.month}/${_expectedCloseDate!.year}'
                : 'Select date',
              style: AppTypography.bodyMedium.copyWith(
                color: _expectedCloseDate != null ? AppColors.textPrimary : AppColors.textTertiary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      color: AppColors.backgroundPrimary,
      padding: AppSpacing.screenPadding,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            
            AppSpacing.gapH3,
            
            BaseButton(
              text: 'Save as draft',
              variant: ButtonVariant.secondary,
              onPressed: _isLoading ? null : _saveDraft,
            ),
            
            AppSpacing.gapH3,
            
            BaseButton(
              text: _isLoading ? 'Saving...' : 'Save & close',
              variant: ButtonVariant.primary,
              onPressed: _isLoading ? null : _saveDeal,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  // Action methods
  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _expectedCloseDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    
    if (date != null) {
      setState(() {
        _expectedCloseDate = date;
      });
    }
  }

  void _addLineItem() {
    print('Add line item');
    // TODO: Implement add line item functionality
  }

  void _saveDraft() async {
    print('Save as draft');
    // TODO: Implement save as draft
  }

  void _saveDeal() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        final deal = Deal(
          id: widget.deal?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
          title: _nameController.text,
          value: double.tryParse(_valueController.text.replaceAll(',', '')) ?? 0.0,
          description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
          status: _mapStageToStatus(_stage ?? 'Qualification'),
          closeDate: _expectedCloseDate,
        );

        widget.onSave?.call(deal);
        
        // Simulate save delay
        await Future.delayed(const Duration(seconds: 1));
        
        if (mounted) {
          Navigator.pop(context, deal);
        }
      } catch (e) {
        print('Error saving deal: $e');
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  DealStatus _mapStageToStatus(String stage) {
    switch (stage.toLowerCase()) {
      case 'qualification':
        return DealStatus.qualified;
      case 'needs analysis':
      case 'proposal':
        return DealStatus.proposal;
      case 'negotiation':
        return DealStatus.negotiation;
      case 'closed won':
        return DealStatus.closed;
      case 'closed lost':
        return DealStatus.lost;
      default:
        return DealStatus.prospect;
    }
  }
}