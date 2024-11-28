import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:jim/src/flutter_storage.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseNotification {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.setAutoInitEnabled(false);
    await _firebaseMessaging.requestPermission();

    final fcmToken = await _firebaseMessaging.getToken();
    print('FCM Token: $fcmToken');

    await StorageService.storeFcmToken(fcmToken);

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}