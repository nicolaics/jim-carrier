import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const _storage = FlutterSecureStorage();

  // Save token
  static Future<void> storeToken(String token) async {
    await _storage.write(key: 'token', value: token);
    print("stored token");
  }

  static Future<void> storeFcmToken(String? fcmToken) async {
    await _storage.write(key: 'fcmToken', value: fcmToken);
    print("stored token");
  }

  // Retrieve token
  static Future<String> getToken() async {
    return await _storage.read(key: 'token') ?? '';
  }

  // Retrieve token
  static Future<String> getFcmToken() async {
    return await _storage.read(key: 'fcmToken') ?? '';
  }

  // Delete token
  static Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
    print("deleted token");
  }
}
