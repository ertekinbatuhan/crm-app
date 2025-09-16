import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

/// Main theme configuration for the CRM application
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary700,
        primaryContainer: AppColors.primary100,
        secondary: AppColors.secondary500,
        secondaryContainer: AppColors.secondary100,
        surface: AppColors.surface,
        background: AppColors.backgroundSecondary,
        error: AppColors.error,
        errorContainer: AppColors.errorLight,
        onPrimary: AppColors.textInverse,
        onSecondary: AppColors.textInverse,
        onSurface: AppColors.textPrimary,
        onBackground: AppColors.textPrimary,
        onError: AppColors.textInverse,
        outline: AppColors.border,
        surfaceVariant: AppColors.backgroundCard,
      ),

      // Typography
      textTheme: const TextTheme(
        displayLarge: AppTypography.displayLarge,
        displayMedium: AppTypography.displayMedium,
        displaySmall: AppTypography.displaySmall,
        headlineLarge: AppTypography.headlineLarge,
        headlineMedium: AppTypography.headlineMedium,
        headlineSmall: AppTypography.headlineSmall,
        titleLarge: AppTypography.titleLarge,
        titleMedium: AppTypography.titleMedium,
        titleSmall: AppTypography.titleSmall,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.labelLarge,
        labelMedium: AppTypography.labelMedium,
        labelSmall: AppTypography.labelSmall,
      ),

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.backgroundPrimary,
        foregroundColor: AppColors.textPrimary,
        iconTheme: IconThemeData(
          color: AppColors.textPrimary,
          size: AppSpacing.iconSizeM,
        ),
        titleTextStyle: AppTypography.titleLarge,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.backgroundPrimary,
        selectedItemColor: AppColors.primary700,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: AppTypography.navLabel,
        unselectedLabelStyle: AppTypography.navLabel,
        type: BottomNavigationBarType.fixed,
        elevation: AppSpacing.elevation8,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      // Navigation Bar Theme (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.backgroundPrimary,
        indicatorColor: AppColors.primary100,
        surfaceTintColor: Colors.transparent,
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppTypography.navLabel.copyWith(color: AppColors.primary700);
          }
          return AppTypography.navLabel.copyWith(color: AppColors.textSecondary);
        }),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(color: AppColors.primary700);
          }
          return const IconThemeData(color: AppColors.textSecondary);
        }),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary700,
          foregroundColor: AppColors.textInverse,
          disabledBackgroundColor: AppColors.surfaceDisabled,
          disabledForegroundColor: AppColors.textTertiary,
          elevation: AppSpacing.elevation2,
          padding: AppSpacing.buttonPadding,
          minimumSize: const Size(64, AppSpacing.buttonHeightM),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusS,
          ),
          textStyle: AppTypography.buttonText,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary700,
          disabledForegroundColor: AppColors.textTertiary,
          padding: AppSpacing.buttonPadding,
          minimumSize: const Size(64, AppSpacing.buttonHeightM),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusS,
          ),
          textStyle: AppTypography.buttonText,
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary700,
          disabledForegroundColor: AppColors.textTertiary,
          side: const BorderSide(color: AppColors.border),
          padding: AppSpacing.buttonPadding,
          minimumSize: const Size(64, AppSpacing.buttonHeightM),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusS,
          ),
          textStyle: AppTypography.buttonText,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary700,
        foregroundColor: AppColors.textInverse,
        elevation: AppSpacing.elevation6,
        shape: CircleBorder(),
        sizeConstraints: BoxConstraints.tightFor(
          width: AppSpacing.fabSize,
          height: AppSpacing.fabSize,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: AppSpacing.elevation2,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusM,
        ),
        margin: EdgeInsets.zero,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.backgroundCard,
        deleteIconColor: AppColors.textSecondary,
        disabledColor: AppColors.surfaceDisabled,
        selectedColor: AppColors.primary100,
        labelStyle: AppTypography.labelMedium,
        padding: AppSpacing.paddingHorizontalS,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusFull,
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        elevation: AppSpacing.elevation24,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusL,
        ),
        titleTextStyle: AppTypography.headlineSmall,
        contentTextStyle: AppTypography.bodyMedium,
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        elevation: AppSpacing.elevation16,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusTop,
        ),
        dragHandleColor: AppColors.border,
        dragHandleSize: Size(40, 4),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundCard,
        contentPadding: AppSpacing.inputPadding,
        hintStyle: AppTypography.inputHint,
        labelStyle: AppTypography.inputLabel,
        errorStyle: AppTypography.inputError,
        border: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusS,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusS,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusS,
          borderSide: const BorderSide(
            color: AppColors.primary700,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusS,
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusS,
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: AppSpacing.iconSizeM,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 0,
      ),

      // List Tile Theme
      listTileTheme: const ListTileThemeData(
        contentPadding: AppSpacing.listItemPadding,
        dense: false,
        horizontalTitleGap: AppSpacing.sp3,
        minVerticalPadding: AppSpacing.sp2,
      ),

      // Scaffold Background Color
      scaffoldBackgroundColor: AppColors.backgroundSecondary,

      // Extensions
      extensions: const [
        AppThemeExtension(
          cardPadding: AppSpacing.cardPadding,
          sectionPadding: AppSpacing.sectionPadding,
          screenPadding: AppSpacing.screenPadding,
        ),
      ],
    );
  }

  /// Dark theme configuration (optional for future)
  static ThemeData get darkTheme {
    // TODO: Implement dark theme
    return lightTheme;
  }
}

/// Custom theme extension for additional properties
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final EdgeInsets cardPadding;
  final EdgeInsets sectionPadding;
  final EdgeInsets screenPadding;

  const AppThemeExtension({
    required this.cardPadding,
    required this.sectionPadding,
    required this.screenPadding,
  });

  @override
  AppThemeExtension copyWith({
    EdgeInsets? cardPadding,
    EdgeInsets? sectionPadding,
    EdgeInsets? screenPadding,
  }) {
    return AppThemeExtension(
      cardPadding: cardPadding ?? this.cardPadding,
      sectionPadding: sectionPadding ?? this.sectionPadding,
      screenPadding: screenPadding ?? this.screenPadding,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) {
      return this;
    }
    return AppThemeExtension(
      cardPadding: EdgeInsets.lerp(cardPadding, other.cardPadding, t)!,
      sectionPadding: EdgeInsets.lerp(sectionPadding, other.sectionPadding, t)!,
      screenPadding: EdgeInsets.lerp(screenPadding, other.screenPadding, t)!,
    );
  }
}