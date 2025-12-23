import '../../../imports.dart';

IconThemeData get iconThemeLight =>
    IconThemeData(color: iconColorLight, size: 22.sp);

IconThemeData get iconThemeDark =>
    iconThemeLight.copyWith(color: iconColorDark);
