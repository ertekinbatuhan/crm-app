extension DateTimeExtensions on DateTime {
  String toUserFriendlyString({bool showFullDate = false}) {
    final now = DateTime.now();
    final difference = now.difference(this);
    
    if (showFullDate) {
      return '${month.toString().padLeft(2, '0')}/${day.toString().padLeft(2, '0')}/$year ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    }
    
    if (difference.inDays == 0) {
      return 'Today ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return '${weekdays[weekday - 1]} ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    } else {
      return '${month.toString().padLeft(2, '0')}/${day.toString().padLeft(2, '0')}/$year';
    }
  }

  String toDateString() {
    return '${month.toString().padLeft(2, '0')}/${day.toString().padLeft(2, '0')}/$year';
  }

  String toTimeString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}