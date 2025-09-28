import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../base/base_input.dart';

class ContactSearchBar extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;

  const ContactSearchBar({
    super.key,
    this.hintText = AppStrings.searchContacts,
    this.onChanged,
  });

  @override
  State<ContactSearchBar> createState() => _ContactSearchBarState();
}

class _ContactSearchBarState extends State<ContactSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: SearchInputField(
        controller: _controller,
        hint: widget.hintText,
        onChanged: widget.onChanged,
        onClear: () => widget.onChanged?.call(''),
      ),
    );
  }
}
