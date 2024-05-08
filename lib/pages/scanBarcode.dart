import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pit/themes/AppTheme.dart';
import 'package:pit/utils/SizeConfig.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;

  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  result != null
                      ? Text('Barcode Code: ${result!.code}')
                      // Text(
                      //                 'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                      : const Text('Scan a code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: AppTheme.warnaHijau,
                              // minimumSize: Size(15, 33),
                              // padding: EdgeInsets.only(left: 43, right: 43),
                              // shape: const RoundedRectangleBorder(
                              //   borderRadius:
                              //       BorderRadius.all(Radius.circular(20)),
                              // ),
                            ),
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                String toggleFlash = "Off";
                                if (snapshot.data == true) {
                                  toggleFlash = "On";
                                }

                                return Text('Flash ${toggleFlash}');
                              },
                            )),
                      ),
                      // Container(
                      //   margin: const EdgeInsets.all(8),
                      //   child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //       primary: result != null
                      //           ? AppTheme.warnaHijau
                      //           : Colors.grey,
                      //       // minimumSize: Size(15, 33),
                      //       // padding: EdgeInsets.only(left: 43, right: 43),
                      //       // shape: const RoundedRectangleBorder(
                      //       //   borderRadius:
                      //       //       BorderRadius.all(Radius.circular(20)),
                      //       // ),
                      //     ),
                      //     onPressed: () async {
                      //       if (result != null) {
                      //         if (result!.code != null) {
                      //           Navigator.of(context).pop("${result!.code}");
                      //         }
                      //       }
                      //     },
                      //     child: const Text(
                      //       "Simpan",
                      //       style: TextStyle(color: Colors.white),
                      //     ),
                      //   ),
                      // )
                      // Container(
                      //   margin: const EdgeInsets.all(8),
                      //   child: ElevatedButton(
                      //       onPressed: () async {
                      //         await controller?.flipCamera();
                      //         setState(() {});
                      //       },
                      //       child: FutureBuilder(
                      //         future: controller?.getCameraInfo(),
                      //         builder: (context, snapshot) {
                      //           if (snapshot.data != null) {
                      //             print("snapshot.data");
                      //             print(snapshot.data);
                      //             // Navigator.pop(context,"${describeEnum(snapshot.data!)}");
                      //             return Text(
                      //                 'Camera facing ${describeEnum(snapshot.data!)}');
                      //           } else {
                      //             return const Text('loading');
                      //           }
                      //         },
                      //       )),
                      // )
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: <Widget>[
                  //     Container(
                  //       margin: const EdgeInsets.all(8),
                  //       child: ElevatedButton(
                  //         onPressed: () async {
                  //           await controller?.pauseCamera();
                  //         },
                  //         child: const Text('pause',
                  //             style: TextStyle(fontSize: 20)),
                  //       ),
                  //     ),
                  //     Container(
                  //       margin: const EdgeInsets.all(8),
                  //       child: ElevatedButton(
                  //         onPressed: () async {
                  //           await controller?.resumeCamera();
                  //         },
                  //         child: const Text('resume',
                  //             style: TextStyle(fontSize: 20)),
                  //       ),
                  //     )
                  //   ],
                  // ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: result != null ? AppTheme.warnaHijau : Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          // cutOutSize: scanArea,
          cutOutHeight: MySize.scaleFactorWidth * 300,
          cutOutWidth: MySize.scaleFactorHeight * 300),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        controller.stopCamera();
        Navigator.of(context).pop("${scanData.code}");
      }
      // setState(() {
      //   result = scanData;
      // });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    print('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
