import 'package:encrypt/encrypt.dart';

class EncryptionHelper {
  final String key;

  EncryptionHelper(this.key);

  String encrypt(String text) {
    final aesKey = Key.fromUtf8(key.padRight(16, ' ').substring(0, 16));
    final iv = IV.fromLength(16); // Menghasilkan IV acak

    final encrypter = Encrypter(AES(aesKey));
    final encrypted = encrypter.encrypt(text, iv: iv);

    // Gabungkan IV dan teks terenkripsi sebagai satu string untuk disimpan
    return '${iv.base64}:${encrypted.base64}';
  }

  String decrypt(String encryptedTextWithIv) {
    final aesKey = Key.fromUtf8(key.padRight(16, ' ').substring(0, 16));

    // Pisahkan IV dan teks terenkripsi
    final parts = encryptedTextWithIv.split(':');
    if (parts.length != 2) {
      throw ArgumentError('Invalid encrypted text format');
    }

    final iv = IV.fromBase64(parts[0]); // Ambil IV dari bagian pertama
    final encryptedText = parts[1]; // Ambil teks terenkripsi dari bagian kedua

    final encrypter = Encrypter(AES(aesKey));
    try {
      final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
      return decrypted;
    } catch (e) {
      throw ArgumentError('Invalid or corrupted encrypted text: $e');
    }
  }
}
