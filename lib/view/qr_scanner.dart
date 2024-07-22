import 'package:flutter/material.dart';
import 'package:presencepro/common/utils/colour.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../common/widgets/font_style.dart';
import '../common/widgets/reusable_text.dart';
import 'form_page_student.dart';
import 'package:intl/intl.dart';  // Add this import for date formatting

class QrCodeScannerPage extends StatefulWidget {
  const QrCodeScannerPage({super.key});

  @override
  _QrCodeScannerPageState createState() => _QrCodeScannerPageState();
}

class _QrCodeScannerPageState extends State<QrCodeScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ReusableText(
          text: 'Scan QR',
          style: fontStyle(24, AppConst.appTheme, FontWeight.w600),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: AppConst.appTheme,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300.0,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text('Barcode Type: ${result!.format}   Data: ${result!.code}')
                  : const Text('Scan a code'),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });

      if (result != null && result!.code != null) {
        // Validate if scanned QR code matches today's date
        DateTime currentDate = DateTime.now();
        String formattedDate = DateFormat('yyyyMMdd').format(currentDate);

        // Assuming the QR code contains a date string in format 'yyyyMMdd'
        if (result!.code!.startsWith(formattedDate)) {
          controller.pauseCamera();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FormPage(scannedCode: result!.code!),
            ),
          );
        } else {
          // Handle case where scanned QR code does not match today's date
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Invalid QR Code'),
              content: const Text('The QR code scanned is not valid for today.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Resume scanning
                    controller.resumeCamera();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    });
  }
}
