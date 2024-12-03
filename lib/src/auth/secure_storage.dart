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
    await _storage.write(key: 'fcm_token', value: fcmToken);
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
    return await _storage.read(key: 'fcm_token') ?? '';
  }

  // Delete token
  static Future<void> deleteTokens() async {
    await _storage.delete(key: 'token');
    print("deleted token");
  }

  static Future<void> storeRSAPrivateKeyM(String? privateKeyM) async {
    await _storage.write(key: 'private_key_m', value: privateKeyM);
  }

  static Future<void> storeRSAPrivateKeyE(String? privateKeyE) async {
    await _storage.write(key: 'private_key_e', value: privateKeyE);
  }

  static Future<void> storeRSAPrivateKeyP(String? privateKeyP) async {
    await _storage.write(key: 'private_key_p', value: privateKeyP);
  }

  static Future<void> storeRSAPrivateKeyQ(String? privateKeyQ) async {
    await _storage.write(key: 'private_key_q', value: privateKeyQ);
  }

  static Future<void> storeRSAPublicKeyM(String? publicKeyM) async {
    await _storage.write(key: 'public_key_m', value: publicKeyM);
  }

  static Future<void> storeRSAPublicKeyE(String? publicKeyE) async {
    await _storage.write(key: 'public_key_e', value: publicKeyE);
  }

  static Future<String> getRSAPrivateKeyM() async {
    return await _storage.read(key: 'private_key_m') ?? '';
  }

  static Future<String> getRSAPrivateKeyE() async {
    return await _storage.read(key: 'private_key_e') ?? '';
  }

  static Future<String> getRSAPrivateKeyP() async {
    return await _storage.read(key: 'private_key_p') ?? '';
  }

  static Future<String> getRSAPrivateKeyQ() async {
    return await _storage.read(key: 'private_key_q') ?? '';
  }

  static Future<String> getRSAPublicKeyM() async {
    return await _storage.read(key: 'public_key_m') ?? '';
  }

  static Future<String> getRSAPublicKeyE() async {
    return await _storage.read(key: 'public_key_e') ?? '';
  }
}
