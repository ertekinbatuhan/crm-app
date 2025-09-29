import 'package:flutter/material.dart';
import '../../../viewmodels/tasks_viewmodel.dart';
import '../calendar/custom_calendar_widget.dart';

class TasksCalendarHeader extends StatelessWidget {
  final TasksViewModel viewModel;

  const TasksCalendarHeader({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final isToday = _isSameDay(viewModel.selectedDate, DateTime.now());
    final dayText = _getDayText(viewModel.selectedDate, isToday);
    
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF007AFF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      dayText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          

          CustomCalendarWidget(
            selectedDate: viewModel.selectedDate,
            focusedDate: viewModel.currentMonth,
            eventDates: viewModel.allTasks
                .where((task) => task.dueDate != null)
                .map((task) => task.dueDate!)
                .toList(),
            onDateSelected: (date) {
              viewModel.selectDate(date);
            },
            onPreviousMonth: () => viewModel.goToPreviousMonth(),
            onNextMonth: () => viewModel.goToNextMonth(),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  String _getDayText(DateTime selectedDate, bool isToday) {
    if (isToday) {
      return 'Today';
    }
    
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    if (_isSameDay(selectedDate, yesterday)) {
      return 'Yesterday';
    }
    
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    if (_isSameDay(selectedDate, tomorrow)) {
      return 'Tomorrow';
    }
    
    // Format date as "Oct 31"
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return '${months[selectedDate.month - 1]} ${selectedDate.day}';
  }
}