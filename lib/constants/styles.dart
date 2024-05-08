import 'package:atmakitchen_mobile/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:tailwind_colors/tailwind_colors.dart';

class AStyle {
  // Font style
  static TextStyle textStyleSmall = TextStyle(
      fontSize: ASize.fontSizeXs,
      fontWeight: FontWeight.w400,
      color: TW3Colors.slate.shade900);
  static TextStyle textStyleNormal = TextStyle(
      fontSize: ASize.fontSizeSm,
      fontWeight: FontWeight.w400,
      color: TW3Colors.slate.shade900);
  static TextStyle textStyleTitleMd = TextStyle(
      fontSize: ASize.fontSizeMd,
      fontWeight: FontWeight.w600,
      color: TW3Colors.slate.shade900);
  static TextStyle textStyleTitleLg = TextStyle(
      fontSize: ASize.fontSizeLg,
      fontWeight: FontWeight.w600,
      color: TW3Colors.slate.shade900);
  static TextStyle textStyleHeader = TextStyle(
      fontSize: ASize.fontSizeXl,
      fontWeight: FontWeight.bold,
      color: TW3Colors.slate.shade900);
}
