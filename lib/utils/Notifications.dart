import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications {
  final FlutterLocalNotificationsPlugin _notification =
      FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings _android =
      const AndroidInitializationSettings('mipmap/elderly_people');
  void initialisaNotifications() async {
    InitializationSettings initializationSettings = InitializationSettings(
      android: _android,
    );
    await _notification
        .initialize(initializationSettings)
        .then((value) => print("success"))
        .onError((error, stackTrace) => print("Error"));
  }

  void sendNotification(String title, String body) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails("channelId", "channelName",
            playSound: true,
            importance: Importance.max,
            priority: Priority.high); // setting notification setting
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);//initializing setting
    //print("entering");
    await _notification.show(0, title, body, notificationDetails);//display notification
    //.then((value) => print("nice")).onError((error, stackTrace) => print("Error"));
  }
}
// class Notifications {
//   static final _notification = FlutterLocalNotificationsPlugin();
//   static Future _notificationDetails() async {
//     return const NotificationDetails(
//         android: AndroidNotificationDetails("channelId", "channelName",
//             importance: Importance.max));
//   }

//   static showNotification({
//     int id = 0,
//     String? title,
//     String? body,
//     String? payload,
//   }) async =>
//       _notification.show(id, title, body, await _notificationDetails(),
//           payload: payload);
// }

// class LocalNotificationManager {
//   late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

//   LocalNotificationManager() {
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     initialize();
//   }

//   Future<void> initialize() async {
//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//     );
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   Future<void> showNotification() async {
//     print("entering");
//     var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
//       'channel_id',
//       'channel_name',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     var platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//     );

//     await flutterLocalNotificationsPlugin.show(
//       0,
//       'Notification Title',
//       'Notification Body',
//       platformChannelSpecifics,
//     );
//   }
// }
