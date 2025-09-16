import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? titleColor;
  final double? elevation;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;

  const AppHeader({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.titleColor,
    this.elevation,
    this.automaticallyImplyLeading = true,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
          backgroundColor ?? Theme.of(context).appBarTheme.backgroundColor,
      elevation: elevation ?? 0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      title: Text(
        title,
        style: TextStyle(
          color:
              titleColor ?? Theme.of(context).appBarTheme.titleTextStyle?.color,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: actions,
      bottom: bottom,
      iconTheme: IconThemeData(
        color: titleColor ?? Theme.of(context).appBarTheme.iconTheme?.color,
      ),
    );
  }

  @override
  Size get preferredSize {
    double height = kToolbarHeight;
    if (bottom != null) {
      height += bottom!.preferredSize.height;
    }
    return Size.fromHeight(height);
  }

  // Factory constructors for common patterns
  factory AppHeader.withSettings({
    required String title,
    VoidCallback? onSettingsPressed,
    Color? backgroundColor,
    Color? titleColor,
  }) {
    return AppHeader(
      title: title,
      backgroundColor: backgroundColor,
      titleColor: titleColor,
      actions: [
        IconButton(
          icon: Icon(
            Icons.settings,
            color: titleColor ?? Colors.black,
            size: 24,
          ),
          onPressed:
              onSettingsPressed ??
              () {
                if (kDebugMode) {
                  print('Settings pressed');
                }
              },
        ),
      ],
    );
  }
}
