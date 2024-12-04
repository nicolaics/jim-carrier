// ignore_for_file: implementation_imports

import 'package:encrypt/encrypt.dart' as enc;
import 'package:jim/src/auth/secure_storage.dart';
import 'package:pointycastle/src/platform_check/platform_check.dart';
import "package:pointycastle/export.dart";

class RsaEncryption {
  static Future<void> generateRSAkeyPair({int bitLength = 2048}) async {
    // Create an RSA key generator and initialize it
    final keyGen = RSAKeyGenerator();

    final secureRandom = SecureRandom('Fortuna')
      ..seed(
          KeyParameter(Platform.instance.platformEntropySource().getBytes(32)));

    keyGen.init(ParametersWithRandom(
        RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 64),
        secureRandom));

    // Use the generator

    final pair = keyGen.generateKeyPair();

    // Cast the generated key pair into the RSA key types
    final myPublic = pair.publicKey as RSAPublicKey;
    final myPrivate = pair.privateKey as RSAPrivateKey;

    await StorageService.storeRSAPrivateKey(
        myPrivate.modulus.toString(),
        myPrivate.privateExponent.toString(),
        myPrivate.p.toString(),
        myPrivate.q.toString());

    await StorageService.storeRSAPublicKey(
        myPublic.modulus.toString(), myPublic.exponent.toString());
  }

  static Future<Map<String, String>> decryptBankdDetails(
      {required dynamic accountNumber, required dynamic accountHolder}) async {
    final getPublicKey = await StorageService.getRSAPublicKey();
    final getPrivateKey = await StorageService.getRSAPrivateKey();

    final myPublic =
        RSAPublicKey(BigInt.parse(getPublicKey['m']!), BigInt.parse(getPublicKey['e']!));

    final myPrivate = RSAPrivateKey(
        BigInt.parse(getPrivateKey['m']!),
        BigInt.parse(getPrivateKey['e']!),
        BigInt.parse(getPrivateKey['p']!),
        BigInt.parse(getPrivateKey['q']!));

    final encrypter = enc.Encrypter(enc.RSA(
        publicKey: myPublic,
        privateKey: myPrivate,
        encoding: enc.RSAEncoding.OAEP,
        digest: enc.RSADigest.SHA256));

    print("fromBase64 $accountNumber");

    final accountNumberEncrypted = enc.Encrypted.fromBase64(accountNumber);
    final accountHolderEncrypted = enc.Encrypted.fromBase64(accountHolder);

    print("fromBase64 $accountNumberEncrypted");

    final accountNumberDecrypted = encrypter.decrypt(accountNumberEncrypted);
    final accountHolderDecrypted = encrypter.decrypt(accountHolderEncrypted);

    return {"number": accountNumberDecrypted, "holder": accountHolderDecrypted};
  }
}
