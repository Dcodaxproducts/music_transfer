import '../../../imports.dart';

DialogThemeData get dialogThemeLight => DialogThemeData(
      shape: AppRadius.circular12Shape,
      backgroundColor: backgroundColorLight,
      insetPadding: AppPadding.padding32,
    );

DialogThemeData get dialogThemeDark => dialogThemeLight.copyWith(backgroundColor: backgroundColorDark);
