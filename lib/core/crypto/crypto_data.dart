import 'dart:io';
import 'dart:typed_data';
import 'package:bip39_mnemonic/bip39_mnemonic.dart';
import 'package:pointycastle/export.dart';
import 'package:hex/hex.dart';
import 'dart:convert';

class CryptoData {
  static const int KEY_SIZE = 32; // AES-256
  static const int NONCE_SIZE = 12; // 96 bits
  static const int MAC_SIZE = 16; // 128 bits

  // 从助记词生成密钥
  static Uint8List keyFromMnemonic(String mnemonic) {
    // 从助记词生成种子
    final seed = Mnemonic.generate(
      Language.english,
      passphrase: mnemonic,
      entropyLength: 256,
    );
    // 使用HMAC-SHA256导出固定长度密钥
    final hmac = HMac(SHA256Digest(), 64);
    final params = KeyParameter(utf8.encode('aes_key'));
    hmac.init(params);
    final digest = hmac.process(Uint8List.fromList(seed.seed));
    return digest.sublist(0, KEY_SIZE);
  }

  // 生成随机 nonce
  static Uint8List generateNonce() {
    final secureRandom = SecureRandom('Fortuna')
      ..seed(KeyParameter(
          Uint8List.fromList(HEX.decode('000102030405060708090a0b0c0d0e0f'))));
    return secureRandom.nextBytes(NONCE_SIZE);
  }

  // 使用助记词加密数据
  static Map<String, Uint8List> encryptWithMnemonic(
      Uint8List data, String mnemonic) {
    final key = keyFromMnemonic(mnemonic);
    return encrypt(data, key);
  }

  // 使用助记词解密数据
  static Uint8List decryptWithMnemonic(Uint8List cipherText, Uint8List authTag,
      Uint8List nonce, String mnemonic) {
    final key = keyFromMnemonic(mnemonic);
    return decrypt(cipherText, authTag, nonce, key);
  }

  // 基础加密方法
  static Map<String, Uint8List> encrypt(Uint8List data, Uint8List key) {
    final nonce = generateNonce();
    final cipher = GCMBlockCipher(AESEngine());

    final params = AEADParameters(
      KeyParameter(key),
      MAC_SIZE * 8,
      nonce,
      Uint8List(0),
    );

    cipher.init(true, params);

    final cipherText = Uint8List(cipher.getOutputSize(data.length));
    final len = cipher.processBytes(data, 0, data.length, cipherText, 0);
    cipher.doFinal(cipherText, len);

    return {
      'cipherText': cipherText.sublist(0, data.length),
      'authTag': cipherText.sublist(data.length),
      'nonce': nonce,
    };
  }

  // 基础解密方法
  static Uint8List decrypt(
      Uint8List cipherText, Uint8List authTag, Uint8List nonce, Uint8List key) {
    final cipher = GCMBlockCipher(AESEngine());

    final params = AEADParameters(
      KeyParameter(key),
      MAC_SIZE * 8,
      nonce,
      Uint8List(0),
    );

    cipher.init(false, params);

    final plainText =
        Uint8List(cipher.getOutputSize(cipherText.length + authTag.length));
    final combined = Uint8List.fromList(cipherText + authTag);
    final len = cipher.processBytes(combined, 0, combined.length, plainText, 0);
    cipher.doFinal(plainText, len);

    return plainText;
  }
}
