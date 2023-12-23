import 'package:elderly_people/Routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({super.key});

  @override
  State<QRCodeScanner> createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  bool isScanCompleted = false;
  void closeScreen() {
    isScanCompleted = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Scanner'),
        actions: [
          IconButton(
            color: Colors.black,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.black);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.black,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
                child: Container(
              child: const Column(
                children: [
                  Text(
                    "Place the QR code in the area below",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "The Scanning will be done automatically",
                    style: TextStyle(fontSize: 17),
                  )
                ],
              ),
            )),
            Expanded(
                flex: 4,
                child: Container(
                  child: MobileScanner(
                    // fit: BoxFit.contain,
                    controller: cameraController,

                    onDetect: (capture) {
                      //print("hello");
                      final List<Barcode> barcodes = capture.barcodes;
                      final Uint8List? image = capture.image;
                      String barcodeData = "";
                      for (final barcode in barcodes) {
                        barcodeData = "$barcodeData ${barcode.rawValue}\n";
                        debugPrint('Barcode found! ${barcode.rawValue}');
                      }
                      Get.toNamed(Routes.resultPage, arguments: barcodeData);
                    },
                  ),
                )),
          ],
        ),
      ),
      /* MobileScanner(
        // fit: BoxFit.contain,
        controller: cameraController,
        
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          final Uint8List? image = capture.image;
          String barcodeData = "";
          for (final barcode in barcodes) {
            barcodeData = "$barcodeData ${barcode.rawValue}/n";
            //debugPrint('Barcode found! ${barcode.rawValue}');
          }
          Get.toNamed(
            Routes.resultPage,
            arguments: barcodeData
          );
        },
      ),*/
    );
  }
  /*Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR scanner'),),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(child: 
              Container(
                child: const Column(
                  children: [
                    Text("Place the QR code in the area below",style: TextStyle(fontSize: 20),),
                    SizedBox(height: 10,),
                    Text("The Scanning will be done automatically",style: TextStyle(fontSize: 17),)
                  ],
                ),
              )
            ),
            Expanded(
              flex: 4,
              child: 
              Container(
                
                child: MobileScanner(
        // fit: BoxFit.contain,
        controller: cameraController,
        
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          final Uint8List? image = capture.image;
          String barcodeData = "";
          for (final barcode in barcodes) {
            barcodeData = "$barcodeData ${barcode.rawValue}/n";
            //debugPrint('Barcode found! ${barcode.rawValue}');
          }
          Get.toNamed(
            Routes.resultPage,
            arguments: barcodeData
          );
        },
      ),,
              )
            ),
            Expanded(child: 
              Container(
                child: ,
              )
            )
          ],
        ),
      ),
    );
  }*/
}
