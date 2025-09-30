import 'package:flutter/material.dart';
import '../../../models/task_model.dart';
import '../../../models/contact_model.dart';
import '../../../models/deal_model.dart';
import '../../constants/app_constants.dart';

class AddTaskModal extends StatefulWidget {
  final List<Contact> contacts;
  final List<Deal> deals;
  final Function(Task) onSubmit;
  final Task? initialTask;
  final String title;
  final String submitButtonLabel;

  const AddTaskModal({
    super.key,
    required this.contacts,
    required this.deals,
    required this.onSubmit,
    this.initialTask,
    this.title = 'New Task',
    this.submitButtonLabel = 'Create Task',
  });

  @override
  State<AddTaskModal> createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _taskNameController;
  DateTime? _selectedDate;
  TaskPriority? _selectedPriority;
  Contact? _selectedContact;
  Deal? _selectedDeal;

  bool get _isEditMode => widget.initialTask != null;

  @override
  void initState() {
    super.initState();
    _taskNameController = TextEditingController(
      text: widget.initialTask?.title ?? '',
    );
    _selectedDate = widget.initialTask?.dueDate;
    _selectedPriority = widget.initialTask?.priority ?? TaskPriority.medium;
    _selectedContact = _findContactById(
      widget.initialTask?.associatedContactId,
    );
    _selectedDeal = _findDealById(widget.initialTask?.associatedDealId);
  }

  Contact? _findContactById(String? contactId) {
    if (contactId == null) return null;
    for (final contact in widget.contacts) {
      if (contact.id == contactId) {
        return contact;
      }
    }
    return null;
  }

  Deal? _findDealById(String? dealId) {
    if (dealId == null) return null;
    for (final deal in widget.deals) {
      if (deal.id == dealId) {
        return deal;
      }
    }
    return null;
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
          maxWidth: 400,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF007AFF), Color(0xFF0056CC)],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (mounted && context.mounted) {
                        Navigator.of(context).pop(false);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
            ),

            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildInputField(
                        label: 'Task Name',
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
                              errorStyle: const TextStyle(
                                color: AppColors.error,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          child: TextFormField(
                            controller: _taskNameController,
                            decoration: const InputDecoration(
                              hintText: 'Enter task name',
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a task name';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      FormField<DateTime>(
                        validator: (_) {
                          if (_selectedDate == null) {
                            return 'Please select a due date';
                          }
                          return null;
                        },
                        builder: (state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInputField(
                                label: 'Due Date',
                                child: GestureDetector(
                                  onTap: () => _selectDate(state),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _selectedDate != null
                                                ? _formatDate(_selectedDate!)
                                                : 'Select due date',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: _selectedDate != null
                                                  ? Colors.black87
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.calendar_today,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if (state.hasError)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8, left: 16),
                                  child: Text(
                                    state.errorText!,
                                    style: const TextStyle(
                                      color: AppColors.error,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 12),

                      _buildInputField(
                        label: 'Priority',
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: Colors.white,
                            highlightColor: Colors.grey.withOpacity(0.1),
                            splashColor: Colors.grey.withOpacity(0.1),
                          ),
                          child: DropdownButtonFormField<TaskPriority>(
                            value: _selectedPriority,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Select priority',
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 0,
                              ),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                            dropdownColor: Colors.white,
                            selectedItemBuilder: (BuildContext context) {
                              return TaskPriority.values.map((priority) {
                                return Text(
                                  priority.displayName,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                  ),
                                );
                              }).toList();
                            },
                            items: TaskPriority.values.map((priority) {
                              return DropdownMenuItem(
                                value: priority,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    priority.displayName,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedPriority = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a priority';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      _buildInputField(
                        label: 'Associated Contact',
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: Colors.white,
                            highlightColor: Colors.grey.withOpacity(0.1),
                            splashColor: Colors.grey.withOpacity(0.1),
                          ),
                          child: DropdownButtonFormField<Contact>(
                            value: _selectedContact,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Select contact',
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 0,
                              ),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                            dropdownColor: Colors.white,
                            selectedItemBuilder: (BuildContext context) {
                              return widget.contacts.map((contact) {
                                return Text(
                                  contact.name,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                  ),
                                );
                              }).toList();
                            },
                            items: widget.contacts.map((contact) {
                              return DropdownMenuItem(
                                value: contact,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    contact.name,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedContact = value;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      _buildInputField(
                        label: 'Associated Deal',
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: Colors.white,
                            highlightColor: Colors.grey.withOpacity(0.1),
                            splashColor: Colors.grey.withOpacity(0.1),
                          ),
                          child: DropdownButtonFormField<Deal>(
                            value: _selectedDeal,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Select deal',
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 0,
                              ),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                            dropdownColor: Colors.white,
                            selectedItemBuilder: (BuildContext context) {
                              return widget.deals.map((deal) {
                                return Text(
                                  deal.title,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                  ),
                                );
                              }).toList();
                            },
                            items: widget.deals.map((deal) {
                              return DropdownMenuItem(
                                value: deal,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    deal.title,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedDeal = value;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xFF007AFF), Color(0xFF0056CC)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF007AFF).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _submitTask,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            widget.submitButtonLabel,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Future<void> _selectDate([FormFieldState<DateTime?>? state]) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black87, // Header background ve selected date
              onPrimary: Colors.white, // Header text color
              surface: Colors.white, // Calendar background
              onSurface: Colors.black87, // Calendar text
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      state?.didChange(picked);
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _submitTask() {
    final isValid = _formKey.currentState!.validate();

    if (!isValid || _selectedPriority == null || _selectedDate == null) {
      return;
    }

    Task task;
    if (_isEditMode) {
      task = widget.initialTask!.copyWith(
        title: _taskNameController.text.trim(),
        dueDate: _selectedDate,
        priority: _selectedPriority!,
        associatedContactId: _selectedContact?.id,
        associatedDealId: _selectedDeal?.id,
      );
    } else {
      task = Task(
        id: '',
        title: _taskNameController.text.trim(),
        dueDate: _selectedDate,
        isCompleted: false,
        type: TaskType.general,
        priority: _selectedPriority ?? TaskPriority.medium,
        associatedContactId: _selectedContact?.id,
        associatedDealId: _selectedDeal?.id,
      );
    }

    widget.onSubmit(task);
  }
}
