import '../../../imports.dart';

InputDecorationTheme get inputDecorationThemeLight => InputDecorationTheme(
  floatingLabelBehavior: FloatingLabelBehavior.never,
  filled: false,
  contentPadding: AppPadding.padding16,
  // borders
  disabledBorder: border(),
  focusedBorder: border(),
  errorBorder: border(color: Colors.red),
  focusedErrorBorder: border(color: Colors.red),
  // styles
  errorStyle: TextStyle(fontSize: 12.sp, color: Colors.red),
  hintStyle: TextStyle(fontSize: 14.sp, color: hintColorLight),
  labelStyle: TextStyle(fontSize: 14.sp, color: hintColorLight),
);

InputDecorationTheme get inputDecorationThemeDark => inputDecorationThemeLight.copyWith(
  hintStyle: TextStyle(fontSize: 14.sp, color: hintColorDark),
  labelStyle: TextStyle(fontSize: 14.sp, color: hintColorDark),
);

InputBorder border({Color? color}) => OutlineInputBorder(
  borderSide: BorderSide(color: color ?? primaryColor, width: 1.sp),
  borderRadius: AppRadius.circular16,
);
