class StatModel {
  final String title;
  final String value;
  final String? changeLabel;
  final double? changeValue;
  final bool isPositive;

  const StatModel({
    required this.title,
    required this.value,
    this.changeLabel,
    this.changeValue,
    this.isPositive = true,
  });

  String get formattedChange {
    if (changeLabel != null && changeLabel!.isNotEmpty) {
      return changeLabel!;
    }
    if (changeValue != null) {
      final sign = changeValue! >= 0 ? '+' : '';
      return '$sign${changeValue!.toStringAsFixed(1)}%';
    }
    return '';
  }

  bool get hasChange => formattedChange.isNotEmpty;
}
