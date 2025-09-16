import 'package:flutter/material.dart';

/// Color palette for the CRM application
/// Based on the design system from Stitch
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary Blue Color Palette
  static const Color primary50 = Color(0xFFeef7fe);
  static const Color primary100 = Color(0xFFdbeffd);
  static const Color primary200 = Color(0xFFc1e4fc);
  static const Color primary300 = Color(0xFF98d3fa);
  static const Color primary400 = Color(0xFF68baf7);
  static const Color primary500 = Color(0xFF449ef4);
  static const Color primary600 = Color(0xFF2983e2);
  static const Color primary700 = Color(0xFF197fd2); // Main primary
  static const Color primary800 = Color(0xFF1b6cb0);
  static const Color primary900 = Color(0xFF1c5d90);
  static const Color primary950 = Color(0xFF143c5e);

  // Secondary Teal Color Palette
  static const Color secondary50 = Color(0xFFeffffb);
  static const Color secondary100 = Color(0xFFd7fff5);
  static const Color secondary200 = Color(0xFFb0ffe9);
  static const Color secondary300 = Color(0xFF7afed9);
  static const Color secondary400 = Color(0xFF40fbc9);
  static const Color secondary500 = Color(0xFF16f4b6); // Main secondary
  static const Color secondary600 = Color(0xFF06d39d);
  static const Color secondary700 = Color(0xFF00a87e);
  static const Color secondary800 = Color(0xFF008465);
  static const Color secondary900 = Color(0xFF006b52);
  static const Color secondary950 = Color(0xFF004636);

  // Background Colors
  static const Color backgroundPrimary = Color(0xFFFFFFFF); // White
  static const Color backgroundSecondary = Color(0xFFF8F9FA); // Light Grey
  static const Color backgroundTertiary = Color(0xFFF8FAFB); // Subtle Grey
  static const Color backgroundCard = Color(0xFFF8FAFB); // Card background

  // Text Colors
  static const Color textPrimary = Color(0xFF111827); // Dark Grey
  static const Color textSecondary = Color(0xFF6B7280); // Medium Grey
  static const Color textTertiary = Color(0xFF9CA3AF); // Light Grey
  static const Color textInverse = Color(0xFFFFFFFF); // White

  // Semantic Colors
  static const Color success = Color(0xFF10B981); // Green
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color successDark = Color(0xFF059669);

  static const Color error = Color(0xFFEF4444); // Red
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color errorDark = Color(0xFFDC2626);

  static const Color warning = Color(0xFFF59E0B); // Orange
  static const Color warningLight = Color(0xFFFED7AA);
  static const Color warningDark = Color(0xFFD97706);

  static const Color info = Color(0xFF3B82F6); // Blue
  static const Color infoLight = Color(0xFFDBEAFE);
  static const Color infoDark = Color(0xFF2563EB);

  // Border & Divider Colors
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF3F4F6);
  static const Color borderDark = Color(0xFFD1D5DB);
  static const Color divider = Color(0xFFE5E7EB);

  // Surface Colors
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceHover = Color(0xFFF9FAFB);
  static const Color surfacePressed = Color(0xFFF3F4F6);
  static const Color surfaceDisabled = Color(0xFFF9FAFB);

  // Shadow Color
  static const Color shadow = Color(0x1A000000); // 10% opacity black

  // Chart Colors (for data visualization)
  static const Color chart1 = Color(0xFF3B82F6); // Blue
  static const Color chart2 = Color(0xFF10B981); // Green
  static const Color chart3 = Color(0xFFF59E0B); // Orange
  static const Color chart4 = Color(0xFF8B5CF6); // Purple
  static const Color chart5 = Color(0xFFEC4899); // Pink
  static const Color chart6 = Color(0xFF14B8A6); // Teal

  // Status Colors (for badges and indicators)
  static const Color statusActive = Color(0xFF10B981);
  static const Color statusInactive = Color(0xFF6B7280);
  static const Color statusPending = Color(0xFFF59E0B);
  static const Color statusComplete = Color(0xFF3B82F6);

  // Avatar Background Colors
  static const List<Color> avatarColors = [
    Color(0xFF8B5CF6), // Purple
    Color(0xFFEC4899), // Pink
    Color(0xFF14B8A6), // Teal
    Color(0xFF10B981), // Green
    Color(0xFF3B82F6), // Blue
    Color(0xFFF59E0B), // Orange
  ];

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primary700, primary600],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [secondary600, secondary500],
  );

  // Helper method to get avatar color based on name
  static Color getAvatarColor(String name) {
    final index = name.hashCode % avatarColors.length;
    return avatarColors[index];
  }

  // Helper method to get status color
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'completed':
      case 'won':
        return statusActive;
      case 'inactive':
      case 'lost':
      case 'cancelled':
        return statusInactive;
      case 'pending':
      case 'in_progress':
      case 'negotiation':
        return statusPending;
      default:
        return statusComplete;
    }
  }
}