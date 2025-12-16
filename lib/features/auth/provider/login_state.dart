import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../session/provider/session_provider.dart';
import '../repository/auth_repository.dart';

part 'login_state.g.dart';

@riverpod
class LoginState extends _$LoginState {
  @override
  Future<void> build() async {}

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();
    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.login(username, password);
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
      await authRepository.logout(); // Clear dari secure storage

      // Langsung update session state (ini yang trigger ref.listen di router)
      ref.read(sessionProvider.notifier).clearSessionData();
    } catch (e, st) {
      if (!ref.mounted) return;
      state = AsyncValue.error(e, st);
    }
  }
}
