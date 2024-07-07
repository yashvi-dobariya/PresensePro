import 'dart:math';
import 'package:custom_qr_generator/custom_qr_generator.dart';
import 'package:flutter/material.dart';
import 'package:presencepro/common/utils/colour.dart';
import '../common/utils/size_config.dart';
import '../common/widgets/font_style.dart';
import '../common/widgets/outline_button.dart';
import '../common/widgets/reusable_text.dart';

String generateUniqueCode() {
  var random = Random();
  int randomNumber = 1000 + random.nextInt(9000);
  return randomNumber.toString();
}

class QrCodeGenerator extends StatefulWidget {
  const QrCodeGenerator({super.key});

  @override
  _QrCodeGeneratorState createState() => _QrCodeGeneratorState();
}

class _QrCodeGeneratorState extends State<QrCodeGenerator> {
  String uniqueCode = generateUniqueCode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ReusableText(
          text: 'Generate QR',
          style: fontStyle(24, AppConst.appTheme, FontWeight.w600),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomPaint(
            painter: QrPainter(
                data: uniqueCode,
                options: const QrOptions(
                    shapes: QrShapes(
                        darkPixel: QrPixelShapeRoundCorners(
                            cornerFraction: .10
                        ),
                        frame: QrFrameShapeRoundCorners(
                            cornerFraction: .10
                        ),
                        ball: QrBallShapeRoundCorners(
                            cornerFraction: .10
                        )
                    ),
                    colors: QrColors(
                        dark: QrColorLinearGradient(
                            colors: [
                              AppConst.black,
                              Colors.black
                            ],
                            orientation: GradientOrientation.leftDiagonal
                        )
                    )
                )),
            size:  Size(70 * w, 70 * w),
          ),
          ReusableText(
            text: uniqueCode,
            style: fontStyle(28, AppConst.black, FontWeight.w600),
          ),
          SizedBox(height: 15*h),
          Center(
            child: CustomOtlnBtn(
              width: 88*w,
              height: 6.5*h,
              buttonBorderColor: AppConst.white,
              onPress: (){
                setState(() {
                  uniqueCode = generateUniqueCode();
                });
              },
              buttonName:"Generate New QR Code", buttonColor: AppConst.appTheme, buttonTextColor: AppConst.white,
            ),
          ),
        ],
      ),
    );
  }
}
