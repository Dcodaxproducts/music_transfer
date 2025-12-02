import '../../../imports.dart';

DividerThemeData get dividerThemeLight =>
    const DividerThemeData(thickness: 0.5, color: dividerColorLight, space: 0);

DividerThemeData get dividerThemeDark => dividerThemeLight.copyWith(color: dividerColorDark);
