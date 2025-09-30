import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

enum ViewState {
  loading,
  success,
  empty,
  error,
}

class ViewStateHandler<T> extends StatelessWidget {
  final ViewState state;
  final Widget Function(T data) successBuilder;
  final T? data;
  
  // Loading state properties
  final String? loadingMessage;
  
  // Empty state properties
  final String emptyTitle;
  final String emptySubtitle;
  final IconData emptyIcon;
  final VoidCallback? onEmptyAction;
  final String? emptyActionLabel;
  
  // Error state properties
  final String? errorMessage;
  final VoidCallback? onRetry;
  final IconData errorIcon;
  
  const ViewStateHandler({
    super.key,
    required this.state,
    required this.successBuilder,
    this.data,
    // Loading properties
    this.loadingMessage,
    // Empty properties
    this.emptyTitle = 'No data found',
    this.emptySubtitle = 'Start by adding your first item',
    this.emptyIcon = Icons.inbox_outlined,
    this.onEmptyAction,
    this.emptyActionLabel,
    // Error properties
    this.errorMessage,
    this.onRetry,
    this.errorIcon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case ViewState.loading:
        return _buildLoadingState();
      case ViewState.success:
        return data != null ? successBuilder(data!) : _buildEmptyState();
      case ViewState.empty:
        return _buildEmptyState();
      case ViewState.error:
        return _buildErrorState();
    }
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          if (loadingMessage != null) ...[
            const SizedBox(height: AppSizes.paddingM),
            Text(
              loadingMessage!,
              style: AppTextStyles.errorMessage.copyWith(color: AppColors.grey600),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(emptyIcon, size: AppSizes.iconXL, color: AppColors.grey),
          const SizedBox(height: AppSizes.paddingM),
          Text(
            emptyTitle,
            style: AppTextStyles.emptyStateTitle.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: AppSizes.paddingS),
          Text(
            emptySubtitle,
            style: AppTextStyles.emptyStateSubtitle.copyWith(color: AppColors.grey600),
            textAlign: TextAlign.center,
          ),
          if (onEmptyAction != null && emptyActionLabel != null) ...[
            const SizedBox(height: AppSizes.paddingL),
            ElevatedButton.icon(
              onPressed: onEmptyAction,
              icon: const Icon(Icons.add),
              label: Text(emptyActionLabel!),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(errorIcon, size: AppSizes.iconXL, color: AppColors.error),
          const SizedBox(height: AppSizes.paddingM),
          Text(
            AppStrings.somethingWentWrong,
            style: AppTextStyles.errorTitle,
          ),
          const SizedBox(height: AppSizes.paddingS),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingXL),
            child: Text(
              errorMessage ?? AppStrings.somethingWentWrong,
              style: AppTextStyles.errorMessage.copyWith(color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppSizes.paddingL),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text(AppStrings.tryAgain),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Convenience widgets for common use cases
class ListViewStateHandler<T> extends StatelessWidget {
  final ViewState state;
  final List<T>? items;
  final Widget Function(List<T> items) listBuilder;
  
  // Loading state properties
  final String? loadingMessage;
  
  // Empty state properties
  final String emptyTitle;
  final String emptySubtitle;
  final IconData emptyIcon;
  final VoidCallback? onEmptyAction;
  final String? emptyActionLabel;
  
  // Error state properties
  final String? errorMessage;
  final VoidCallback? onRetry;
  final IconData errorIcon;

  const ListViewStateHandler({
    super.key,
    required this.state,
    required this.listBuilder,
    this.items,
    // Loading properties
    this.loadingMessage,
    // Empty properties
    this.emptyTitle = 'No items found',
    this.emptySubtitle = 'Start by adding your first item',
    this.emptyIcon = Icons.inbox_outlined,
    this.onEmptyAction,
    this.emptyActionLabel,
    // Error properties
    this.errorMessage,
    this.onRetry,
    this.errorIcon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    return ViewStateHandler<List<T>>(
      state: _getActualState(),
      data: items,
      successBuilder: listBuilder,
      loadingMessage: loadingMessage,
      emptyTitle: emptyTitle,
      emptySubtitle: emptySubtitle,
      emptyIcon: emptyIcon,
      onEmptyAction: onEmptyAction,
      emptyActionLabel: emptyActionLabel,
      errorMessage: errorMessage,
      onRetry: onRetry,
      errorIcon: errorIcon,
    );
  }

  ViewState _getActualState() {
    if (state == ViewState.success && (items == null || items!.isEmpty)) {
      return ViewState.empty;
    }
    return state;
  }
}