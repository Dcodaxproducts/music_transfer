import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';

ThemeData light({Color color = primaryColor}) => ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      primaryColor: color,
      secondaryHeaderColor: const Color(0xFF1ED7AA),
      disabledColor: const Color(0xFFBABFC4),
      scaffoldBackgroundColor: backgroundColorLight,
      brightness: null,
      hintColor: const Color(0xFF9F9F9F),
      cardColor: cardColorLight, // 0xFFF6F6F6
      dividerColor: Colors.grey[300]!, //0xFFE8E8E8
      shadowColor: shadowColorLight,
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: color)),
      colorScheme: ColorScheme.fromSeed(seedColor: color, secondary: color)
          .copyWith(
              error: const Color(0xFFdd3135), outline: const Color(0xFFF4F4F4)),
      textTheme: GoogleFonts.poppinsTextTheme(
        TextTheme(
          displayLarge: TextStyle(fontSize: 30.sp),
          displayMedium: TextStyle(fontSize: 24.sp),
          displaySmall: TextStyle(fontSize: 20.sp),
          headlineMedium: TextStyle(fontSize: 18.sp),
          bodyLarge: TextStyle(fontSize: 16.sp),
          bodyMedium: TextStyle(fontSize: 14.sp),
          bodySmall: TextStyle(fontSize: 12.sp),
          titleMedium: TextStyle(fontSize: 10.sp),
          titleSmall: TextStyle(fontSize: 8.sp),
        ),
      ).apply(
        displayColor: Colors.black,
        bodyColor: Colors.black,
      ),

      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 10.sp,
        color: backgroundColorLight,
        surfaceTintColor: backgroundColorLight,
        shadowColor: backgroundColorLight,
        iconTheme: IconThemeData(color: Colors.black, size: 24.sp),
        titleTextStyle:
            GoogleFonts.poppins(fontSize: 22.sp, color: Colors.black),
        centerTitle: false,
      ),
    );
