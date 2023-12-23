import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late String barcodeValue;

  //late Uint8List? image ;
  @override
  void initState() {
    // TODO: implement initState
    barcodeValue = Get.arguments;
    //image=Get.arguments[1];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Result screen"),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child:Column(
          children: [
            //show QR code
            QrImageView(
              data: barcodeValue,
              size: 200,
              version: QrVersions.auto,
            ),
            const Text("Result:"),
            const SizedBox(
              height: 10,
            ),
            Text(barcodeValue, style: TextStyle(fontSize: 20),),
          ],
        ),
      )),
    );
  }
}
