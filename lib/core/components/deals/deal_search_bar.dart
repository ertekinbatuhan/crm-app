import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../base/base_input.dart';

class DealSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const DealSearchBar({super.key, required this.onChanged});

  @override
  State<DealSearchBar> createState() => _DealSearchBarState();
}

class _DealSearchBarState extends State<DealSearchBar> {
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
        hint: AppStrings.searchDeals,
        onChanged: widget.onChanged,
        onClear: () => widget.onChanged(''),
      ),
    );
  }
}
