import 'package:flutter/material.dart';

class AppListItem extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? contentPadding;
  final bool? selected;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const AppListItem({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.contentPadding,
    this.selected,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? Colors.white,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        child: Container(
          padding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    title,
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      subtitle!,
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 12),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}


class AppListItemLeading extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final double? size;

  const AppListItemLeading({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderRadius,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final itemSize = size ?? 40;
    return Container(
      width: itemSize,
      height: itemSize,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey[100],
        borderRadius: borderRadius ?? BorderRadius.circular(itemSize / 2),
      ),
      child: child,
    );
  }
}

class AppListItemTitle extends StatelessWidget {
  final String text;
  final bool? strikeThrough;
  final Color? color;
  final FontWeight? fontWeight;

  const AppListItemTitle({
    super.key,
    required this.text,
    this.strikeThrough,
    this.color,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color ?? Colors.black87,
        decoration: strikeThrough == true ? TextDecoration.lineThrough : null,
      ),
    );
  }
}

class AppListItemSubtitle extends StatelessWidget {
  final String text;
  final Color? color;

  const AppListItemSubtitle({
    super.key,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color ?? Colors.grey,
        fontSize: 14,
      ),
    );
  }
}