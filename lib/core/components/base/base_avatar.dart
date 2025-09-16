import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

enum AvatarSize { small, medium, large, extraLarge }
enum AvatarType { image, text, icon }

/// A reusable avatar component for displaying user profiles
class BaseAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? text;
  final IconData? icon;
  final AvatarSize size;
  final AvatarType type;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback? onTap;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final Widget? badge;
  final bool showOnlineIndicator;
  final bool isOnline;

  const BaseAvatar({
    super.key,
    this.imageUrl,
    this.text,
    this.icon,
    this.size = AvatarSize.medium,
    this.type = AvatarType.text,
    this.backgroundColor,
    this.foregroundColor,
    this.onTap,
    this.border,
    this.boxShadow,
    this.badge,
    this.showOnlineIndicator = false,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    final avatarSize = _getAvatarSize();
    final fontSize = _getFontSize();
    final iconSize = _getIconSize();
    
    // Determine avatar type if not explicitly set
    AvatarType actualType = type;
    if (type == AvatarType.text && imageUrl != null && imageUrl!.isNotEmpty) {
      actualType = AvatarType.image;
    }

    // Generate initials from text
    String initials = '';
    if (actualType == AvatarType.text && text != null && text!.isNotEmpty) {
      final words = text!.trim().split(' ');
      if (words.length >= 2) {
        initials = '${words[0][0]}${words[1][0]}'.toUpperCase();
      } else {
        initials = text!.substring(0, text!.length >= 2 ? 2 : 1).toUpperCase();
      }
    }

    // Get colors
    final bgColor = backgroundColor ?? 
        (actualType == AvatarType.text && text != null 
            ? AppColors.getAvatarColor(text!) 
            : AppColors.primary100);
    final fgColor = foregroundColor ?? 
        (actualType == AvatarType.text 
            ? AppColors.textInverse 
            : AppColors.primary700);

    // Build avatar content
    Widget avatarContent;
    switch (actualType) {
      case AvatarType.image:
        avatarContent = ClipOval(
          child: Image.network(
            imageUrl!,
            width: avatarSize,
            height: avatarSize,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Fallback to text avatar on image error
              return Container(
                width: avatarSize,
                height: avatarSize,
                color: bgColor,
                alignment: Alignment.center,
                child: Text(
                  initials.isNotEmpty ? initials : '?',
                  style: TextStyle(
                    color: fgColor,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: avatarSize,
                height: avatarSize,
                color: bgColor,
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(fgColor),
                ),
              );
            },
          ),
        );
        break;

      case AvatarType.icon:
        avatarContent = Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: border,
            boxShadow: boxShadow,
          ),
          alignment: Alignment.center,
          child: Icon(
            icon ?? Icons.person,
            size: iconSize,
            color: fgColor,
          ),
        );
        break;

      case AvatarType.text:
      default:
        avatarContent = Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: border,
            boxShadow: boxShadow,
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: TextStyle(
              color: fgColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
        break;
    }

    // Wrap with Stack for badge and online indicator
    Widget avatar = Stack(
      children: [
        avatarContent,
        if (showOnlineIndicator)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: avatarSize * 0.3,
              height: avatarSize * 0.3,
              decoration: BoxDecoration(
                color: isOnline ? AppColors.success : AppColors.textTertiary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.surface,
                  width: 2,
                ),
              ),
            ),
          ),
        if (badge != null)
          Positioned(
            top: 0,
            right: 0,
            child: badge!,
          ),
      ],
    );

    // Add tap handler if provided
    if (onTap != null) {
      avatar = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(avatarSize / 2),
        child: avatar,
      );
    }

    return avatar;
  }

  double _getAvatarSize() {
    switch (size) {
      case AvatarSize.small:
        return AppSpacing.avatarSizeS;
      case AvatarSize.medium:
        return AppSpacing.avatarSizeM;
      case AvatarSize.large:
        return AppSpacing.avatarSizeL;
      case AvatarSize.extraLarge:
        return AppSpacing.avatarSizeXL;
    }
  }

  double _getFontSize() {
    switch (size) {
      case AvatarSize.small:
        return 12;
      case AvatarSize.medium:
        return 16;
      case AvatarSize.large:
        return 20;
      case AvatarSize.extraLarge:
        return 24;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AvatarSize.small:
        return AppSpacing.iconSizeXS;
      case AvatarSize.medium:
        return AppSpacing.iconSizeS;
      case AvatarSize.large:
        return AppSpacing.iconSizeM;
      case AvatarSize.extraLarge:
        return AppSpacing.iconSizeL;
    }
  }

  /// Factory constructor for creating avatar from name
  factory BaseAvatar.fromName({
    Key? key,
    required String name,
    String? imageUrl,
    AvatarSize size = AvatarSize.medium,
    VoidCallback? onTap,
    bool showOnlineIndicator = false,
    bool isOnline = false,
    Widget? badge,
  }) {
    return BaseAvatar(
      key: key,
      text: name,
      imageUrl: imageUrl,
      size: size,
      type: imageUrl != null && imageUrl.isNotEmpty 
          ? AvatarType.image 
          : AvatarType.text,
      onTap: onTap,
      showOnlineIndicator: showOnlineIndicator,
      isOnline: isOnline,
      badge: badge,
    );
  }

  /// Factory constructor for creating avatar group
  static Widget group({
    required List<BaseAvatar> avatars,
    int maxDisplay = 3,
    double overlap = 0.3,
    AvatarSize size = AvatarSize.small,
  }) {
    final displayAvatars = avatars.take(maxDisplay).toList();
    final remaining = avatars.length - maxDisplay;
    final avatarSize = size == AvatarSize.small
        ? AppSpacing.avatarSizeS
        : size == AvatarSize.medium
            ? AppSpacing.avatarSizeM
            : size == AvatarSize.large
                ? AppSpacing.avatarSizeL
                : AppSpacing.avatarSizeXL;

    return SizedBox(
      height: avatarSize,
      child: Stack(
        children: [
          ...displayAvatars.asMap().entries.map((entry) {
            final index = entry.key;
            final avatar = entry.value;
            return Positioned(
              left: index * (avatarSize * (1 - overlap)),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.surface,
                    width: 2,
                  ),
                ),
                child: avatar,
              ),
            );
          }),
          if (remaining > 0)
            Positioned(
              left: displayAvatars.length * (avatarSize * (1 - overlap)),
              child: Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.surface,
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '+$remaining',
                  style: TextStyle(
                    color: AppColors.textInverse,
                    fontSize: size == AvatarSize.small ? 10 : 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}