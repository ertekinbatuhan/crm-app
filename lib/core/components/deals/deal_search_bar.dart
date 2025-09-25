import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class DealSearchBar extends StatelessWidget {
  final Function(String) onChanged;
  
  const DealSearchBar({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search deals...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusS),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.searchBarBackgroundColor,
        ),
      ),
    );
  }
}