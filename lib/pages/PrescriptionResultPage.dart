import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/Prescription.dart';

class PrescriptionResultPage extends StatefulWidget {
  const PrescriptionResultPage({super.key});

  @override
  State<PrescriptionResultPage> createState() => _PrescriptionResultPageState();
}

class _PrescriptionResultPageState extends State<PrescriptionResultPage> {
  late Prescription pres;
  @override
  void initState() {
    // TODO: implement initState
    pres = Get.arguments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prescription details"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Text(pres.presName),
            Center(
            child: Image.network(pres.qrURL),
          ),
          ]),
        ),
      ),
    );
  }
}
