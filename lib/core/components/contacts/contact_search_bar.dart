import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class ContactSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const ContactSearchBar({
    super.key,
    this.hintText = 'Search contacts...',
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
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