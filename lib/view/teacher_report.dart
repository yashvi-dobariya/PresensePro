import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import '../common/utils/colour.dart';
import '../common/utils/size_config.dart';
import '../common/widgets/font_style.dart';
import '../common/widgets/outline_button.dart';
import '../common/widgets/reusable_text.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  late TextEditingController dateController;
  List<Map<String, dynamic>> attendanceRecords = [];

  @override
  void initState() {
    super.initState();
    dateController = TextEditingController();
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  void fetchAttendance(String date) async {
    String formattedDate = date.replaceAll('-', '');

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('attendance').get();

      List<Map<String, dynamic>> filteredRecords = querySnapshot.docs
          .where((doc) => doc.id.contains(formattedDate))
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      setState(() {
        attendanceRecords = filteredRecords;
      });

      if (attendanceRecords.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No attendance records found for this date')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch attendance: $error')),
      );
    }
  }

  Future<void> downloadAttendance() async {
    if (attendanceRecords.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No attendance data to download')),
      );
      return;
    }

    // Convert data to CSV
    List<List<dynamic>> rows = [];
    rows.add(['Name', 'ID', 'Department']); // Header

    for (var record in attendanceRecords) {
      rows.add([
        record['name'],
        record['id'],
        record['department']
      ]);
    }

    String csvData = const ListToCsvConverter().convert(rows);

    // Convert CSV data to Uint8List
    Uint8List csvDataBytes = Uint8List.fromList(csvData.codeUnits);

    // Get directory to save file
    Directory? directory = await getExternalStorageDirectory();
    String path = '${directory?.path}/attendance_${dateController.text.replaceAll('-', '')}.csv';

    // Save file
    File file = File(path);
    await file.writeAsString(csvData);

    // Show file dialog to download
    await FlutterFileDialog.saveFile(
      params: SaveFileDialogParams(
        fileName: 'attendance_${dateController.text.replaceAll('-', '')}.csv',
        data: csvDataBytes,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Attendance data downloaded successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  ReusableText(
          text: 'Attendance Report',
          style: fontStyle(20, AppConst.black, FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.download,color: AppConst.appTheme,),
            onPressed: downloadAttendance,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: 'Enter Date (YYYY-MM-DD)',
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
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 5*h),
            CustomOtlnBtn(
              width: 80 * w,
              height: 6.5 * h,
              buttonBorderColor: AppConst.white,
              onPress: () {
                fetchAttendance(dateController.text);
              },
              buttonName: "Attendance",
              buttonColor: AppConst.appTheme,
              buttonTextColor: AppConst.white,
            ),

            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: attendanceRecords.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> record = attendanceRecords[index];
                  return ListTile(
                    title:  ReusableText(
                      text: 'Name: ${record['name']}',
                      style: fontStyle(15, AppConst.black, FontWeight.normal),
                    ),

                    subtitle: ReusableText(
                      text: 'ID: ${record['id']} - Department: ${record['department']}',
                      style: fontStyle(12, Colors.grey.shade600, FontWeight.normal),
                    ),

                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
