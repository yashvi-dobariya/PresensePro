import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presencepro/view/home_screen_student.dart';

import '../common/utils/colour.dart';
import '../common/utils/size_config.dart';
import '../common/widgets/font_style.dart';
import '../common/widgets/outline_button.dart';
import '../common/widgets/reusable_text.dart';
import 'animation.dart';

class FormPage extends StatefulWidget {
  final String scannedCode;

  const FormPage({Key? key, required this.scannedCode}) : super(key: key);

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  late TextEditingController nameController;
  late TextEditingController idController;
  late TextEditingController departmentController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    idController = TextEditingController();
    departmentController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    idController.dispose();
    departmentController.dispose();
    super.dispose();
  }

  void submitForm() async {
    String name = nameController.text;
    String id = idController.text;
    String department = departmentController.text;
    String date = widget.scannedCode; // Assuming scannedCode is the date

    if (name.isEmpty || id.isEmpty || department.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(id).get();

      if (userDoc.exists) {
        Map<String, dynamic> attendanceData = {
          'name': name,
          'id': id,
          'department': department,
          'scannedCode': widget.scannedCode,
          'timestamp': Timestamp.now(),
          'date': date,
        };

        String documentId = '$id$date'; // Combine ID and date for uniqueness
        await FirebaseFirestore.instance.collection('attendance').doc(documentId).set(attendanceData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Attendance marked successfully')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SubmitAnimationScreen(),
          ),
        );
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreenStudent(),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to mark attendance: $error')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreenStudent(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ReusableText(
          text: 'Enter Details',
          style: fontStyle(20, AppConst.black, FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ReusableText(
              //   text: 'Scanned code:',
              //   style: fontStyle(18, AppConst.black, FontWeight.w600),
              // ),
              // SizedBox(height: 0.5*h),
              // ReusableText(
              //   text: widget.scannedCode,
              //   style: fontStyle(15, AppConst.black, FontWeight.w400),
              // ),
              SizedBox(height: 2*h),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: AppConst.grey),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppConst.appTheme), // Default border color
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppConst.appTheme), // Border color when enabled
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppConst.appTheme), // Border color when focused
                  ),
                ),
              ),
          
              const SizedBox(height: 20),
              TextField(
                controller: idController,
                decoration: InputDecoration(
                  labelText: 'Student ID',
                  labelStyle: TextStyle(color: AppConst.grey),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppConst.appTheme), // Default border color
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppConst.appTheme), // Border color when enabled
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppConst.appTheme), // Border color when focused
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: departmentController,
                decoration: InputDecoration(
                  labelText: 'Department',
                  labelStyle: TextStyle(color: AppConst.grey),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppConst.appTheme), // Default border color
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppConst.appTheme), // Border color when enabled
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppConst.appTheme), // Border color when focused
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: CustomOtlnBtn(
                  width: 80 * w,
                  height: 6.5 * h,
                  buttonBorderColor: AppConst.white,
                  onPress: () {
                    submitForm();
                  },
                  buttonName: "Submit",
                  buttonColor: AppConst.appTheme,
                  buttonTextColor: AppConst.white,
                ),
              ),
              // Center(
              //   child: ElevatedButton(
              //     onPressed: submitForm,
              //     child: const Text('Submit'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
