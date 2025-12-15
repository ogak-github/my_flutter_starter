import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_flutter_starter/core/db/secure_storage.dart';
import 'package:mylogger/mylogger.dart';

import '../../../core/api/base_api.dart';

abstract class AuthRepository {
  Future<Map<String, dynamic>> login(String username, String password);
  Future<void> logout() async {}
}

class AuthRepositoryImpl implements AuthRepository {
  final BaseApi _baseApi;
  final SecureStorage _secureStorage;

  AuthRepositoryImpl(this._baseApi, this._secureStorage);

  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    final api = await _baseApi.apiClient.post(
      '/auth/login',
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: {'username': username, 'password': password},
    );

    MyLogger("AuthRepository").i("Login response: ${api.data}");
    await _secureStorage.write(key: 'token', value: api.data['accessToken']);
    await _secureStorage.write(
      key: 'full_name',
      value: "${api.data['firstName']} ${api.data['lastName']}",
    );
    await _secureStorage.write(key: 'email', value: api.data['email']);
    await _secureStorage.write(
      key: 'image',
      value: api.data['image'].toString(),
    );

    return api.data;
  }

  @override
  Future<void> logout() async {
    await _secureStorage.delete(key: 'token');
    await _secureStorage.delete(key: 'full_name');
    await _secureStorage.delete(key: 'email');
    await _secureStorage.delete(key: 'image');
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    ref.read(baseApiProvider),
    ref.read(secureStorageProvider),
  ),
);
