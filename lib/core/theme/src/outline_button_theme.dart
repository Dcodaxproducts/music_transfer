import '../../../imports.dart';

OutlinedButtonThemeData get outlinedButtonThemeData => OutlinedButtonThemeData(
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(0),
        minimumSize: WidgetStateProperty.all(Size(240.sp, 48.sp)),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: AppRadius.circular8)),
        textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 14.sp, color: primaryColor)),
      ),
    );
