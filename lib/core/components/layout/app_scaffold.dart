import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// A custom scaffold wrapper that provides consistent structure across all screens
class AppScaffold extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final bool showBackButton;
  final Color? backgroundColor;
  final Color? appBarBackgroundColor;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final bool extendBodyBehindAppBar;
  final bool resizeToAvoidBottomInset;
  final VoidCallback? onBackPressed;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool safeArea;
  final EdgeInsetsGeometry? bodyPadding;

  const AppScaffold({
    super.key,
    this.title,
    this.titleWidget,
    required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.showBackButton = true,
    this.backgroundColor,
    this.appBarBackgroundColor,
    this.bottom,
    this.elevation,
    this.extendBodyBehindAppBar = false,
    this.resizeToAvoidBottomInset = true,
    this.onBackPressed,
    this.systemOverlayStyle,
    this.safeArea = true,
    this.bodyPadding,
  }) : assert(title != null || titleWidget != null || (title == null && titleWidget == null),
            'Cannot provide both title and titleWidget');

  @override
  Widget build(BuildContext context) {
    final hasAppBar = title != null || titleWidget != null || actions != null || leading != null;
    final canPop = Navigator.of(context).canPop();

    Widget bodyContent = body;

    // Apply padding if specified
    if (bodyPadding != null) {
      bodyContent = Padding(
        padding: bodyPadding!,
        child: bodyContent,
      );
    }

    // Apply safe area if specified
    if (safeArea && !hasAppBar) {
      bodyContent = SafeArea(child: bodyContent);
    }

    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.backgroundSecondary,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: hasAppBar
          ? AppBar(
              title: titleWidget ??
                  (title != null
                      ? Text(
                          title!,
                          style: AppTypography.titleLarge,
                        )
                      : null),
              centerTitle: centerTitle,
              backgroundColor: appBarBackgroundColor ?? AppColors.backgroundPrimary,
              elevation: elevation ?? 0,
              scrolledUnderElevation: elevation ?? 1,
              systemOverlayStyle: systemOverlayStyle ?? SystemUiOverlayStyle.dark,
              leading: leading ??
                  (showBackButton && canPop
                      ? IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                        )
                      : null),
              automaticallyImplyLeading: showBackButton,
              actions: actions,
              bottom: bottom,
            )
          : null,
      body: bodyContent,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
    );
  }

  /// Factory constructor for a simple page with just a title and body
  factory AppScaffold.simple({
    Key? key,
    required String title,
    required Widget body,
    List<Widget>? actions,
    Widget? floatingActionButton,
    EdgeInsetsGeometry? bodyPadding,
  }) {
    return AppScaffold(
      key: key,
      title: title,
      body: body,
      actions: actions,
      floatingActionButton: floatingActionButton,
      bodyPadding: bodyPadding ?? AppSpacing.screenPadding,
    );
  }

  /// Factory constructor for a tabbed page
  factory AppScaffold.tabbed({
    Key? key,
    required String title,
    required List<Tab> tabs,
    required List<Widget> tabViews,
    List<Widget>? actions,
    Widget? floatingActionButton,
    TabController? controller,
    ValueChanged<int>? onTabChanged,
  }) {
    return AppScaffold(
      key: key,
      title: title,
      bottom: TabBar(
        controller: controller,
        tabs: tabs,
        onTap: onTabChanged,
        labelColor: AppColors.primary700,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary700,
        indicatorWeight: 3,
        labelStyle: AppTypography.labelMedium,
        unselectedLabelStyle: AppTypography.labelMedium,
      ),
      body: TabBarView(
        controller: controller,
        children: tabViews,
      ),
      actions: actions,
      floatingActionButton: floatingActionButton,
    );
  }

  /// Factory constructor for a page with search functionality
  factory AppScaffold.withSearch({
    Key? key,
    required String title,
    required Widget body,
    required ValueChanged<String> onSearch,
    String? searchHint,
    List<Widget>? actions,
    Widget? floatingActionButton,
    TextEditingController? searchController,
    bool autoFocus = false,
  }) {
    return AppScaffold(
      key: key,
      titleWidget: TextField(
        controller: searchController,
        onChanged: onSearch,
        autofocus: autoFocus,
        style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: searchHint ?? 'Search...',
          hintStyle: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.textSecondary,
            size: AppSpacing.iconSizeM,
          ),
        ),
      ),
      body: body,
      actions: [
        if (searchController != null && searchController.text.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              searchController.clear();
              onSearch('');
            },
          ),
        ...?actions,
      ],
      floatingActionButton: floatingActionButton,
    );
  }

  /// Factory constructor for a loading page
  factory AppScaffold.loading({
    Key? key,
    String? title,
    String? message,
  }) {
    return AppScaffold(
      key: key,
      title: title,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            if (message != null) ...[
              AppSpacing.gapV4,
              Text(
                message,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Factory constructor for an error page
  factory AppScaffold.error({
    Key? key,
    String? title,
    required String message,
    VoidCallback? onRetry,
    Widget? icon,
  }) {
    return AppScaffold(
      key: key,
      title: title,
      body: Center(
        child: Padding(
          padding: AppSpacing.paddingXL,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon ??
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
              AppSpacing.gapV4,
              Text(
                'Oops! Something went wrong',
                style: AppTypography.headlineSmall,
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapV2,
              Text(
                message,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                AppSpacing.gapV6,
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}