import 'package:elderly_people/Routes.dart';
import 'package:flutter/material.dart';
import 'package:elderly_people/widget/PredefinedWidgets.dart';
import 'package:get/get.dart';

class PredefinedItemList extends StatefulWidget {
  const PredefinedItemList({super.key});

  @override
  State<PredefinedItemList> createState() => _PredefinedItemListState();
}

class _PredefinedItemListState extends State<PredefinedItemList> {
  late List<bool> isCheckedList = [
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  List<String> Items = [
    "apples",
    "juice",
    "milk",
    "cereal",
    "bread",
    "bottled Water"
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void setBooleanValue() {
    isCheckedList = [];
    for (var i = 0; i < Items.length; i++) {
      isCheckedList.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Predefined List"),
      ),
      body: Center(
          child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: Items.length,
              itemBuilder: (BuildContext context, int index) {
                
                return Row(children: <Widget>[
                  Center(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: CheckboxListTile(
                          title: Text(Items[index]),
                          value: isCheckedList[index],
                          onChanged: (val) {
                            setState(() {
                              isCheckedList[index] = val!;
                            });
                          },
                        )),
                  ),
                ]);
              },
            ),
          ),
          const SizedBox(height: 10,),

          PredefinedWidgets.myButton(context, () {}, "Add another Item"),
          const SizedBox(height: 10,),
          PredefinedWidgets.myButton(context, () {
            Get.toNamed(Routes.addShoppingItem);
          }, "Submit"),
        ],
      )),
    );
  }
}
