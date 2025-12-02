import '../../../imports.dart';

AppBarTheme get appBarThemeLight => AppBarTheme(
  elevation: 0,
  scrolledUnderElevation: 0,
  titleSpacing: 16.sp,
  backgroundColor: backgroundColorLight,
  surfaceTintColor: backgroundColorLight,
  shadowColor: backgroundColorLight,
  titleTextStyle: TextStyle(
    color: textColorLight,
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
  ),
  centerTitle: true,
  iconTheme: const IconThemeData(color: textColorLight),
);

AppBarTheme get appBarThemeDark => appBarThemeLight.copyWith(
  backgroundColor: backgroundColorDark,
  surfaceTintColor: backgroundColorDark,
  shadowColor: backgroundColorDark,
  titleTextStyle: TextStyle(
    color: textColorDark,
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
  ),
  iconTheme: const IconThemeData(color: textColorDark),
);
