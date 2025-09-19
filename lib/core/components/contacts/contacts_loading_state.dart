import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class ContactsLoadingState extends StatelessWidget {
  final String? message;

  const ContactsLoadingState({
    super.key,
    this.message,
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
          if (message != null) ...[
            const SizedBox(height: AppSizes.paddingM),
            Text(
              message!,
              style: AppTextStyles.errorMessage.copyWith(color: AppColors.grey600),
            ),
          ],
        ],
      ),
    );
  }
}