import '../../../imports.dart';

ElevatedButtonThemeData get elevatedButtonThemeData => ElevatedButtonThemeData(
  style: ButtonStyle(
    elevation: WidgetStateProperty.all(0),
    minimumSize: WidgetStateProperty.all(Size(240.sp, 55.sp)),
    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: AppRadius.circular32)),
    backgroundColor: const WidgetStatePropertyAll(primaryLight),
    textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 16.sp, color: Colors.white)),
    foregroundColor: const WidgetStatePropertyAll(Colors.white),
  ),
);
