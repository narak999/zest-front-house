import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle getRobotoFontStyle(double size, bool bold, Color myColor) {
  return GoogleFonts.getFont(
    'Roboto',
    color: myColor,
    fontSize: size,
    fontWeight: bold ? FontWeight.bold: null,
  );
}


Color textColor = const Color(0xff076c87);