import 'package:flutter/material.dart';
import 'package:flutter/src/painting/text_style.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle fontStyle(double size,Color color, FontWeight fw){
  return GoogleFonts.poppins(fontSize: size,color: color,fontWeight: fw);
}
