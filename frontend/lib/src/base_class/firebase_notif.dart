import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:jim/src/api/order.dart';
import 'package:jim/src/flutter_storage.dart';
import 'package:jim/src/screens/order/confirm_order.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');

}

Future<void> _showMessage(RemoteMessage message) async {
  // Display a local notification or a dialog with the message
  print(
      'Title: ${message.notification?.title}, Body: ${message.notification?.body}');

  // You can integrate a dialog or notification package here for UI
  print('Payload: ${message.data}');
  
  if (message.data['type'] == 'confirm_order') {
    if (message.data['order_id'] != null) {
      Map<String, String> order = {
        "id": message.data['order_id']
      };

      dynamic orderData = getOrderDetail(api: '/order/carrier/detail', id: int.parse(order['id'] ?? '0'));
      Get.to(() => ConfirmOrder(orderData: orderData));
    }
  }
}

Future<void> _handleNotificationClick(RemoteMessage message) async {
  if (message.data['type'] == 'confirm_order') {
    if (message.data['order_id'] != null) {
      Map<String, String> order = {
        "id": message.data['order_id']
      };

      dynamic orderData = getOrderDetail(api: '/order/carrier/detail', id: int.parse(order['id'] ?? '0'));
      Get.to(() => ConfirmOrder(orderData: orderData));
    }
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

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message received: ${message.notification?.title}');
      _showMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked when app opened: ${message.notification?.title}');
      _showMessage(message);
    });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        _handleNotificationClick(message);
      }
    });

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
