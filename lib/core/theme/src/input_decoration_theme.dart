import '../../../imports.dart';

InputDecorationTheme get inputDecorationThemeLight => InputDecorationTheme(
  floatingLabelBehavior: FloatingLabelBehavior.never,
  filled: true,
  fillColor: cardColorLight,
  contentPadding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 18.sp),
  // borders
  disabledBorder: border(),
  focusedBorder: border(),
  errorBorder: border(color: errorColor),
  focusedErrorBorder: border(color: errorColor),
  // styles
  errorStyle: TextStyle(fontSize: 12.sp, color: errorColor),
  hintStyle: TextStyle(fontSize: 14.sp, color: hintColorLight),
  labelStyle: TextStyle(fontSize: 14.sp, color: hintColorLight),
);

InputDecorationTheme get inputDecorationThemeDark => inputDecorationThemeLight.copyWith(
  fillColor: cardColorDark,
  hintStyle: TextStyle(fontSize: 14.sp, color: hintColorDark),
  labelStyle: TextStyle(fontSize: 14.sp, color: hintColorDark),
);

InputBorder border({Color? color}) => OutlineInputBorder(
  borderSide: BorderSide(color: color ?? primaryColor, width: 1.sp),
  borderRadius: AppRadius.circular16,
);
