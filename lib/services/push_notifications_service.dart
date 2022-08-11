//SHA1 - DB:19:85:52:57:0F:80:D7:CD:BA:2C:7A:8D:E2:1A:9F:A8:00:6A:9B

import 'dart:async';

import 'package:push_notif_test/repositories/push_notification_repository/push_notification_repository.dart';

class PushNotificationService {

    final PushNotificationRepository _pushNotificationRepository;

    //constructor ready for dependency injection
    PushNotificationService({
      required PushNotificationRepository pushNotificationRepository
    }): _pushNotificationRepository = pushNotificationRepository;


    //Stream for subcribe and react to notification data
    Stream<String> get messageStream => _pushNotificationRepository.messageStream;

    // Initialize push notification service
    Future<void> initializeApp() async {
        _pushNotificationRepository.initializeApp();
    }

    // Get any messages which caused the application to open from
    // a terminated state.
    Future getInitialMessage() async {
      return  _pushNotificationRepository.getInitialMessage();
    }
   


    
 
}

