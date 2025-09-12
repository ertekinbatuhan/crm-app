import 'package:flutter/material.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? child;
  final VoidCallback? onTap;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.size = 40,
    this.backgroundColor,
    this.textColor,
    this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget avatarChild;

    if (child != null) {
      avatarChild = child!;
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      avatarChild = ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: Image.network(
          imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildInitialsAvatar();
          },
        ),
      );
    } else {
      avatarChild = _buildInitialsAvatar();
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatarChild,
      );
    }

    return avatarChild;
  }

  Widget _buildInitialsAvatar() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials ?? '?',
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: size * 0.4,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // Factory constructors for common avatar types
  factory AppAvatar.small({
    String? imageUrl,
    String? initials,
    VoidCallback? onTap,
  }) {
    return AppAvatar(
      imageUrl: imageUrl,
      initials: initials,
      size: 24,
      onTap: onTap,
    );
  }

  factory AppAvatar.medium({
    String? imageUrl,
    String? initials,
    VoidCallback? onTap,
  }) {
    return AppAvatar(
      imageUrl: imageUrl,
      initials: initials,
      size: 40,
      onTap: onTap,
    );
  }

  factory AppAvatar.large({
    String? imageUrl,
    String? initials,
    VoidCallback? onTap,
  }) {
    return AppAvatar(
      imageUrl: imageUrl,
      initials: initials,
      size: 64,
      onTap: onTap,
    );
  }

  factory AppAvatar.withIcon({
    required Widget icon,
    double size = 40,
    Color? backgroundColor,
    VoidCallback? onTap,
  }) {
    return AppAvatar(
      size: size,
      backgroundColor: backgroundColor,
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.grey[300],
          shape: BoxShape.circle,
        ),
        child: icon,
      ),
    );
  }
}