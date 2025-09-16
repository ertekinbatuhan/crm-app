import 'package:flutter/material.dart';
import '../../models/contact_model.dart';
import '../../core/components/base/base_card.dart';
import '../../core/components/base/base_button.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class AddContactModal extends StatefulWidget {
  final Contact? contact; // null for add, contact object for edit
  final Function(Contact)? onSave;

  const AddContactModal({
    super.key,
    this.contact,
    this.onSave,
  });

  @override
  State<AddContactModal> createState() => _AddContactModalState();
}

class _AddContactModalState extends State<AddContactModal> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _companyController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _websiteController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _countryController = TextEditingController();
  final _tagsController = TextEditingController();
  final _notesController = TextEditingController();
  
  // Dropdowns
  String? _contactType;
  String? _leadSource;
  String? _assignedTo;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _populateFields();
    }
  }

  void _populateFields() {
    final contact = widget.contact!;
    _firstNameController.text = contact.name.split(' ').first;
    if (contact.name.split(' ').length > 1) {
      _lastNameController.text = contact.name.split(' ').skip(1).join(' ');
    }
    _companyController.text = contact.company ?? '';
    _emailController.text = contact.email ?? '';
    _phoneController.text = contact.phone ?? '';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _jobTitleController.dispose();
    _companyController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _countryController.dispose();
    _tagsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.contact != null;
    
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: _buildAppBar(isEdit),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Form content
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.screenPadding,
                child: Column(
                  children: [
                    _buildBasicInformationSection(),
                    AppSpacing.gapV6,
                    _buildContactDetailsSection(),
                    AppSpacing.gapV6,
                    _buildAddressSection(),
                    AppSpacing.gapV6,
                    _buildAdditionalInfoSection(),
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

  PreferredSizeWidget _buildAppBar(bool isEdit) {
    return AppBar(
      backgroundColor: AppColors.backgroundPrimary,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        isEdit ? 'Edit Contact' : 'New Contact',
        style: AppTypography.headlineSmall.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: _isLoading ? null : _saveContact,
          child: Text(
            'Save',
            style: AppTypography.labelMedium.copyWith(
              color: _isLoading ? AppColors.textTertiary : AppColors.primary700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        AppSpacing.gapH2,
      ],
    );
  }

  Widget _buildBasicInformationSection() {
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic Information',
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          
          AppSpacing.gapV4,
          
          // Profile Photo
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.surfaceDisabled,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add_a_photo,
                  color: AppColors.textTertiary,
                  size: 32,
                ),
              ),
              AppSpacing.gapH4,
              TextButton(
                onPressed: _uploadPhoto,
                child: Text(
                  'Upload Profile Photo',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primary700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          
          AppSpacing.gapV4,
          
          // Name fields
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name *',
                    labelStyle: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'First name is required';
                    }
                    return null;
                  },
                ),
              ),
              AppSpacing.gapH4,
              Expanded(
                child: TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name *',
                    labelStyle: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Last name is required';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          
          AppSpacing.gapV4,
          
          // Job Title
          TextFormField(
            controller: _jobTitleController,
            decoration: InputDecoration(
              labelText: 'Job Title',
              labelStyle: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          AppSpacing.gapV4,
          
          // Company
          TextFormField(
            controller: _companyController,
            decoration: InputDecoration(
              labelText: 'Company',
              labelStyle: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          AppSpacing.gapV4,
          
          // Contact Type
          DropdownButtonFormField<String>(
            value: _contactType,
            decoration: InputDecoration(
              labelText: 'Contact Type',
              labelStyle: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'lead', child: Text('Lead')),
              DropdownMenuItem(value: 'customer', child: Text('Customer')),
              DropdownMenuItem(value: 'partner', child: Text('Partner')),
            ],
            onChanged: (value) {
              setState(() {
                _contactType = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactDetailsSection() {
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Details',
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          
          AppSpacing.gapV4,
          
          // Email
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Enter a valid email address';
                }
              }
              return null;
            },
          ),
          
          AppSpacing.gapV4,
          
          // Phone
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              labelStyle: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          AppSpacing.gapV4,
          
          // Website
          TextFormField(
            controller: _websiteController,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              labelText: 'Website',
              labelStyle: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Address',
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          
          AppSpacing.gapV4,
          
          // Street
          TextFormField(
            controller: _streetController,
            decoration: InputDecoration(
              labelText: 'Street',
              labelStyle: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          AppSpacing.gapV4,
          
          // City and State
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    labelText: 'City',
                    labelStyle: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              AppSpacing.gapH4,
              Expanded(
                child: TextFormField(
                  controller: _stateController,
                  decoration: InputDecoration(
                    labelText: 'State',
                    labelStyle: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          AppSpacing.gapV4,
          
          // Zip and Country
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _zipController,
                  decoration: InputDecoration(
                    labelText: 'Zip Code',
                    labelStyle: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              AppSpacing.gapH4,
              Expanded(
                child: TextFormField(
                  controller: _countryController,
                  decoration: InputDecoration(
                    labelText: 'Country',
                    labelStyle: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoSection() {
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Additional Info',
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          
          AppSpacing.gapV4,
          
          // Tags
          TextFormField(
            controller: _tagsController,
            decoration: InputDecoration(
              labelText: 'Tags',
              hintText: 'Add tags...',
              labelStyle: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          AppSpacing.gapV4,
          
          // Lead Source
          DropdownButtonFormField<String>(
            value: _leadSource,
            decoration: InputDecoration(
              labelText: 'Lead Source',
              labelStyle: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'website', child: Text('Website')),
              DropdownMenuItem(value: 'referral', child: Text('Referral')),
              DropdownMenuItem(value: 'advertisement', child: Text('Advertisement')),
            ],
            onChanged: (value) {
              setState(() {
                _leadSource = value;
              });
            },
          ),
          
          AppSpacing.gapV4,
          
          // Assigned To
          DropdownButtonFormField<String>(
            value: _assignedTo,
            decoration: InputDecoration(
              labelText: 'Assigned To',
              labelStyle: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'john_doe', child: Text('John Doe')),
              DropdownMenuItem(value: 'jane_smith', child: Text('Jane Smith')),
            ],
            onChanged: (value) {
              setState(() {
                _assignedTo = value;
              });
            },
          ),
          
          AppSpacing.gapV4,
          
          // Notes
          TextFormField(
            controller: _notesController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Notes',
              labelStyle: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      color: AppColors.backgroundPrimary.withOpacity(0.8),
      padding: AppSpacing.screenPadding,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BaseButton(
              text: 'Cancel',
              variant: ButtonVariant.secondary,
              onPressed: () => Navigator.pop(context),
            ),
            
            Row(
              children: [
                if (widget.contact == null) // Only show for new contacts
                  TextButton(
                    onPressed: _isLoading ? null : _saveAndNew,
                    child: Text(
                      'Save & New',
                      style: AppTypography.labelMedium.copyWith(
                        color: _isLoading ? AppColors.textTertiary : AppColors.primary700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                
                AppSpacing.gapH4,
                
                BaseButton(
                  text: _isLoading ? 'Saving...' : 'Save',
                  variant: ButtonVariant.primary,
                  onPressed: _isLoading ? null : _saveContact,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Action methods
  void _uploadPhoto() {
    print('Upload photo');
    // TODO: Implement photo upload
  }

  void _saveContact() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        final contact = Contact(
          id: widget.contact?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
          name: '${_firstNameController.text} ${_lastNameController.text}',
          email: _emailController.text.isEmpty ? null : _emailController.text,
          phone: _phoneController.text.isEmpty ? null : _phoneController.text,
          company: _companyController.text.isEmpty ? null : _companyController.text,
        );

        widget.onSave?.call(contact);
        
        // Simulate save delay
        await Future.delayed(const Duration(seconds: 1));
        
        if (mounted) {
          Navigator.pop(context, contact);
        }
      } catch (e) {
        // Handle error
        print('Error saving contact: $e');
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _saveAndNew() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        final contact = Contact(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: '${_firstNameController.text} ${_lastNameController.text}',
          email: _emailController.text.isEmpty ? null : _emailController.text,
          phone: _phoneController.text.isEmpty ? null : _phoneController.text,
          company: _companyController.text.isEmpty ? null : _companyController.text,
        );

        widget.onSave?.call(contact);
        
        // Clear form for new contact
        if (mounted) {
          _clearForm();
        }
      } catch (e) {
        print('Error saving contact: $e');
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _clearForm() {
    _firstNameController.clear();
    _lastNameController.clear();
    _jobTitleController.clear();
    _companyController.clear();
    _emailController.clear();
    _phoneController.clear();
    _websiteController.clear();
    _streetController.clear();
    _cityController.clear();
    _stateController.clear();
    _zipController.clear();
    _countryController.clear();
    _tagsController.clear();
    _notesController.clear();
    
    setState(() {
      _contactType = null;
      _leadSource = null;
      _assignedTo = null;
    });
  }
}