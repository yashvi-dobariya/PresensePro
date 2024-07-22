import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../common/utils/colour.dart';
import '../common/utils/size_config.dart';
import '../common/widgets/font_style.dart';
import '../common/widgets/outline_button.dart';
import '../common/widgets/reusable_text.dart';

class MyAttendance extends StatefulWidget {
  const MyAttendance({Key? key}) : super(key: key);

  @override
  State<MyAttendance> createState() => _MyAttendanceState();
}

class _MyAttendanceState extends State<MyAttendance> {
  late TextEditingController idController;
  List<String> presentDays = [];

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
  }

  @override
  void dispose() {
    idController.dispose();
    super.dispose();
  }

  void _showLowAttendanceNotification(double percentage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: ReusableText(
            text: 'Low Attendance !',
            style: fontStyle(23, AppConst.black, FontWeight.normal),
          ),
          content:Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReusableText(
                text: 'Your attendance is below 50%',
                style: fontStyle(15, AppConst.black, FontWeight.normal),
              ),
              SizedBox(height: 1*h,),
              ReusableText(
                text: 'Current attendance: ${percentage.toStringAsFixed(2)}%',
                style: fontStyle(15, Colors.red, FontWeight.normal),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK',),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _fetchAttendance(String studentId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('attendance').get();
      List<String> dates = [];

      DateTime now = DateTime.now();
      String currentYearMonth = '${now.year.toString().padLeft(4, '0')}${now.month.toString().padLeft(2, '0')}';

      for (var doc in querySnapshot.docs) {
        String docId = doc.id;
        if (docId.startsWith(studentId)) {
          String datePart = docId.substring(studentId.length);
          if (datePart.length >= 8) {
            String yearMonthDay = datePart.substring(0, 8);
            if (yearMonthDay.startsWith(currentYearMonth)) {
              DateTime date = DateTime.parse('${yearMonthDay.substring(0, 4)}-${yearMonthDay.substring(4, 6)}-${yearMonthDay.substring(6, 8)}');
              String formattedDate = DateFormat('dd MMMM yyyy').format(date);
              dates.add(formattedDate);
            }
          }
        }
      }

      setState(() {
        presentDays = dates;
      });

      if (dates.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No attendance records found for this ID in the current month')),
        );
      } else {
        int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
        double attendancePercentage = (presentDays.length / daysInMonth) * 100;
        if (attendancePercentage < 50) {
          _showLowAttendanceNotification(attendancePercentage);
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch attendance: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    return Scaffold(
      appBar: AppBar(
        title: ReusableText(
          text: 'My Attendance',
          style: fontStyle(20, AppConst.black, FontWeight.w600),
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: idController,
              decoration: InputDecoration(
                labelText: 'Enter Student ID',
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
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 4*h),
            CustomOtlnBtn(
              width: 80 * w,
              height: 6.5 * h,
              buttonBorderColor: AppConst.white,
              onPress: () {
                _fetchAttendance(idController.text);
              },
              buttonName: "Check Attendance",
              buttonColor: AppConst.appTheme,
              buttonTextColor: AppConst.white,
            ),
            SizedBox(height: 5*h),
            ReusableText(
              text: 'Attendance Percentage: ${(presentDays.length / daysInMonth * 100).toStringAsFixed(2)}%',
              style: fontStyle(15, AppConst.black, FontWeight.normal),
            ),
            SizedBox(height: 5*h),
            presentDays.isEmpty
                ? ReusableText(
              text: 'No attendance Record found !!',
              style: fontStyle(15, AppConst.black, FontWeight.normal))
                : Expanded(
              child: GridView.count(
                crossAxisCount: 7,
                children: List.generate(daysInMonth, (index) {
                  DateTime day = DateTime(now.year, now.month, index + 1);
                  String formattedDay = DateFormat('dd MMMM yyyy').format(day);
                  bool isPresent = presentDays.contains(formattedDay);
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: isPresent ? Colors.green : Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(
                          color: isPresent ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
