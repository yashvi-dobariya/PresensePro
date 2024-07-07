import 'package:flutter/material.dart';
import '../common/utils/colour.dart';
import '../common/utils/size_config.dart';
import '../common/widgets/outline_button.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomOtlnBtn(
          width: 88*w,
          height: 6.5*h,
          buttonBorderColor: AppConst.white,
          onPress: (){

          },
          buttonName:"Generate New QR Code", buttonColor: AppConst.appTheme, buttonTextColor: AppConst.white,
        )
    );

  }
}
