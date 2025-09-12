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
          // Today button and Calendar header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF007AFF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today, color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Today',
                      style: TextStyle(
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
          
          // Calendar Widget
          CustomCalendarWidget(
            selectedDate: viewModel.selectedDate,
            focusedDate: viewModel.currentMonth,
            eventDates: viewModel.tasks
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
}