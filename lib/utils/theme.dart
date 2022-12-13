import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/services/theme_services.dart';

const Color bluishClr = Color(0xFF4e5ae8);
const Color orangeClr = Color(0xCFFF8746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);

class Themes {
  static final ThemeData lightTheme = ThemeData(
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: darkGreyClr)),
      primaryColor: primaryClr,
      backgroundColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      brightness: Brightness.light);

  static final ThemeData darkTheme = ThemeData(
    appBarTheme: const AppBarTheme(
        backgroundColor: darkGreyClr,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white)),
    primaryColor: primaryClr,
    backgroundColor: darkGreyClr,
    scaffoldBackgroundColor: darkGreyClr,
    brightness: Brightness.dark,
  );
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
      // ignore: prefer_const_constructors
      textStyle: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    // color: ThemeServices().loadThemeFromBox() ? Colors.white : Colors.grey,
  ));
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      // color: Get.isDarkMode ? Colors.white : darkGreyClr,
    ),
  );
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? Colors.white : darkGreyClr));
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Get.isDarkMode ? Colors.white : darkGreyClr));
}

TextStyle get bodyStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Get.isDarkMode ? Colors.white : darkGreyClr));
}

TextStyle get body2Style {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: Get.isDarkMode ? Colors.grey[200] : darkGreyClr));
}
