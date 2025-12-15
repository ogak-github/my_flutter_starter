import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mylogger/mylogger.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  Future<void> write({required String key, String? value}) async {
    if (value == null) return; // Skip kalo value null
    try {
      await _storage.write(key: key, value: value);
      MyLogger("SecureStorage").d("Wrote $key: $value");
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> read({required String key}) async {
    try {
      final String? value = await _storage.read(key: key);
      MyLogger("SecureStorage").d("Read $key: $value");
      return value;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete({required String key}) async {
    try {
      await _storage.delete(key: key);
      MyLogger("SecureStorage").d("Deleted $key");
    } catch (e) {
      rethrow;
    }
  }
}

final secureStorageProvider = Provider<SecureStorage>((ref) => SecureStorage());
