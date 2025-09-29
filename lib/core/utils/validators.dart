class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email field is required';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone field is required';
    }
    
    final phoneRegex = RegExp(r'^(\+1)?[2-9][0-9]{2}[2-9][0-9]{2}[0-9]{4}$');
    final cleanValue = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    if (!phoneRegex.hasMatch(cleanValue)) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }

  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  static String? minLength(String? value, int minLength, [String? fieldName]) {
    if (value == null || value.length < minLength) {
      return '${fieldName ?? 'This field'} must be at least $minLength characters';
    }
    return null;
  }

  static String? maxLength(String? value, int maxLength, [String? fieldName]) {
    if (value != null && value.length > maxLength) {
      return '${fieldName ?? 'This field'} must be at most $maxLength characters';
    }
    return null;
  }

  static String? positiveNumber(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    
    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }
    
    if (number <= 0) {
      return 'Number must be greater than zero';
    }
    
    return null;
  }

  static String? dateNotInPast(DateTime? value, [String? fieldName]) {
    if (value == null) return null;
    
    if (value.isBefore(DateTime.now())) {
      return '${fieldName ?? 'Date'} cannot be in the past';
    }
    
    return null;
  }

  static String? Function(String?) combine(List<String? Function(String?)> validators) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}