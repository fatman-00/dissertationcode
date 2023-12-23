import 'package:elderly_people/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // Notifications notifi = Notifications();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // notifi.initialisaNotifications();
  }

  String getTitle(int index) {
    switch (index) {
      case 0:
        return 'Change Personal details';
      case 1:
        return 'Change Password';
      case 2:
        return 'Emergency Contact';
      case 3:
        return 'Generate Virtual Meet';
      case 4:
        return 'Memory game';

      // case 5:
      //   return 'Medication Time';

      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Replace with the actual number of items
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    //Navigate to the respective page based on the item index
                    switch (index) {
                      case 0:
                        Get.toNamed(Routes.changeUserDetails);
                        break;
                      case 1:
                        Get.toNamed(Routes.changePassword);
                        break;
                      case 2:
                        Get.toNamed(Routes.listEmergencyContact);
                        break;
                      case 3:
                        Get.toNamed(Routes.generateMeet);
                        break;
                      case 4:
                        Get.toNamed(Routes.memoryGame);

                        break;
                      //case 5:
                        //Get.toNamed(Routes.editMedicationTime);

                      //  break;
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      getTitle(
                          index), // Replace with the actual titles for each item
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          /*ElevatedButton(
              onPressed: () {
                notifi.sendNotification("this is a title", "this is a body");
              },
              child: const Text("notification"))
        */
        ],
      ),
    );
  }
}
