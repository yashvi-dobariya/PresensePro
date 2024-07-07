import 'package:flutter/material.dart';
import 'package:presencepro/common/utils/colour.dart';
import 'package:presencepro/common/widgets/reusable_text.dart';
import 'package:presencepro/common/utils/size_config.dart';
import 'package:presencepro/view/qr_generator.dart';
import 'package:presencepro/view/qr_scanner.dart';
import '../common/widgets/font_style.dart';
import 'attendance.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ClipPath(
            clipper: HeaderClipper(),
            child: Container(
              color: AppConst.appTheme,
              height: 27*h,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4*w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5*h),
                ReusableText(
                  text: 'Dashboard',
                  style: fontStyle(24, AppConst.white, FontWeight.w600),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5 * w,
                    mainAxisSpacing: 5 * w,
                    children: [
                      buildContainer(context, 'Generate QR', AppConst.homeContainer, Icons.qr_code_2,const QrCodeGenerator()),
                      buildContainer(context, 'Attendance', AppConst.homeContainer, Icons.mark_chat_read,const Attendance()),
                      buildContainer(context, 'Scan QR', AppConst.homeContainer, Icons.bar_chart_outlined,const QrCodeScannerPage()),
                      // buildContainer(context, 'Events', AppConst.homeContainer, Icons.event_available_outlined,Events()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildContainer(BuildContext context, String text, Color color, IconData iconData, Widget destinationScreen) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destinationScreen),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppConst.grey.withOpacity(0.5),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            size: 38,
            color: Colors.black,
          ),
          SizedBox(height: 1 * h),
          ReusableText(
            text: text,
            style: fontStyle(16, AppConst.fontGrey, FontWeight.w300),
          ),
        ],
      ),
    ),
  );
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 50);
    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 100);
    var secondEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
