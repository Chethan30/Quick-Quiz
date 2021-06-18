import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class PasswordUtils{
  final Random _RANDOM = new Random.secure();
  final String _ALPHABET = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

  String getSalt(int length) {
    String returnValue="a";
    for (int i = 0; i < length; i++) {
      returnValue= returnValue + _ALPHABET[(_RANDOM.nextInt(_ALPHABET.length))];
    }
    return returnValue;
  }

  List hash(String password){
    String salt = getSalt(128);
    String saltedPassword = salt + password;
    var bytes = utf8.encode(saltedPassword);
    var hash = sha256.convert(bytes);
    String hash1=hash.toString();
    return [hash1, salt];
  }

  bool verify(String password, String salt, String hashed){
    String saltedPassword = salt + password;
    var bytes = utf8.encode(saltedPassword);
    var hash = sha256.convert(bytes);
    String hash1=hash.toString();
    if(hash1==hashed)
      return true;
    return false;
  }


}