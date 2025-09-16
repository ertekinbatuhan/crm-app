import 'package:flutter/material.dart';
import '../../../models/task_model.dart';
import '../../../models/contact_model.dart';
import '../../../models/deal_model.dart';

class AddTaskModal extends StatefulWidget {
  final List<Contact> contacts;
  final List<Deal> deals;
  final Function(Task) onTaskCreated;

  const AddTaskModal({
    super.key,
    required this.contacts,
    required this.deals,
    required this.onTaskCreated,
  });

  @override
  State<AddTaskModal> createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  final _formKey = GlobalKey<FormState>();
  final _taskNameController = TextEditingController();
  DateTime? _selectedDate;
  TaskPriority? _selectedPriority;
  Contact? _selectedContact;
  Deal? _selectedDeal;

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
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
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
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'New Task',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 36), // Balance the close button
                ],
              ),
            ),

            // Form Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Task Name
                      _buildInputField(
                        label: 'Task Name',
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

                      const SizedBox(height: 12),

                      // Due Date
                      _buildInputField(
                        label: 'Due Date',
                        child: GestureDetector(
                          onTap: _selectDate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
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

                      const SizedBox(height: 12),

                      // Priority
                      _buildInputField(
                        label: 'Priority',
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: Colors.white,
                            highlightColor: Colors.grey.withValues(alpha: 0.1),
                            splashColor: Colors.grey.withValues(alpha: 0.1),
                          ),
                          child: DropdownButtonFormField<TaskPriority>(
                            initialValue: _selectedPriority,
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
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Associated Contact
                      _buildInputField(
                        label: 'Associated Contact',
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: Colors.white,
                            highlightColor: Colors.grey.withValues(alpha: 0.1),
                            splashColor: Colors.grey.withValues(alpha: 0.1),
                          ),
                          child: DropdownButtonFormField<Contact>(
                            initialValue: _selectedContact,
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

                      // Associated Deal
                      _buildInputField(
                        label: 'Associated Deal',
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: Colors.white,
                            highlightColor: Colors.grey.withValues(alpha: 0.1),
                            splashColor: Colors.grey.withValues(alpha: 0.1),
                          ),
                          child: DropdownButtonFormField<Deal>(
                            initialValue: _selectedDeal,
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

                      // Create Task Button
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
                              color: const Color(
                                0xFF007AFF,
                              ).withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _createTask,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Create Task',
                            style: TextStyle(
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

  Widget _buildInputField({required String label, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
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

  Future<void> _selectDate() async {
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
            dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
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

  void _createTask() {
    if (_formKey.currentState!.validate()) {
      final task = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _taskNameController.text,
        dueDate: _selectedDate,
        isCompleted: false,
        type: TaskType.general,
        priority: _selectedPriority ?? TaskPriority.medium,
        associatedContactId: _selectedContact?.id,
        associatedDealId: _selectedDeal?.id,
      );

      widget.onTaskCreated(task);
    }
  }
}
