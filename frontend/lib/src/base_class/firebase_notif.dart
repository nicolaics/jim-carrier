import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:jim/src/flutter_storage.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

// TODO: handle message when in app
Future<void> _showMessage(RemoteMessage message) async {
  // Display a local notification or a dialog with the message
  print(
      'Title: ${message.notification?.title}, Body: ${message.notification?.body}');

  // You can integrate a dialog or notification package here for UI
  print('Payload: ${message.data}');
}

Future<void> _handleNotificationClick(RemoteMessage message) async {
  if (message.data['order_id'] != null) {
    Map<String, String> order = {
      "id": message.data['order_id']
    };
  }
}

class FirebaseNotification {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.setAutoInitEnabled(false);
    await _firebaseMessaging.requestPermission();

    final fcmToken = await _firebaseMessaging.getToken();
    print('FCM Token: $fcmToken');

    await StorageService.storeFcmToken(fcmToken);

    // TODO: Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message received: ${message.notification?.title}');
      _showMessage(message);
    });

    // TODO: Handle background messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked when app opened: ${message.notification?.title}');
      _showMessage(message);
    });

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
