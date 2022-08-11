import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'repositories/push_notification_repository/push_notification_repository.dart';
import 'screens/home_screen.dart';
import 'screens/message_screen.dart';
import 'services/push_notifications_service.dart';


void main() async { //Transform main to async

    /// First make sure widgets was initialized
    /// If don't do this, notification service won't 
    /// work cause widgets need to be initialized
    WidgetsFlutterBinding.ensureInitialized();

    //Initialize firebase app
    await Firebase.initializeApp();

    // Initialize push notification service 
    final pushNotificationRepository = PushNotificationRepository();
    await pushNotificationRepository.initializeApp();
    
    runApp(MyApp(
      pushNotificationRepository: pushNotificationRepository,
    ));
}

class MyApp extends StatefulWidget {

  final PushNotificationRepository _pushNotificationRepository;

  const MyApp({Key? key,
    required PushNotificationRepository pushNotificationRepository
  }) : _pushNotificationRepository = pushNotificationRepository, super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  late PushNotificationService _pushNotificationService; 
              
  

  @override
  void initState() {
    super.initState();

    _pushNotificationService = PushNotificationService(pushNotificationRepository: widget._pushNotificationRepository);

    // Get any messages which caused the application to open from
    // a terminated state.
    _pushNotificationService.getInitialMessage().then((message) {
       if(message != null) {
           // Navigate to new page
          navigatorKey.currentState?.pushNamed('message', arguments: message.data['producto'] ?? 'No Data Initial');
       }
    });

    //suscribe to notification message stream 
    _pushNotificationService.messageStream.listen((message) {
        
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