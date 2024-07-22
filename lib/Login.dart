import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presencepro/view/home_screen_student.dart';
import 'package:presencepro/view/home_screen_teacher.dart';
import 'common/utils/colour.dart';
import 'common/utils/size_config.dart';
import 'common/widgets/font_style.dart';
import 'common/widgets/outline_button.dart';
import 'common/widgets/reusable_text.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure3 = true;
  bool visible = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConst.appTheme,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(12),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        ReusableText(
                          text: 'Let’s jump in!',
                          style: fontStyle(27, AppConst.white, FontWeight.bold),
                        ),
                        SizedBox(
                          height: 3 * h,
                        ),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Email',
                            enabled: true,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Email cannot be empty";
                            }
                            if (!RegExp(
                                "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return "Please enter a valid email";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            emailController.text = value!;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: _isObscure3,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure3
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _isObscure3 = !_isObscure3;
                                  });
                                }),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Password',
                            enabled: true,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 15.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            RegExp regex = RegExp(r'^.{6,}$');
                            if (value!.isEmpty) {
                              return "Password cannot be empty";
                            }
                            if (!regex.hasMatch(value)) {
                              return "Please enter a valid password with min. 6 characters";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            passwordController.text = value!;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomOtlnBtn(
                              width: 30 * w,
                              height: 5 * h,
                              buttonBorderColor: AppConst.white,
                              onPress: () {
                                setState(() {
                                  visible = true;
                                });
                                signIn(emailController.text,
                                    passwordController.text);
                              },
                              buttonName: "Login",
                              buttonColor: AppConst.white,
                              buttonTextColor: AppConst.black,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Register(),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  ReusableText(
                                    text: 'Not register yet? ',
                                    style: fontStyle(
                                        15, AppConst.white, FontWeight.w300),
                                  ),
                                  ReusableText(
                                    text: 'Register',
                                    style: fontStyle(
                                        15, AppConst.white, FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Visibility(
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            visible: visible,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void route(User user) async {
      // Check for specific UID
      if (user.uid == 'ZJ9dYxJGeDat9XWroMEs1C1rr822') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreenTeacher(),
          ),
        );
        return;
      }
      else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreenStudent(),
          ),
        );
      }

      // For all other users, fetch user data from Firestore
    //   DocumentSnapshot userDoc = await FirebaseFirestore.instance
    //       .collection('users')
    //       .doc(user.uid)
    //       .get();
    //
    //   if (userDoc.exists) {
    //       Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => HomeScreenStudent(),
    //         ),
    //       );
    //     }
    //    else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text('No user data found.'),
    //       ),
    //     );
    //   }
    // } catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Failed to fetch user data: $e'),
    //     ),
    //   );
    // } finally {
    //   setState(() {
    //     visible = false;
    //   });
    // }
  }

  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        route(userCredential.user!);
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'user-not-found') {
          message = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          message = 'Wrong password provided for that user.';
        } else {
          message = 'An error occurred. Please try again.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      } finally {
        setState(() {
          visible = false;
        });
      }
    }
  }
}
