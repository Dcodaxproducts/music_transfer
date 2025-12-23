// Primary and Secondary Colors

import '../../imports.dart';

// Primary and Secondary Colors
const Color primaryColor = Color(0xFF6949FF);
const Color primaryLight = Color(0xFF7A6BF6);
const Color secondaryColor = Color(0xFFD27579);
const Color errorColor = Color(0xFFE75B5C);

// Background Colors
const Color backgroundColorDark = Colors.black;
const Color backgroundColorLight = Color(0xFFFFFFFF);

// Card Colors
const Color cardColorDark = Color(0xFF1E1E1E);
const Color cardColorLight = Color(0xFFF7F8FA);

// bottom sheet
const Color bottomSheetColorDark = Color(0xFF1A1A1A);
const Color bottomSheetColorLight = Colors.white;

// canvas color
const Color canvasColorDark = Color(0xFF353535);
const Color canvasColorLight = Color(0xFFEFEFEF);

// Text Colors
const Color textColorDark = Color(0XFFDADADA);
const Color textColorLight = Colors.black;

// Shadow Colors
const Color shadowColorDark = Color(0xFF0A1220);
const Color shadowColorLight = Color(0xFFE8E8E8);

// Divider Colors
const Color dividerColorLight = Color(0xFFD0D5DD);
const Color dividerColorDark = Color(0xFF3F3F3F);

// Disabled Colors
const Color disabledColorLight = Color(0xffA0A0A0);
const Color disabledColorDark = Color(0xFFB0B0B0);

// Hint Colors
const Color hintColorLight = Color(0xff606060);
const Color hintColorDark = Color(0xFF909090);

// Icon Colors
const Color iconColorLight = Color(0xff606060);
const Color iconColorDark = Color(0xFF909090);

// Gradients
LinearGradient get primaryGradient => const LinearGradient(
  colors: [secondaryColor, primaryColor],
  stops: [0.2, 1.0],
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
);

LinearGradient get secondaryGradient => const LinearGradient(
  colors: [primaryLight, primaryColor],
  stops: [0.2, 1.0],
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
);
