import 'package:flutter/material.dart';

/// Spacing constants for consistent layout throughout the app
/// Based on 4px grid system from the designs
class AppSpacing {
  // Private constructor to prevent instantiation
  AppSpacing._();

  // Base unit
  static const double unit = 4.0;

  // Spacing values (4px grid)
  static const double sp0 = 0;
  static const double sp1 = 4.0;   // 1 * unit
  static const double sp2 = 8.0;   // 2 * unit
  static const double sp3 = 12.0;  // 3 * unit
  static const double sp4 = 16.0;  // 4 * unit
  static const double sp5 = 20.0;  // 5 * unit
  static const double sp6 = 24.0;  // 6 * unit
  static const double sp8 = 32.0;  // 8 * unit
  static const double sp10 = 40.0; // 10 * unit
  static const double sp12 = 48.0; // 12 * unit
  static const double sp14 = 56.0; // 14 * unit
  static const double sp16 = 64.0; // 16 * unit
  static const double sp18 = 72.0; // 18 * unit
  static const double sp20 = 80.0; // 20 * unit
  static const double sp24 = 96.0; // 24 * unit

  // Padding values for different components
  static const EdgeInsets paddingNone = EdgeInsets.zero;
  
  // Symmetric padding
  static const EdgeInsets paddingXS = EdgeInsets.all(sp1);
  static const EdgeInsets paddingS = EdgeInsets.all(sp2);
  static const EdgeInsets paddingM = EdgeInsets.all(sp4);
  static const EdgeInsets paddingL = EdgeInsets.all(sp6);
  static const EdgeInsets paddingXL = EdgeInsets.all(sp8);
  static const EdgeInsets paddingXXL = EdgeInsets.all(sp12);

  // Horizontal padding
  static const EdgeInsets paddingHorizontalXS = EdgeInsets.symmetric(horizontal: sp1);
  static const EdgeInsets paddingHorizontalS = EdgeInsets.symmetric(horizontal: sp2);
  static const EdgeInsets paddingHorizontalM = EdgeInsets.symmetric(horizontal: sp4);
  static const EdgeInsets paddingHorizontalL = EdgeInsets.symmetric(horizontal: sp6);
  static const EdgeInsets paddingHorizontalXL = EdgeInsets.symmetric(horizontal: sp8);

  // Vertical padding
  static const EdgeInsets paddingVerticalXS = EdgeInsets.symmetric(vertical: sp1);
  static const EdgeInsets paddingVerticalS = EdgeInsets.symmetric(vertical: sp2);
  static const EdgeInsets paddingVerticalM = EdgeInsets.symmetric(vertical: sp4);
  static const EdgeInsets paddingVerticalL = EdgeInsets.symmetric(vertical: sp6);
  static const EdgeInsets paddingVerticalXL = EdgeInsets.symmetric(vertical: sp8);

  // Component-specific padding
  static const EdgeInsets cardPadding = EdgeInsets.all(sp4);
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: sp4, vertical: sp3);
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(horizontal: sp4, vertical: sp3);
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(horizontal: sp4, vertical: sp3);
  static const EdgeInsets sectionPadding = EdgeInsets.all(sp4);
  static const EdgeInsets screenPadding = EdgeInsets.all(sp4);
  static const EdgeInsets modalPadding = EdgeInsets.all(sp5);

  // Gaps for Row/Column widgets
  static const Widget gapH1 = SizedBox(width: sp1);
  static const Widget gapH2 = SizedBox(width: sp2);
  static const Widget gapH3 = SizedBox(width: sp3);
  static const Widget gapH4 = SizedBox(width: sp4);
  static const Widget gapH5 = SizedBox(width: sp5);
  static const Widget gapH6 = SizedBox(width: sp6);
  static const Widget gapH8 = SizedBox(width: sp8);
  static const Widget gapH10 = SizedBox(width: sp10);
  static const Widget gapH12 = SizedBox(width: sp12);
  static const Widget gapH16 = SizedBox(width: sp16);
  static const Widget gapH20 = SizedBox(width: sp20);
  static const Widget gapH24 = SizedBox(width: sp24);

  static const Widget gapV1 = SizedBox(height: sp1);
  static const Widget gapV2 = SizedBox(height: sp2);
  static const Widget gapV3 = SizedBox(height: sp3);
  static const Widget gapV4 = SizedBox(height: sp4);
  static const Widget gapV5 = SizedBox(height: sp5);
  static const Widget gapV6 = SizedBox(height: sp6);
  static const Widget gapV8 = SizedBox(height: sp8);
  static const Widget gapV10 = SizedBox(height: sp10);
  static const Widget gapV12 = SizedBox(height: sp12);
  static const Widget gapV16 = SizedBox(height: sp16);
  static const Widget gapV20 = SizedBox(height: sp20);
  static const Widget gapV24 = SizedBox(height: sp24);

  // Border radius values
  static const double radiusNone = 0;
  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 24.0;
  static const double radiusFull = 9999.0;

  // Border radius objects
  static const BorderRadius borderRadiusNone = BorderRadius.zero;
  static const BorderRadius borderRadiusXS = BorderRadius.all(Radius.circular(radiusXS));
  static const BorderRadius borderRadiusS = BorderRadius.all(Radius.circular(radiusS));
  static const BorderRadius borderRadiusM = BorderRadius.all(Radius.circular(radiusM));
  static const BorderRadius borderRadiusL = BorderRadius.all(Radius.circular(radiusL));
  static const BorderRadius borderRadiusXL = BorderRadius.all(Radius.circular(radiusXL));
  static const BorderRadius borderRadiusXXL = BorderRadius.all(Radius.circular(radiusXXL));
  static const BorderRadius borderRadiusFull = BorderRadius.all(Radius.circular(radiusFull));

  // Top-only border radius (for bottom sheets, etc.)
  static const BorderRadius borderRadiusTop = BorderRadius.only(
    topLeft: Radius.circular(radiusL),
    topRight: Radius.circular(radiusL),
  );

  // Icon sizes
  static const double iconSizeXS = 16.0;
  static const double iconSizeS = 20.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 40.0;
  static const double iconSizeXXL = 48.0;

  // Component heights
  static const double buttonHeightS = 32.0;
  static const double buttonHeightM = 40.0;
  static const double buttonHeightL = 48.0;
  static const double buttonHeightXL = 56.0;

  static const double inputHeightS = 36.0;
  static const double inputHeightM = 44.0;
  static const double inputHeightL = 52.0;

  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 64.0;
  static const double fabSize = 56.0;
  static const double avatarSizeS = 32.0;
  static const double avatarSizeM = 40.0;
  static const double avatarSizeL = 48.0;
  static const double avatarSizeXL = 64.0;

  // Elevation values
  static const double elevation0 = 0;
  static const double elevation1 = 1.0;
  static const double elevation2 = 2.0;
  static const double elevation3 = 3.0;
  static const double elevation4 = 4.0;
  static const double elevation6 = 6.0;
  static const double elevation8 = 8.0;
  static const double elevation12 = 12.0;
  static const double elevation16 = 16.0;
  static const double elevation24 = 24.0;

  // Helper methods
  static Widget gap({double? width, double? height}) {
    return SizedBox(width: width, height: height);
  }

  static EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) {
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }

  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);
  }
}