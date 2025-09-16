import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// A container widget that provides consistent padding and scrolling behavior for page content
class PageContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool scrollable;
  final ScrollController? scrollController;
  final ScrollPhysics? physics;
  final Axis scrollDirection;
  final Color? backgroundColor;
  final RefreshCallback? onRefresh;
  final bool safeArea;
  final bool fillHeight;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  const PageContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.scrollable = true,
    this.scrollController,
    this.physics,
    this.scrollDirection = Axis.vertical,
    this.backgroundColor,
    this.onRefresh,
    this.safeArea = false,
    this.fillHeight = false,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = child;

    // Apply padding
    if (padding != null) {
      content = Padding(
        padding: padding!,
        child: content,
      );
    }

    // Make scrollable if needed
    if (scrollable) {
      if (fillHeight) {
        content = LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              controller: scrollController,
              physics: physics ?? const AlwaysScrollableScrollPhysics(),
              scrollDirection: scrollDirection,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: crossAxisAlignment,
                    mainAxisAlignment: mainAxisAlignment,
                    children: [
                      if (scrollDirection == Axis.vertical)
                        Expanded(child: content)
                      else
                        content,
                    ],
                  ),
                ),
              ),
            );
          },
        );
      } else {
        content = SingleChildScrollView(
          controller: scrollController,
          physics: physics ?? const AlwaysScrollableScrollPhysics(),
          scrollDirection: scrollDirection,
          child: content,
        );
      }
    } else if (fillHeight && scrollDirection == Axis.vertical) {
      // Fill height without scrolling
      content = Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        children: [Expanded(child: content)],
      );
    }

    // Add pull-to-refresh if callback provided
    if (onRefresh != null) {
      content = RefreshIndicator(
        onRefresh: onRefresh!,
        color: AppColors.primary700,
        backgroundColor: AppColors.surface,
        child: content,
      );
    }

    // Apply container decoration
    if (backgroundColor != null || margin != null) {
      content = Container(
        color: backgroundColor,
        margin: margin,
        child: content,
      );
    }

    // Apply safe area if needed
    if (safeArea) {
      content = SafeArea(child: content);
    }

    return content;
  }

  /// Factory constructor for a standard page container with default padding
  factory PageContainer.standard({
    Key? key,
    required Widget child,
    bool scrollable = true,
    RefreshCallback? onRefresh,
    ScrollController? scrollController,
    Color? backgroundColor,
  }) {
    return PageContainer(
      key: key,
      padding: AppSpacing.screenPadding,
      scrollable: scrollable,
      onRefresh: onRefresh,
      scrollController: scrollController,
      backgroundColor: backgroundColor,
      child: child,
    );
  }

  /// Factory constructor for a form container
  factory PageContainer.form({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    ScrollController? scrollController,
  }) {
    return PageContainer(
      key: key,
      padding: padding ?? AppSpacing.screenPadding,
      scrollable: true,
      fillHeight: true,
      scrollController: scrollController,
      child: child,
    );
  }

  /// Factory constructor for a list container
  factory PageContainer.list({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    RefreshCallback? onRefresh,
    ScrollController? scrollController,
    bool scrollable = false,
  }) {
    return PageContainer(
      key: key,
      padding: padding ?? EdgeInsets.zero,
      scrollable: scrollable,
      onRefresh: onRefresh,
      scrollController: scrollController,
      child: child,
    );
  }

  /// Factory constructor for a grid container
  factory PageContainer.grid({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    RefreshCallback? onRefresh,
    ScrollController? scrollController,
  }) {
    return PageContainer(
      key: key,
      padding: padding ?? AppSpacing.screenPadding,
      scrollable: false, // Grid usually handles its own scrolling
      onRefresh: onRefresh,
      scrollController: scrollController,
      child: child,
    );
  }

  /// Factory constructor for a tab view container
  factory PageContainer.tab({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    bool scrollable = true,
  }) {
    return PageContainer(
      key: key,
      padding: padding ?? EdgeInsets.zero,
      scrollable: scrollable,
      fillHeight: true,
      child: child,
    );
  }

  /// Factory constructor for a centered content container
  factory PageContainer.centered({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    bool scrollable = false,
  }) {
    return PageContainer(
      key: key,
      padding: padding ?? AppSpacing.screenPadding,
      scrollable: scrollable,
      fillHeight: true,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      child: child,
    );
  }
}