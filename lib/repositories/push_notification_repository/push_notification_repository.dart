

import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

 
class PushNotificationRepository {

    final FirebaseMessaging _firebaseMessaging;
    String? _token;

    /// Allow  emit a value in order to suscribe to notification messages
    static final StreamController<String> _messageStream = StreamController.broadcast();

    //Expose the stream 
    Stream<String> get messageStream => _messageStream.stream;


    //Crate tihe firebase messaging instance on the constructor
    PushNotificationRepository({
      FirebaseMessaging? firebaseMessaging,
    }): _firebaseMessaging = firebaseMessaging ?? FirebaseMessaging.instance;
  

  /// handle the recived [message] notifications  when the device is on background
  /// static to convert a top-level function using by background isolate
  static Future _onBackgroundHandler(RemoteMessage message ) async {
      
      // send to the message stream the data we going to use on the stream  
      _messageStream.add(message.data['producto'] ?? 'No data');
  }

   /// handle the recived [message] notifications  when app is running
 Future _onMessageHandler(RemoteMessage message ) async {
      
       // send to the message stream the data we going to use on the stream  
      _messageStream.add(message.data['producto'] ?? 'No data');
  }

   /// handle the recived [message] notifications  when notification was opened
  Future _onMessageOpenedHandler(RemoteMessage message ) async {

       // send to the message stream the data we going to use on the stream  
      _messageStream.add(message.data['producto'] ?? 'No data');
  }

  Future initializeApp() async {

    //Make sure firebase is initialized
     await Firebase.initializeApp(); 
     
     //Get the device token we need to send push notifications
     //you have to save this token somewhere
     _token = await FirebaseMessaging.instance.getToken(); 

     //handlers
     FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);
     FirebaseMessaging.onMessage.listen(_onMessageHandler);
     FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedHandler);

     log('=================== TOKEN =================');
     log(_token.toString());
     log('===========================================');
  }

  // Get any messages which caused the application to open from
  // a terminated state.
  Future<RemoteMessage?> getInitialMessage() async {
    return _firebaseMessaging.getInitialMessage();
  }
   
   
  /// is a good practice close streams to save memory, in this case we dont close the stream
  /// because is necessary be alive all time
  closeStreams() {
    _messageStream.close();
  }
   

}