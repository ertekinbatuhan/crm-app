import 'package:flutter/material.dart';

class CustomCalendarWidget extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime focusedDate;
  final List<DateTime> eventDates;
  final Function(DateTime) onDateSelected;
  final VoidCallback? onPreviousMonth;
  final VoidCallback? onNextMonth;

  const CustomCalendarWidget({
    super.key,
    required this.selectedDate,
    required this.focusedDate,
    required this.eventDates,
    required this.onDateSelected,
    this.onPreviousMonth,
    this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildWeekDaysHeader(),
          const SizedBox(height: 8),
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onPreviousMonth,
          icon: const Icon(Icons.chevron_left, color: Colors.grey),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        Text(
          '${monthNames[focusedDate.month - 1]} ${focusedDate.year}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        IconButton(
          onPressed: onNextMonth,
          icon: const Icon(Icons.chevron_right, color: Colors.grey),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildWeekDaysHeader() {
    const weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekDays
          .map(
            (day) => SizedBox(
              width: 32,
              child: Text(
                day,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildCalendarGrid() {
    return _buildMonthView();
  }

  Widget _buildMonthView() {
    final firstDayOfMonth = DateTime(focusedDate.year, focusedDate.month, 1);
    final lastDayOfMonth = DateTime(focusedDate.year, focusedDate.month + 1, 0);
    final firstDayWeekday = firstDayOfMonth.weekday % 7;

    final days = <Widget>[];

    // Add empty spaces for days before the first day of the month
    for (int i = 0; i < firstDayWeekday; i++) {
      days.add(const SizedBox(width: 32, height: 32));
    }

    // Add days of the month
    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      final date = DateTime(focusedDate.year, focusedDate.month, day);
      days.add(_buildDayCell(date));
    }

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 7,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      physics: const NeverScrollableScrollPhysics(),
      children: days,
    );
  }

  Widget _buildDayCell(DateTime date) {
    final isSelected = _isSameDay(date, selectedDate);
    final isToday = _isSameDay(date, DateTime.now());
    final hasEvent = eventDates.any((eventDate) => _isSameDay(eventDate, date));

    return GestureDetector(
      onTap: () => onDateSelected(date),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF007AFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: isToday && !isSelected
              ? Border.all(color: const Color(0xFF007AFF), width: 1)
              : null,
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : isToday
                      ? const Color(0xFF007AFF)
                      : Colors.black87,
                ),
              ),
            ),
            if (hasEvent && !isSelected)
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF007AFF),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
