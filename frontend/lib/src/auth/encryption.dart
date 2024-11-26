import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final holderKey =
    Key.fromUtf8(dotenv.env['ENCRYPTION_HOLDER_KEY'] ?? 'default_key');
final holderIv =
    IV.fromUtf8(dotenv.env['ENCRYPTION_HOLDER_IV'] ?? 'default_key');

final numberKey =
    Key.fromUtf8(dotenv.env['ENCRYPTION_NUMBER_KEY'] ?? 'default_key');
final numberIv =
    IV.fromUtf8(dotenv.env['ENCRYPTION_NUMBER_IV'] ?? 'default_key');

Map<String, Encrypted> encryptData(
    {required String accountHolder, required String accountNumber}) {
  final holderEncrypter = Encrypter(AES(holderKey));
  final numberEncrypter = Encrypter(AES(numberKey));

  final holderEncrypted = holderEncrypter.encrypt(accountHolder, iv: holderIv);
  final numberEncrypted = numberEncrypter.encrypt(accountHolder, iv: numberIv);

  // send it later using .base64
  return {"holder": holderEncrypted, "number": numberEncrypted};
}

Map<String, String> decryptData(
    {required Encrypted accountHolder, required Encrypted accountNumber}) {
  final holderEncrypter = Encrypter(AES(holderKey));
  final numberEncrypter = Encrypter(AES(numberKey));

  final holderDecrypted = holderEncrypter.decrypt(accountHolder, iv: holderIv);
  final numberDecrypted = numberEncrypter.decrypt(accountNumber, iv: numberIv);

  return {"holder": holderDecrypted, "number": numberDecrypted};
}
