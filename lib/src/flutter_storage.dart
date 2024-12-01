import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const _storage = FlutterSecureStorage();

  // Save token
  static Future<void> storeAccessToken(String token) async {
    await _storage.write(key: 'access_token', value: token);
  }

  static Future<void> storeRefreshToken(String token) async {
    await _storage.write(key: 'refresh_token', value: token);
  }

  static Future<void> storeFcmToken(String? fcmToken) async {
    await _storage.write(key: 'fcmToken', value: fcmToken);
  }

  // Retrieve token
  static Future<String> getAccessToken() async {
    return await _storage.read(key: 'access_token') ?? '';
  }

  static Future<String> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token') ?? '';
  }

  // Retrieve token
  static Future<String> getFcmToken() async {
    return await _storage.read(key: 'fcmToken') ?? '';
  }

  // Delete token
  static Future<void> deleteTokens() async {
    await _storage.delete(key: 'token');
    print("deleted token");
  }
}
