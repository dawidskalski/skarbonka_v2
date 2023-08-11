import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle getMyHeadingStyle() {
  return GoogleFonts.lato(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Get.isDarkMode ? Colors.grey[400] : Colors.grey,
  );
}

TextStyle getMySubheaderStyle() {
  return GoogleFonts.lato(
    fontSize: 27,
    fontWeight: FontWeight.bold,
  );
}

TextStyle getReminderButtonStyle() {
  return GoogleFonts.lato(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}

TextStyle getDateTextStyleInExpenseList() {
  return GoogleFonts.lato(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
}

TextStyle getDateTextStyle() {
  return GoogleFonts.lato(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
  );
}

TextStyle getDayTextStyle() {
  return GoogleFonts.lato(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
  );
}

TextStyle getMonthTextStyle() {
  return GoogleFonts.lato(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
  );
}

TextStyle getAppBarTitleStyle() {
  return GoogleFonts.lato(
    color: Get.isDarkMode ? Colors.white : Colors.grey,
    fontSize: 20,
  );
}

TextStyle getTextFieldStyle() {
  return GoogleFonts.lato(
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );
}
