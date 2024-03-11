import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

enum SecureStorageKeys {
  password,
}

@singleton
class SecureStorageManager {
  final storage = const FlutterSecureStorage();

  Future<void> write(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<String> read(String key) async {
    final result = await storage.read(key: key);
    return result ?? '';
  }
}
