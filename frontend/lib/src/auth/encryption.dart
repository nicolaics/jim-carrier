import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final holderKey =
    enc.Key.fromUtf8(dotenv.env['ENCRYPTION_HOLDER_KEY'] ?? 'default_key');
final holderIv =
    enc.IV.fromUtf8(dotenv.env['ENCRYPTION_HOLDER_IV'] ?? 'default_key');

final numberKey =
    enc.Key.fromUtf8(dotenv.env['ENCRYPTION_NUMBER_KEY'] ?? 'default_key');
final numberIv =
    enc.IV.fromUtf8(dotenv.env['ENCRYPTION_NUMBER_IV'] ?? 'default_key');


Map<String, enc.Encrypted> encryptData(
    {required String accountHolder, required String accountNumber}) {
  print(dotenv.env['ENCRYPTION_HOLDER_KEY'] ?? 'default_key');
  print(holderIv);

  final holderEncrypter = enc.Encrypter(enc.AES(holderKey));
  print("hoho");
  final numberEncrypter = enc.Encrypter(enc.AES(numberKey));

  print(accountHolder);
  final holderEncrypted = holderEncrypter.encrypt(accountHolder, iv: holderIv);
  print("hoho");
  final numberEncrypted = numberEncrypter.encrypt(accountHolder, iv: numberIv);

  // send it later using .base64
  return {"holder": holderEncrypted, "number": numberEncrypted};
}

Map<String, String> decryptData(
    {required enc.Encrypted accountHolder, required enc.Encrypted accountNumber}) {
  final holderEncrypter = enc.Encrypter(enc.AES(holderKey));
  final numberEncrypter = enc.Encrypter(enc.AES(numberKey));

  final holderDecrypted = holderEncrypter.decrypt(accountHolder, iv: holderIv);
  final numberDecrypted = numberEncrypter.decrypt(accountNumber, iv: numberIv);

  return {"holder": holderDecrypted, "number": numberDecrypted};
}
