import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// A reusable input field component with consistent styling
class BaseInput extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final String? initialValue;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? prefix;
  final Widget? suffix;
  final Color? fillColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;

  const BaseInput({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.initialValue,
    this.controller,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onSubmitted,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.prefix,
    this.suffix,
    this.fillColor,
    this.borderRadius,
    this.contentPadding,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
  });

  /// Factory constructor for search input
  factory BaseInput.search({
    Key? key,
    String? hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    VoidCallback? onClear,
    bool autofocus = false,
  }) {
    return BaseInput(
      key: key,
      hint: hint ?? 'Search...',
      controller: controller,
      onChanged: onChanged,
      autofocus: autofocus,
      prefixIcon: Icon(
        Icons.search,
        color: AppColors.textSecondary,
        size: AppSpacing.iconSizeS,
      ),
      suffixIcon: controller?.text.isNotEmpty == true
          ? IconButton(
              icon: Icon(
                Icons.clear,
                color: AppColors.textSecondary,
                size: AppSpacing.iconSizeS,
              ),
              onPressed: () {
                controller?.clear();
                onClear?.call();
              },
            )
          : null,
      borderRadius: AppSpacing.borderRadiusFull,
    );
  }

  /// Factory constructor for password input
  static Widget password({
    Key? key,
    String? label,
    String? hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
    bool autofocus = false,
  }) {
    return _PasswordInput(
      key: key,
      label: label ?? 'Password',
      hint: hint ?? 'Enter your password',
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      autofocus: autofocus,
    );
  }

  /// Factory constructor for multiline input
  factory BaseInput.multiline({
    Key? key,
    String? label,
    String? hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
    int minLines = 3,
    int maxLines = 5,
  }) {
    return BaseInput(
      key: key,
      label: label,
      hint: hint,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      minLines: minLines,
      maxLines: maxLines,
      textInputAction: TextInputAction.newline,
      keyboardType: TextInputType.multiline,
    );
  }

  @override
  State<BaseInput> createState() => _BaseInputState();
}

class _BaseInputState extends State<BaseInput> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _hasError = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
    _errorText = widget.errorText;
  }

  @override
  void didUpdateWidget(BaseInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.errorText != oldWidget.errorText) {
      setState(() {
        _errorText = widget.errorText;
        _hasError = _errorText != null && _errorText!.isNotEmpty;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTypography.inputLabel,
          ),
          AppSpacing.gapV2,
        ],
        TextFormField(
          controller: widget.controller,
          initialValue: widget.controller == null ? widget.initialValue : null,
          focusNode: _focusNode,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          onEditingComplete: widget.onEditingComplete,
          onFieldSubmitted: widget.onSubmitted,
          validator: (value) {
            if (widget.validator != null) {
              final error = widget.validator!(value);
              setState(() {
                _errorText = error;
                _hasError = error != null && error.isNotEmpty;
              });
              return error;
            }
            return null;
          },
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          inputFormatters: widget.inputFormatters,
          obscureText: widget.obscureText,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          textCapitalization: widget.textCapitalization,
          textAlign: widget.textAlign,
          style: AppTypography.inputText,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTypography.inputHint,
            errorText: _errorText,
            errorStyle: AppTypography.inputError,
            errorMaxLines: 2,
            filled: true,
            fillColor: widget.fillColor ?? 
                (_isFocused 
                    ? AppColors.surface 
                    : AppColors.backgroundCard),
            contentPadding: widget.contentPadding ?? AppSpacing.inputPadding,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            prefix: widget.prefix,
            suffix: widget.suffix,
            border: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? AppSpacing.borderRadiusS,
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? AppSpacing.borderRadiusS,
              borderSide: _hasError
                  ? BorderSide(color: AppColors.error, width: 1)
                  : BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? AppSpacing.borderRadiusS,
              borderSide: BorderSide(
                color: _hasError ? AppColors.error : AppColors.primary700,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? AppSpacing.borderRadiusS,
              borderSide: BorderSide(color: AppColors.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? AppSpacing.borderRadiusS,
              borderSide: BorderSide(color: AppColors.error, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? AppSpacing.borderRadiusS,
              borderSide: BorderSide.none,
            ),
          ),
        ),
        if (widget.helperText != null && !_hasError) ...[
          AppSpacing.gapV1,
          Text(
            widget.helperText!,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

/// Private widget for password input with visibility toggle
class _PasswordInput extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool autofocus;

  const _PasswordInput({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.onChanged,
    this.validator,
    this.autofocus = false,
  });

  @override
  State<_PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return BaseInput(
      label: widget.label,
      hint: widget.hint,
      controller: widget.controller,
      onChanged: widget.onChanged,
      validator: widget.validator,
      autofocus: widget.autofocus,
      obscureText: _obscureText,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppColors.textSecondary,
          size: AppSpacing.iconSizeS,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );
  }
}