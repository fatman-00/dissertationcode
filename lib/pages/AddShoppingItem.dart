import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_people/widget/PredefinedWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AddShoppingItemSevice {
  static validate(BuildContext context, String itemname, String qty) {
    if (itemname == "") {
      PredefinedWidgets.showMyErrorDialog(
          context, "Item Name is Empty", "Please enter a value for item name");
    } else if (qty == "") {
      PredefinedWidgets.showMyErrorDialog(
          context, "Quantity is Empty", "Please enter a quantity");
    } else {
      addItemToDB(context, itemname, qty);
    }
  }

  static addItemToDB(BuildContext context, String itemname, String qty) {
    FirebaseFirestore.instance.collection("ShoppingItems").add({
      "uid": FirebaseAuth.instance.currentUser!.uid,
      "ItemName": itemname,
      "qty": qty,
      "completed": false,
    }).then((value) {
      Get.back();
      PredefinedWidgets.showMySuccessDialog(context, "Item Successfully added",
          "The item $itemname has been successfully added");
    }).onError((error, stackTrace) {
      PredefinedWidgets.showMyErrorDialog(
          context, "Error", "Their has been an error when adding item");
    });
  }
}

class AddShoppingItem extends StatefulWidget {
  const AddShoppingItem({super.key});

  @override
  State<AddShoppingItem> createState() => _AddShoppingItemState();
}

class _AddShoppingItemState extends State<AddShoppingItem> {
  TextEditingController itemName = TextEditingController();

  TextEditingController qty = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add items"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            PredefinedWidgets.getTextField(itemName, "Enter item name", false),
            const SizedBox(
              height: 10,
            ),
            PredefinedWidgets.getNumberTextField(qty, "Quantity", false),
            const SizedBox(
              height: 10,
            ),
            PredefinedWidgets.myButton(context, () {
              AddShoppingItemSevice.validate(context, itemName.text, qty.text);
            }, "submit"),
          ],
        ),
      ),
    );
  }
}
