import 'package:RayaExpressDriver/Screens/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'API/API.dart';
import 'Services/Notification.dart';



Future<void> backgroundHandler(RemoteMessage message) async{
  if (kDebugMode) {
    print(message.notification!.title);
    print(message.data.toString());

  }
}

Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp( MaterialApp(
    builder: (context,child){
      return Directionality(textDirection: TextDirection.rtl, child: child!);
    },
    home: const MyApp(),
  ));
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);



  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  API api = API() ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    api.checkNetwork();
    LocalNotificationService.initialize(context);
    ///gives you the message on which user taps
    ///and it opened the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if(message != null){
        final routeFromMessage = message.data["route"];

        Navigator.of(context).pushNamed(routeFromMessage);
      }
    });

    ///foreground work
    FirebaseMessaging.onMessage.listen((message) {
      if(message.notification != null){
        if (kDebugMode) {
          print(message.notification!.body);
          print(message.notification!.title);

        }
      }

      LocalNotificationService.display(message);
    });

    ///When the app is in background but opened and user taps
    ///on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data["route"];

      Navigator.of(context).pushNamed(routeFromMessage);
    });
  }
  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }



}




