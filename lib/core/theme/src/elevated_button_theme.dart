import '../../../imports.dart';

ElevatedButtonThemeData elevatedButtonThemeData(BuildContext context) => ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(0), // No shadow
        minimumSize: WidgetStateProperty.all(Size(double.infinity, 50.sp)), // Full width
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.sp)),
        ), // Rounded corners
        backgroundColor: WidgetStatePropertyAll(context.theme.primaryColor),
        textStyle: WidgetStatePropertyAll(bodyMedium(context).copyWith(color: Colors.white)),
      ),
    );
