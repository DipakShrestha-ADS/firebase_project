import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptDecryptServices {
  final key = encrypt.Key.fromLength(32);
  final iv = encrypt.IV.fromLength(8);

  encrypt.Encrypter getEncrypter() {
    return encrypt.Encrypter(encrypt.Salsa20(key));
  }

  String encryptData({required String data}) {
    final encrypted = getEncrypter().encrypt(data, iv: iv);
    return encrypted.base64;
  }

  String decryptData({required String data}) {
    return getEncrypter().decrypt64(data, iv: iv);
  }
}
