import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class DealsLoadingState extends StatelessWidget {
  final String message;
  
  const DealsLoadingState({
    super.key,
    this.message = 'Loading deals...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          const SizedBox(height: AppSizes.paddingM),
          Text(
            message,
            style: AppTextStyles.emptyStateSubtitle,
          ),
        ],
      ),
    );
  }
}