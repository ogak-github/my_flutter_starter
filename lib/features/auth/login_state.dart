import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../sessions/session_provider.dart';
import 'repository/auth_repository.dart';

part 'login_state.g.dart';

@riverpod
class LoginState extends _$LoginState {
  @override
  Future<void> build() async {
    ref.onDispose(() {
      ref.invalidate(sessionProvider);
    });
  }

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();
    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.login(username, password);
      /* final sessionData = SessionData(
        isLoggedIn: true,
        token: response["token"], // Changed from accessToken to token
        userData: UserData(
          fullName:
              "${response["firstName"]} ${response["lastName"]}", // Match repo format
          email: response["email"],
          image: response["image"]?.toString(),
        ),
      ); */
      /*     final session = ref.read(sessionProvider.notifier);
      session.updateSessionData(sessionData); */
      ref.invalidate(sessionProvider);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.logout();
      final session = ref.read(sessionProvider.notifier);
      await session.clearSessionData();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
