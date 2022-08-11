//SHA1 - DB:19:85:52:57:0F:80:D7:CD:BA:2C:7A:8D:E2:1A:9F:A8:00:6A:9B

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {

  //Crate tihe firebase messaging instance
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

  /// Allow  emit a value in order to suscribe to notification messages
  static final StreamController<String> _messageStream = StreamController.broadcast();

  //Expose the stream 
   static Stream<String> get messageStream => _messageStream.stream;

  /// handle the recived [message] notifications  when the device is on background
  static Future _onBackgroundHandler(RemoteMessage message ) async {
      
      // send to the message stream the data we going to use on the stream  
      _messageStream.add(message.data['producto'] ?? 'No data');
  }

   /// handle the recived [message] notifications  when app is running
  static Future _onMessageHandler(RemoteMessage message ) async {
      
       // send to the message stream the data we going to use on the stream  
      _messageStream.add(message.data['producto'] ?? 'No data');
  }

   /// handle the recived [message] notifications  when notification was opened
  static Future _onMessageOpenedHandler(RemoteMessage message ) async {

       // send to the message stream the data we going to use on the stream  
      _messageStream.add(message.data['producto'] ?? 'No data');
  }

  static Future initializeApp() async {

      //Push notifications ---------------------------------------
    //Make sure firebase is initialized
     await Firebase.initializeApp(); 
     
     //Get the device token we need to send push notifications
     //you have to save this token somewhere
     token = await FirebaseMessaging.instance.getToken(); 

     //handlers
     FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);
     FirebaseMessaging.onMessage.listen(_onMessageHandler);
     FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedHandler);

     print('============== TOKEN ============');
     print(token);
     print('============== TOKEN ============');
  }

  /// is a good practice close streams to save memory, in this case we dont close the stream
  /// because is necessary be alive all time
  static closeStreams() {
    _messageStream.close();
  }

}