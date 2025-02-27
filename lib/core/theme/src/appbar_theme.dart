import '../../../imports.dart';

AppBarTheme appBarThemeLight(BuildContext context) => AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: spacingDefault,
      color: backgroundColorLight,
      surfaceTintColor: backgroundColorLight,
      shadowColor: backgroundColorLight,
      titleTextStyle: titleLarge(context).copyWith(color: textColorLight),
      centerTitle: false,
      iconTheme: const IconThemeData(color: textColorLight),
    );

AppBarTheme appBarThemeDark(BuildContext context) => appBarThemeLight(context).copyWith(
      color: backgroundColorDark,
      surfaceTintColor: backgroundColorDark,
      shadowColor: backgroundColorDark,
      titleTextStyle: titleLarge(context).copyWith(color: textColorDark),
      iconTheme: const IconThemeData(color: textColorDark),
    );
