// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:RayaExpressDriver/Screens/PickupScreen.dart';

import 'ReleaseBySearchScreen.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample(
      {Key? key,
      required this.dUserID,
      required this.driverID,
      required this.driverUsername,
      required this.release})
      : super(key: key);

  final String dUserID;
  final int driverID;
  final String driverUsername;
  final bool release;

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                      'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  : const Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (widget.release == true) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return ReleaseBySearchScreen(
              dUserID: widget.dUserID,
              driverID: widget.driverID,
              driverUsername: widget.driverUsername,
              awb: scanData.code!,
              orderNumber: '',
            );
          }),
        );
      } else if (widget.release == false) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return PickupScreen(
              driverUsername: widget.driverUsername,
              dUserID: widget.dUserID,
              driverID: widget.driverID,
              aWB: scanData.code!,
            );
          }),
        );
      }
      // setState(() {
      //   result = scanData;
      // });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
