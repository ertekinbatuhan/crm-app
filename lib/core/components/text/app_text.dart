import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;
  final FontStyle? fontStyle;
  final TextDecoration? decoration;

  const AppText(
    this.text, {
    super.key,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.height,
    this.fontStyle,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
        fontStyle: fontStyle,
        decoration: decoration,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }


  factory AppText.heading1(String text, {Color? color}) {
    return AppText(
      text,
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: color ?? Colors.black87,
    );
  }

  factory AppText.heading2(String text, {Color? color}) {
    return AppText(
      text,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: color ?? Colors.black87,
    );
  }

  factory AppText.heading3(String text, {Color? color}) {
    return AppText(
      text,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: color ?? Colors.black87,
    );
  }

  factory AppText.title(String text, {Color? color}) {
    return AppText(
      text,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: color ?? Colors.black87,
    );
  }

  factory AppText.body(String text, {Color? color}) {
    return AppText(
      text,
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: color ?? Colors.black87,
    );
  }

  factory AppText.caption(String text, {Color? color}) {
    return AppText(
      text,
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: color ?? Colors.grey,
    );
  }

  factory AppText.small(String text, {Color? color}) {
    return AppText(
      text,
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: color ?? Colors.grey,
    );
  }
}