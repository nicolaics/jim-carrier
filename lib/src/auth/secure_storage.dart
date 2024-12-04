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

  static Future<void> storeTempEmail(String email) async {
    await _storage.write(key: 'email', value: email);
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
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    print("deleted token");
  }

  static Future<void> storeRSAPrivateKey(String? privateKeyM,
      String? privateKeyE, String? privateKeyP, String? privateKeyQ) async {
    await _storage.write(key: 'private_key_m', value: privateKeyM);
    await _storage.write(key: 'private_key_e', value: privateKeyE);
    await _storage.write(key: 'private_key_p', value: privateKeyP);
    await _storage.write(key: 'private_key_q', value: privateKeyQ);
  }

  static Future<void> storeRSAPublicKey(String? publicKeyM, String? publicKeyE) async {
    await _storage.write(key: 'public_key_m', value: publicKeyM);
    await _storage.write(key: 'public_key_e', value: publicKeyE);
  }

  static Future<Map<String, String>> getRSAPrivateKey() async {
    final m = await _storage.read(key: 'private_key_m') ?? '';
    final e = await _storage.read(key: 'private_key_e') ?? '';
    final p = await _storage.read(key: 'private_key_p') ?? '';
    final q = await _storage.read(key: 'private_key_q') ?? '';

    return {
      "m": m,
      "e": e,
      "p": p,
      "q": q
    };
  }

  static Future<Map<String, String>> getRSAPublicKey() async {
    final m = await _storage.read(key: 'public_key_m') ?? '';
    final e = await _storage.read(key: 'public_key_e') ?? '';
    
    return {"m": m, "e": e};
  }

  static Future<String> getTempEmail() async {
    return await _storage.read(key: 'email') ?? '';
  }

  static Future<void> deleteTempEmail() async {
    await _storage.delete(key: 'email');
  }
}
