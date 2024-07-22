import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'home_screen_student.dart';  // Adjust the import based on your file structure

class SubmitAnimationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Adjust background color as needed
      body: Center(
        child: Lottie.asset(
          'assets/submit.json', // Path to your Lottie file
          onLoaded: (composition) {
            Future.delayed(
              Duration(seconds: composition.duration.inSeconds), // Duration of the animation
                  () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreenStudent(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
