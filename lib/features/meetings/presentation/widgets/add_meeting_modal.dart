import 'package:flutter/material.dart';
import '../../../../core/components/base/base_button.dart';
import '../../../../core/components/base/base_input.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class AddMeetingModal extends StatefulWidget {
  final VoidCallback? onMeetingAdded;
  final Map<String, dynamic>? initialData;

  const AddMeetingModal({
    super.key,
    this.onMeetingAdded,
    this.initialData,
  });

  @override
  State<AddMeetingModal> createState() => _AddMeetingModalState();
}

class _AddMeetingModalState extends State<AddMeetingModal> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Controllers
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _durationController = TextEditingController();
  final _locationController = TextEditingController();
  final _agendaController = TextEditingController();

  // Form state
  String _selectedMeetingType = 'call';
  String _selectedTimezone = '';
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  // Mock participants data
  final List<String> _participantAvatars = [
    'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face',
    'https://images.unsplash.com/photo-1494790108755-2616b612b8c1?w=100&h=100&fit=crop&crop=face',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
  ];

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.initialData != null) {
      final data = widget.initialData!;
      _titleController.text = data['title'] ?? '';
      _locationController.text = data['location'] ?? '';
      _agendaController.text = data['agenda'] ?? '';
      _selectedMeetingType = data['type'] ?? 'call';
      _selectedTimezone = data['timezone'] ?? '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _durationController.dispose();
    _locationController.dispose();
    _agendaController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              color: AppColors.backgroundPrimary,
              border: Border(
                bottom: BorderSide(color: AppColors.borderLight, width: 1),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sp4),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      color: AppColors.textSecondary,
                    ),
                    Expanded(
                      child: Text(
                        'New Meeting',
                        style: AppTypography.headlineSmall.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48), // Balance for close button
                  ],
                ),
              ),
            ),
          ),
          // Content
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(AppSpacing.sp4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMeetingTypeSelector(),
                    const SizedBox(height: AppSpacing.sp6),
                    _buildTitleInput(),
                    const SizedBox(height: AppSpacing.sp6),
                    _buildDateTimeSection(),
                    const SizedBox(height: AppSpacing.sp6),
                    _buildLocationSection(),
                    const SizedBox(height: AppSpacing.sp6),
                    _buildParticipantsSection(),
                    const SizedBox(height: AppSpacing.sp6),
                    _buildMeetingDetailsSection(),
                    const SizedBox(height: 100), // Space for footer
                  ],
                ),
              ),
            ),
          ),
          // Footer
          Container(
            decoration: const BoxDecoration(
              color: AppColors.backgroundPrimary,
              border: Border(
                top: BorderSide(color: AppColors.borderLight, width: 1),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sp4),
                child: Row(
                  children: [
                    Expanded(
                      child: BaseButton(
                        text: 'Cancel',
                        variant: ButtonVariant.outlined,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sp4),
                    Expanded(
                      child: BaseButton(
                        text: 'Schedule Meeting',
                        variant: ButtonVariant.primary,
                        onPressed: _saveMeeting,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingTypeSelector() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXXL),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _buildTypeOption('call', 'Call', Icons.phone),
          _buildTypeOption('video', 'Video', Icons.videocam),
          _buildTypeOption('in_person', 'In-person', Icons.groups),
        ],
      ),
    );
  }

  Widget _buildTypeOption(String value, String label, IconData icon) {
    final isSelected = _selectedMeetingType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedMeetingType = value;
          });
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.backgroundPrimary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusL),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? AppColors.primary700 : AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.primary700 : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleInput() {
    return BaseInput(
      hint: 'Meeting Title',
      controller: _titleController,
      fillColor: AppColors.backgroundSecondary,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a meeting title';
        }
        return null;
      },
    );
  }

  Widget _buildDateTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date & Time',
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sp4),
        // Date Input
        BaseInput(
          hint: 'Select Date',
          controller: _dateController,
          fillColor: AppColors.backgroundSecondary,
          readOnly: true,
          onTap: _selectDate,
          suffixIcon: const Icon(
            Icons.calendar_today,
            color: AppColors.textSecondary,
            size: 20,
          ),
        ),
        const SizedBox(height: AppSpacing.sp4),
        // Time Inputs
        Row(
          children: [
            Expanded(
              child: BaseInput(
                hint: 'Start Time',
                controller: _startTimeController,
                fillColor: AppColors.backgroundSecondary,
                readOnly: true,
                onTap: () => _selectTime(true),
              ),
            ),
            const SizedBox(width: AppSpacing.sp4),
            Expanded(
              child: BaseInput(
                hint: 'End Time',
                controller: _endTimeController,
                fillColor: AppColors.backgroundSecondary,
                readOnly: true,
                onTap: () => _selectTime(false),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sp4),
        // Timezone Dropdown
        BaseInput(
          hint: 'Timezone',
          controller: TextEditingController(text: _selectedTimezone),
          fillColor: AppColors.backgroundSecondary,
          readOnly: true,
          onTap: _showTimezoneSelector,
        ),
        const SizedBox(height: AppSpacing.sp4),
        // Duration
        BaseInput(
          hint: 'Duration',
          controller: _durationController,
          fillColor: AppColors.backgroundSecondary,
        ),
        const SizedBox(height: AppSpacing.sp4),
        // Recurring Button
        _buildOptionButton('Recurring', () => _showRecurringOptions()),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location/Platform',
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sp4),
        BaseInput(
          hint: _getLocationHint(),
          controller: _locationController,
          fillColor: AppColors.backgroundSecondary,
        ),
      ],
    );
  }

  String _getLocationHint() {
    switch (_selectedMeetingType) {
      case 'call':
        return 'Phone number or conference line';
      case 'video':
        return 'Enter Meeting Link';
      case 'in_person':
        return 'Enter Address';
      default:
        return 'Enter Address or Meeting Link';
    }
  }

  Widget _buildParticipantsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Participants',
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sp4),
        Row(
          children: [
            // Avatar Stack
            SizedBox(
              height: 40,
              child: Stack(
                children: [
                  for (int i = 0; i < _participantAvatars.length; i++)
                    Positioned(
                      left: i * 24.0,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.backgroundPrimary,
                            width: 2,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(_participantAvatars[i]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sp4),
            // Add Button
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.backgroundSecondary,
              ),
              child: IconButton(
                onPressed: _addParticipant,
                icon: const Icon(
                  Icons.add,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMeetingDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Meeting Details',
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sp4),

        _buildOptionButton('Related Deal/Contact', () => _showRelatedOptions()),
        const SizedBox(height: AppSpacing.sp4),
        BaseInput.multiline(
          hint: 'Agenda',
          controller: _agendaController,
          minLines: 4,
          maxLines: 6,
        ),
        const SizedBox(height: AppSpacing.sp4),

        _buildOptionButton('Attachments', () => _showAttachments()),
        const SizedBox(height: AppSpacing.sp4),
        _buildOptionButton('Reminder', () => _showReminderOptions()),
      ],
    );
  }

  Widget _buildOptionButton(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.sp4),
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(AppSpacing.radiusL),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
        _dateController.text = '${date.day}/${date.month}/${date.year}';
      });
    }
  }

  Future<void> _selectTime(bool isStartTime) async {
    final time = await showTimePicker(
      context: context,
      initialTime: (isStartTime ? _startTime : _endTime) ?? TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        if (isStartTime) {
          _startTime = time;
          _startTimeController.text = time.format(context);
          // Auto-calculate duration if both times are set
          if (_endTime != null) {
            _calculateDuration();
          }
        } else {
          _endTime = time;
          _endTimeController.text = time.format(context);
          // Auto-calculate duration if both times are set
          if (_startTime != null) {
            _calculateDuration();
          }
        }
      });
    }
  }

  void _calculateDuration() {
    if (_startTime != null && _endTime != null) {
      final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
      final endMinutes = _endTime!.hour * 60 + _endTime!.minute;
      final durationMinutes = endMinutes - startMinutes;
      
      if (durationMinutes > 0) {
        final hours = durationMinutes ~/ 60;
        final minutes = durationMinutes % 60;
        _durationController.text = hours > 0 
            ? '${hours}h ${minutes}m'
            : '${minutes}m';
      }
    }
  }

  void _showTimezoneSelector() {
    // TODO: Implement timezone selector
    setState(() {
      _selectedTimezone = 'PST';
    });
  }

  void _showRecurringOptions() {
    // TODO: Implement recurring options
  }

  void _addParticipant() {
    // TODO: Implement add participant
  }

  void _showRelatedOptions() {
    // TODO: Implement related deal/contact selector
  }

  void _showAttachments() {
    // TODO: Implement attachments
  }

  void _showReminderOptions() {
    // TODO: Implement reminder options
  }

  void _saveMeeting() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate required fields
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a meeting title')),
      );
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a meeting date')),
      );
      return;
    }

    // TODO: Implement actual save logic
    // When implemented, create meeting data object with:
    // - title: _titleController.text
    // - type: _selectedMeetingType
    // - date: _selectedDate
    // - startTime: _startTime
    // - endTime: _endTime
    // - timezone: _selectedTimezone
    // - duration: _durationController.text
    // - location: _locationController.text
    // - agenda: _agendaController.text

    // Close modal and notify parent
    Navigator.of(context).pop();
    widget.onMeetingAdded?.call();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Meeting scheduled successfully'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}