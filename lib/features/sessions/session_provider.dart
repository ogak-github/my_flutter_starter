import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/db/secure_storage.dart';

part 'session_provider.g.dart';

class SessionData {
  final bool isLoggedIn;
  final String? token;
  final UserData? userData;

  const SessionData({
    required this.isLoggedIn,
    this.token,
    required this.userData,
  });
}

class UserData {
  final String? fullName;
  final String? email;
  final String? image;

  const UserData({this.fullName, this.email, this.image});
}

@Riverpod(keepAlive: true)
class Session extends _$Session {
  @override
  Future<SessionData> build() async {
    final secureStorage = ref.watch(secureStorageProvider);
    final token = await secureStorage.read(key: 'token');
    final fullName = await secureStorage.read(key: 'full_name');
    final email = await secureStorage.read(key: 'email');
    final image = await secureStorage.read(key: 'image');
    return SessionData(
      isLoggedIn: token != null,
      token: token,
      userData: UserData(fullName: fullName, email: email, image: image),
    );
  }

  void updateSessionData(SessionData sessionData) {
    state = AsyncValue.data(sessionData);
  }

  Future<void> clearSessionData() async {
    state = const AsyncValue.data(
      SessionData(isLoggedIn: false, token: null, userData: null),
    );
  }
}
