import 'package:flutter/material.dart';

class AppSection<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final Widget Function(T) itemBuilder;
  final String? emptyMessage;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final TextStyle? titleStyle;
  final Widget? titleSuffix;
  final bool showEmptyState;

  const AppSection({
    super.key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    this.emptyMessage,
    this.margin,
    this.padding,
    this.titleStyle,
    this.titleSuffix,
    this.showEmptyState = true,
  });

  @override
  Widget build(BuildContext context) {
    final defaultEmptyMessage = emptyMessage ?? 'No ${title.toLowerCase()} found';
    
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: titleStyle ?? const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (titleSuffix != null) titleSuffix!,
              ],
            ),
          ),
          
          // Content
          if (items.isEmpty && showEmptyState)
            _buildEmptyState(defaultEmptyMessage)
          else
            ...items.map((item) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: itemBuilder(item),
            )).toList(),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}