import '../../../imports.dart';

OutlinedButtonThemeData get outlinedButtonThemeData => OutlinedButtonThemeData(
  style: ButtonStyle(
    elevation: WidgetStateProperty.all(0),
    minimumSize: WidgetStateProperty.all(Size(240.sp, 55.sp)),
    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: AppRadius.circular32)),
    textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 14.sp, color: primaryColor)),
  ),
);
