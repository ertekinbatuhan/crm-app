extension DateTimeExtensions on DateTime {
  
  String toUserFriendlyString({bool showFullDate = false}) {
    final now = DateTime.now();
    final difference = this.difference(now).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference == -1) {
      return 'Yesterday';
    } else if (difference > 0) {
      if (showFullDate) {
        return 'in $difference days (${this.day}/${this.month}/${this.year})';
      } else {
        return 'in $difference days';
      }
    } else {
      if (showFullDate) {
        return '${difference.abs()} days ago (${this.day}/${this.month}/${this.year})';
      } else {
        return '${difference.abs()} days ago';
      }
    }
  }
}