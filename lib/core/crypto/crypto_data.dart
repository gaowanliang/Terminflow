import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:bip39_mnemonic/bip39_mnemonic.dart';
import 'package:flutter/foundation.dart';
import 'package:pointycastle/export.dart';
import 'dart:convert';

class CryptoData {
  static const int KEY_SIZE = 32; // AES-256
  static const int NONCE_SIZE = 12; // 96 bits
  static const int MAC_SIZE = 16; // 128 bits

  // 从助记词生成密钥
  static Uint8List keyFromMnemonic(String mnemonic) {
    // 直接使用 HMAC-SHA256 从助记词生成密钥
    final hmac = HMac(SHA256Digest(), 64);
    final params = KeyParameter(utf8.encode('terminflow_salt')); // 使用应用特定的盐值
    hmac.init(params);

    // 将助记词转换为字节数组作为输入
    final mnemonicBytes = utf8.encode(mnemonic);
    final digest = hmac.process(Uint8List.fromList(mnemonicBytes));

    return digest.sublist(0, KEY_SIZE);
  }

  // 生成随机 nonce
  static Uint8List generateNonce() {
    final secureRandom = FortunaRandom();

    // 使用系统随机源初始化
    final random = Random.secure();
    final seed = Uint8List(32);
    for (var i = 0; i < 32; i++) {
      seed[i] = random.nextInt(256);
    }

    secureRandom.seed(KeyParameter(seed));
    return secureRandom.nextBytes(NONCE_SIZE);
  }

  // 使用助记词加密数据
  static Map<String, Uint8List> encryptWithMnemonic(
      Uint8List data, String mnemonic) {
    final key = keyFromMnemonic(mnemonic);
    debugPrint('key: $key');
    return encrypt(data, key);
  }

  // 使用助记词解密数据
  static Uint8List decryptWithMnemonic(Uint8List cipherText, Uint8List authTag,
      Uint8List nonce, String mnemonic) {
    final key = keyFromMnemonic(mnemonic);
    debugPrint('key: $key');
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
