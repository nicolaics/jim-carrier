// import 'dart:math';
// import 'dart:typed_data';
// ignore_for_file: implementation_imports

import 'package:encrypt/encrypt.dart' as enc;
import 'package:jim/src/auth/secure_storage.dart';
import 'package:pointycastle/src/platform_check/platform_check.dart';
import "package:pointycastle/export.dart";

class RsaEncryption {
  // static Future<AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>> generateRSAkeyPair(
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

    await StorageService.storeRSAPrivateKeyM(myPrivate.modulus.toString());
    await StorageService.storeRSAPrivateKeyE(
        myPrivate.privateExponent.toString());
    await StorageService.storeRSAPrivateKeyP(myPrivate.p.toString());
    await StorageService.storeRSAPrivateKeyQ(myPrivate.q.toString());

    await StorageService.storeRSAPublicKeyM(myPublic.modulus.toString());
    await StorageService.storeRSAPublicKeyE(myPublic.exponent.toString());
  }

  static Future<Map<String, String>> decryptBankdDetails({required dynamic accountNumber, required dynamic accountHolder}) async {
    final getPublicM = await StorageService.getRSAPublicKeyM();
    final getPublicE = await StorageService.getRSAPublicKeyE();

    final getPrivateM = await StorageService.getRSAPrivateKeyM();
    final getPrivateE = await StorageService.getRSAPrivateKeyE();
    final getPrivateP = await StorageService.getRSAPrivateKeyP();
    final getPrivateQ = await StorageService.getRSAPrivateKeyQ();

    final myPublic =
        RSAPublicKey(BigInt.parse(getPublicM), BigInt.parse(getPublicE));

    final myPrivate = RSAPrivateKey(
        BigInt.parse(getPrivateM),
        BigInt.parse(getPrivateE),
        BigInt.parse(getPrivateP),
        BigInt.parse(getPrivateQ));

    final encrypter =
        enc.Encrypter(enc.RSA(publicKey: myPublic, privateKey: myPrivate));

    final accountNumberEncrypted = enc.Encrypted.fromBase64(accountNumber);
    final accountHolderEncrypted = enc.Encrypted.fromBase64(accountHolder);

    final accountNumberDecrypted = encrypter.decrypt(accountNumberEncrypted);
    final accountHolderDecrypted = encrypter.decrypt(accountHolderEncrypted);

    return {
      "number": accountNumberDecrypted,
      "holder": accountHolderDecrypted
    };
  }

  static Future<Map<String, String>> getPublicKey() async {
    final getPublicM = await StorageService.getRSAPublicKeyM();
    final getPublicE = await StorageService.getRSAPublicKeyE();
    
    return {
      "m": getPublicM,
      "e": getPublicE
    };
  }
}
