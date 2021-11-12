import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:push_notifs_o2021/books.dart';
import 'package:push_notifs_o2021/main.dart';
import 'package:push_notifs_o2021/utils/notification_util.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'notif_menu.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  Future<void> getKey() async {
    String? token = await messaging.getToken(
      vapidKey:
          "AAAARhk9zTs:APA91bHOwarEQIT5eD2dtNmJte_dMokN8YHguOzonQ8qbVaNyFagXhN_e-G9s04JU8MFgGHnWLvHFDzJFV5oyYqHUUAeAUfHFypQhbMU1d35jy3gKEKiUINNl2n6DFmie8Zb1xOFF1_e",
    );
    print('token: ${token}');
  }

  // void showNotif() {
  //   setState(() {});
  //   flutterLocalNotificationsPlugin.show(
  //     0,
  //     "Test",
  //     "hello",
  //     NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         channel.id,
  //         channel.name,
  //         importance: Importance.high,
  //         color: Colors.blue,
  //         playSound: true,
  //       ),
  //     ),
  //   );
  // }

  @override
  void initState() {
    getKey();
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ),
          );
        }
      },
    );
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        print('A new onMessageOpenedApp event was published!');
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            },
          );
        }
      },
    );

    AwesomeNotifications().requestPermissionToSendNotifications().then(
          (isAllowed) => {
            if (isAllowed)
              {
                AwesomeNotifications()
                    .displayedStream
                    .listen((notificationMsg) {
                  print(notificationMsg);
                }),
                // escuchar por notificaciones con botones (son actions)
                AwesomeNotifications().actionStream.listen(
                  (notificationAction) {
                    if (!StringUtils.isNullOrEmpty(
                        notificationAction.buttonKeyInput)) {
                      // respuesta de un mensaje input de texto
                      print(notificationAction);
                    } else {
                      // abrir pantalla
                      // lóica para hacer algo cuando presionen el botón
                      print(notificationAction);
                    }
                  },
                )
              }
          },
        );
    super.initState();
  }

  // método para abrir una nueva pantalla
  void processDefaultActionReceived(ReceivedAction action) {
    print('Acción recibida $action');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Books(datos: action.title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: CircleAvatar(
              maxRadius: 120,
              backgroundColor: Colors.black87,
              child: Image.asset(
                "assets/books.png",
                height: 120,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: NotifMenu(
              notifSimple: () => {showBasicNotification(123)},
              notifConIcono: () => {showLargeIconNotification(321)},
              notifConImagen: () => {},
              notifConAccion: () => {},
              notifAgendada: () => {},
              cancelNotifAgendada: () => {},
            ),
          ),
        ],
      ),
    );
  }
}
