import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

enum ActionMenuAction { edit, delete }

class ActionMenu extends StatelessWidget {
  final ValueChanged<ActionMenuAction> onSelected;
  final List<ActionMenuAction> actions;
  final Widget? icon;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  const ActionMenu({
    super.key,
    required this.onSelected,
    this.actions = const [ActionMenuAction.edit, ActionMenuAction.delete],
    this.icon,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ActionMenuAction>(
      onSelected: onSelected,
      icon: icon ?? Icon(Icons.more_vert, color: AppColors.grey600),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
      ),
      color: backgroundColor ?? AppColors.white,
      padding: padding ?? const EdgeInsets.all(AppSizes.paddingS),
      itemBuilder: (context) => actions.map(_buildItem).toList(),
    );
  }

  PopupMenuEntry<ActionMenuAction> _buildItem(ActionMenuAction action) {
    final iconData = action == ActionMenuAction.edit
        ? Icons.edit_outlined
        : Icons.delete_outline;
    final text = action == ActionMenuAction.edit
        ? AppStrings.edit
        : AppStrings.delete;
    final isDanger = action == ActionMenuAction.delete;

    return PopupMenuItem<ActionMenuAction>(
      value: action,
      child: Row(
        children: [
          Icon(
            iconData,
            size: AppSizes.iconL,
            color: isDanger ? AppColors.error : AppColors.grey600,
          ),
          const SizedBox(width: AppSizes.paddingS),
          Text(
            text,
            style: TextStyle(
              color: isDanger ? AppColors.error : AppColors.black,
              fontWeight: isDanger ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
