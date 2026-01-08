import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A utility class to standardize border radius throughout the app
class AppRadius {
  // BorderRadius objects (all corners equal)
  static BorderRadius get circular8 => BorderRadius.circular(8.r);
  static BorderRadius get circular4 => BorderRadius.circular(4.r);
  static BorderRadius get circular12 => BorderRadius.circular(12.r);
  static BorderRadius get circular16 => BorderRadius.circular(16.r);
  static BorderRadius get circular24 => BorderRadius.circular(24.r);
  static BorderRadius get circular32 => BorderRadius.circular(32.r);
  static BorderRadius circular(double value) => BorderRadius.circular(value);

  // shape
  static ShapeBorder get circular8Shape => RoundedRectangleBorder(borderRadius: circular8);
  static ShapeBorder get circular12Shape => RoundedRectangleBorder(borderRadius: circular12);
  static ShapeBorder get circular16Shape => RoundedRectangleBorder(borderRadius: circular16);

  // Specific corners
  static BorderRadius topLeft(double radius) => BorderRadius.only(topLeft: Radius.circular(radius.r));
  static BorderRadius topRight(double radius) => BorderRadius.only(topRight: Radius.circular(radius.r));
  static BorderRadius bottomLeft(double radius) => BorderRadius.only(bottomLeft: Radius.circular(radius.r));
  static BorderRadius bottomRight(double radius) => BorderRadius.only(bottomRight: Radius.circular(radius.r));

  // Common combinations
  static BorderRadius top(double radius) =>
      BorderRadius.only(topLeft: Radius.circular(radius), topRight: Radius.circular(radius));

  static BorderRadius bottom(double radius) =>
      BorderRadius.only(bottomLeft: Radius.circular(radius), bottomRight: Radius.circular(radius));
}
