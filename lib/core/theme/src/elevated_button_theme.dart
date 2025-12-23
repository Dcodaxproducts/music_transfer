import '../../../imports.dart';

ElevatedButtonThemeData get elevatedButtonThemeData => ElevatedButtonThemeData(
  style: ButtonStyle(
    elevation: WidgetStateProperty.all(0),
    minimumSize: WidgetStateProperty.all(Size(240.sp, 48.sp)),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: AppRadius.circular32),
    ),
    backgroundColor: const WidgetStatePropertyAll(primaryColor),
    textStyle: WidgetStatePropertyAll(
      TextStyle(fontSize: 16.sp, color: Colors.white),
    ),
  ),
);
