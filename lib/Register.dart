import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:presencepro/common/utils/colour.dart';
import 'package:presencepro/view/home_screen_student.dart';
import 'Login.dart';
import 'common/utils/size_config.dart';
import 'common/widgets/font_style.dart';
import 'common/widgets/outline_button.dart';
import 'common/widgets/reusable_text.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  _RegisterState();

  bool showProgress = false;
  bool visible = false;

  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpassController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();
  bool _isObscure = true;
  bool _isObscure2 = true;
  File? file;
  var options = [
    'Student',
    'Teacher',
  ];
  var _currentItemSelected = "Student";
  var role = "Student";

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
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(12),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         SizedBox(
                          height: 8*h,
                        ),
                        ReusableText(
                          text: 'PresencePro',
                          style: fontStyle(35, AppConst.white, FontWeight.w600),
                        ),
                        SizedBox(
                          height: 5*h,
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
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          obscureText: _isObscure,
                          controller: passwordController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(_isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                            ),
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
                            if (value!.isEmpty) {
                              return "Password cannot be empty";
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters long";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          obscureText: _isObscure2,
                          controller: confirmpassController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(_isObscure2
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _isObscure2 = !_isObscure2;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Confirm Password',
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
                            if (value!.isEmpty) {
                              return "Please confirm your password";
                            }
                            if (value != passwordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Name',
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
                              return "Name cannot be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: studentIdController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Student ID',
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
                              return "Student ID cannot be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: TextEditingController(
                            text: 'Role: ${_currentItemSelected ?? 'Select Role'}',
                          ),
                          readOnly: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Role',
                            enabled: true,
                            contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                          ),
                          onTap: () async {
                            String? selectedRole = await showModalBottomSheet<String>(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  color: AppConst.homeContainer,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: ['Student', 'Teacher'].map((String role) {
                                      return ListTile(
                                        title: ReusableText(
                                          text: role,
                                          style: fontStyle(18, AppConst.black, FontWeight.normal),
                                        ),
                                        onTap: () {
                                          Navigator.pop(context, role);
                                        },
                                      );
                                    }).toList(),
                                  ),
                                );
                              },
                            );

                            if (selectedRole != null && selectedRole != _currentItemSelected) {
                              setState(() {
                                _currentItemSelected = selectedRole;
                                role = selectedRole;
                              });
                            }
                          },
                          validator: (value) {
                            if (value!.isEmpty || value == 'Role: Select Role') {
                              return "Role cannot be empty";
                            }
                            return null;
                          },
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
                                  showProgress = true;
                                });
                                signUp(emailController.text, passwordController.text);
                              },
                              buttonName: "Register",
                              buttonColor: AppConst.white,
                              buttonTextColor: AppConst.black,
                            ),

                            // MaterialButton(
                            //   shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(20.0),
                            //   ),
                            //   elevation: 5.0,
                            //   height: 40,
                            //   onPressed: () {
                            //     setState(() {
                            //       showProgress = true;
                            //     });
                            //     signUp(emailController.text, passwordController.text);
                            //   },
                            //   color: Colors.white,
                            //   child: const Text(
                            //     "Register",
                            //     style: TextStyle(
                            //       fontSize: 20,
                            //     ),
                            //   ),
                            // ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                );
                              },
                              child:  Row(
                                children: [
                                  ReusableText(
                                    text: 'Already Registered? ',
                                    style: fontStyle(15, AppConst.white, FontWeight.w300),
                                  ),
                                  ReusableText(
                                    text: 'Login',
                                    style: fontStyle(15, AppConst.white, FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
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

  void signUp(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        final newUser = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (newUser != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(studentIdController.text)  // Using student ID as the document ID
              .set({
            'email': email,
            'name': nameController.text,
            'student_id': studentIdController.text,
            'role': role,
          });

          // Navigate to HomeScreen after successful registration
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreenStudent(), // Replace with your HomeScreen widget
            ),
          );

          setState(() {
            showProgress = false;
          });
        }
      } catch (e) {
        setState(() {
          showProgress = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }
}