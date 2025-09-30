import 'package:flutter/material.dart';
import '../../../viewmodels/reports_viewmodel.dart';
import '../../constants/app_constants.dart';

class ReportsHeader extends StatelessWidget {
  final ReportsViewModel viewModel;

  const ReportsHeader({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.paddingS),
          decoration: AppDecorations.chip.copyWith(
            color: AppColors.accent.withOpacity(0.1),
          ),
          child: Icon(
            Icons.bar_chart,
            color: AppColors.accent,
            size: AppSizes.iconM,
          ),
        ),
        const SizedBox(width: AppSizes.paddingM),
        Text(
          'Reports',
          style: AppTextStyles.h2,
        ),
        const Spacer(),
        _buildPeriodDropdown(),
      ],
    );
  }

  Widget _buildPeriodDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical: AppSizes.paddingS,
      ),
      decoration: AppDecorations.input,
      child: DropdownButton<String>(
        value: viewModel.selectedPeriod,
        onChanged: (String? newValue) {
          if (newValue != null) {
            viewModel.changePeriod(newValue);
          }
        },
        underline: const SizedBox(),
        style: AppTextStyles.bodyMedium,
        items: <String>['This Month', 'Last Month', 'This Year']
            .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            })
            .toList(),
      ),
    );
  }
}