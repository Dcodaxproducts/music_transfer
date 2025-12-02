import '../../../imports.dart';
import 'input_decoration_theme.dart';

DropdownMenuThemeData get dropdownMenuThemeLight => DropdownMenuThemeData(
  inputDecorationTheme: inputDecorationThemeLight,
  textStyle: TextStyle(fontSize: 14.sp, color: hintColorLight),
  menuStyle: MenuStyle(
    backgroundColor: WidgetStateProperty.all(cardColorLight),
    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: AppRadius.circular8)),
    surfaceTintColor: WidgetStateProperty.all(dividerColorLight),
  ),
);

DropdownMenuThemeData get dropdownMenuThemeDark => dropdownMenuThemeLight.copyWith(
  inputDecorationTheme: inputDecorationThemeLight,
  textStyle: TextStyle(fontSize: 14.sp, color: hintColorDark),
  menuStyle: MenuStyle(
    backgroundColor: WidgetStateProperty.all(cardColorDark),
    surfaceTintColor: WidgetStateProperty.all(dividerColorDark),
  ),
);
