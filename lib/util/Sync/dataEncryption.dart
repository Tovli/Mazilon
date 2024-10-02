import 'package:encrypt/encrypt.dart';
import 'dart:convert';

//this is the funciton we use to encrypt the data
Map<String, dynamic> encrypting(plainText) {
  //this is the size in bytes. meaning 256 and 128 bits respectively thus making this secure
  final key = Key.fromSecureRandom(32);
  final iv = IV.fromSecureRandom(16);
  final encrypter = Encrypter(AES(key));

  final encrypted = encrypter.encrypt(plainText, iv: iv);

  return {
    "key": key.base64,
    "encryptedData": encrypted.base64,
    "iv": iv.base64
  };
}

String decrypting(key, iv, encrypted) {
  var x = base64.decode(key);

  final encrypter = Encrypter(AES(Key(x)));

  final decrypted = encrypter.decrypt(Encrypted.fromBase64(encrypted),
      iv: IV(base64.decode(iv)));
  return decrypted;
}
