import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;
  final Color color,textColor;
  final bool loading;

  const RoundButton({Key? key,
    required this.title,
    required this.onPress,
    this.textColor = Colors.black,
    this.color = Colors.white,
    this.loading = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: BorderRadius.circular(10.0)
      ),
      child:loading ? const Center(child: CircularProgressIndicator()) :  Center(child:Text(title,style:GoogleFonts.poppins(fontSize: 20,fontWeight: FontWeight.w400,) ),),
    );
  }
}
