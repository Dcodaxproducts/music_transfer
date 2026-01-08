import '../../../imports.dart';

BottomSheetThemeData get bottomSheetThemeLight => BottomSheetThemeData(
  shape: RoundedRectangleBorder(borderRadius: AppRadius.top(16)),
  backgroundColor: bottomSheetColorLight,
  modalBackgroundColor: bottomSheetColorLight,
  elevation: 0,
);

BottomSheetThemeData get bottomSheetThemeDark => bottomSheetThemeLight.copyWith(
  backgroundColor: bottomSheetColorDark,
  modalBackgroundColor: bottomSheetColorDark,
);
