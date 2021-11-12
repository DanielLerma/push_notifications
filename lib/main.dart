import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:push_notifs_o2021/home/home_page.dart';

import 'utils/constants_utils.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  importance: Importance.high,
  playSound: true,
);

Future<void> main() async {
  await initLocalNotifications();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

Future initLocalNotifications() async {
  // inicializar los canales / agrupar notificaciones
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        // simples-normales: título y descripción
        channelKey: channelSimpleId, // canales ya creados en constants_utils
        channelName: channelSimpleName,
        channelDescription: channelSimpleDescr,
        defaultColor: Colors.purple,
        ledColor: Colors.yellow,
        importance: NotificationImportance.Default,
      ),
      NotificationChannel(
        // simples-normales: título y descripción
        channelKey:
            channelBigPictureId, // canales ya creados en constants_utils
        channelName: channelBigPictureName,
        channelDescription: channelBigPictureDescr,
        defaultColor: Colors.purple,
        ledColor: Colors.blue,
        importance: NotificationImportance.High,
      ),
      NotificationChannel(
        // simples-normales: título y descripción
        channelKey: channelScheduleId, // canales ya creados en constants_utils
        channelName: channelScheduleName,
        channelDescription: channelScheduleDescr,
        defaultColor: Colors.purple,
        ledColor: Colors.red,
        importance: NotificationImportance.Default,
      )
    ],
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: ColorScheme(
          primary: Colors.indigo,
          primaryVariant: Colors.indigoAccent,
          secondary: Colors.green,
          secondaryVariant: Colors.lime,
          surface: Colors.grey[200]!,
          background: Colors.grey[200]!,
          // background: Colors.deepPurple[100]!,
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.grey,
          onBackground: Colors.deepPurple[100]!,
          onError: Colors.red,
          brightness: Brightness.light,
        ),
      ),
      home: HomePage(),
    );
  }
}
