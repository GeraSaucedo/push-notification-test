import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:push_notif_test/screens/home_screen.dart';
import 'package:push_notif_test/screens/message_screen.dart';
import 'package:push_notif_test/services/push_notifications_service.dart';

void main() async { //Transform main to async

    /// First make sure widgets was initialized
    /// If don't do this, notification service won't 
    /// work cause widgets need to be initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize push notification service 
    await PushNotificationService.initializeApp();
    

    runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  

  @override
  void initState() {
    super.initState();

    PushNotificationService.messaging.getInitialMessage().then((RemoteMessage? message) {
       if(message != null) {
           // Navigate to new page
          navigatorKey.currentState?.pushNamed('message', arguments: message.data['producto'] ?? 'No Data Initial');
       }
    });

    //suscribe to notification message stream 
    PushNotificationService.messageStream.listen((message) {
        
        // Navigate to new page
        navigatorKey.currentState?.pushNamed('message', arguments: message);
        
        // show snackbar 
        scaffoldMessengerKey.currentState?.showSnackBar( SnackBar(content: Text(message)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      navigatorKey: navigatorKey, //Navigation
      scaffoldMessengerKey: scaffoldMessengerKey, //Snackbars
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      routes: {
        'home': (_) => const HomeScreen(),
        'message': (_) => const MessageScreen(),
      },
    );
  }
}