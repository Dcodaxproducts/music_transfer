import '../../../imports.dart';

BottomNavigationBarThemeData get bottomNavigationBarThemeLight =>
    const BottomNavigationBarThemeData(
      backgroundColor: backgroundColorLight,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    );

BottomNavigationBarThemeData get bottomNavigationBarThemeDark =>
    const BottomNavigationBarThemeData(
      backgroundColor: backgroundColorDark,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    );
