import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF6949FF);
const Color secondaryColor = Color(0xFFD27579);
const Color backgroundColorDark =
    Colors.black; // Color(0xFF1C1F24); // Color(0xFF19181F);
const Color backgroundColorLight = Color(0xFFFFFFFF);
const Color cardColorDark = Color(0xFF222222);
const Color cardColorLight = Color(0xFFF7F8FA);
const Color textColordark = Color(0XFFDADADA);
const Color shadowColorDark = Color(0xFF0A1220);
const Color shadowColorLight = Color(0xFFE8E8E8);
LinearGradient get primaryGradient => const LinearGradient(
      colors: [secondaryColor, primaryColor],
      stops: [0.2, 1.0],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    );
