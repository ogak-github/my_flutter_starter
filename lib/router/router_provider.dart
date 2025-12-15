import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/auth/login_screen.dart';
import '../features/home_screen.dart';
import '../features/sessions/session_provider.dart';
import 'routes.dart';

/// Listenable yang bisa dipake buat trigger refresh router
class SessionChangeNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}

final sessionChangeNotifier = SessionChangeNotifier();

GoRouter router(Ref ref) {
  // Listen ke session changes dan trigger router refresh
  ref.listen(sessionProvider, (previous, next) {
    sessionChangeNotifier.notify();
  });

  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: Routes.home,
    refreshListenable: sessionChangeNotifier,
    redirect: (context, state) => redirectFn(context, state, ref),
    routes: <RouteBase>[
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
}

FutureOr<String?> redirectFn(
  BuildContext context,
  GoRouterState state,
  Ref ref,
) {
  final session = ref.read(sessionProvider);

  return session.when(
    data: (sessionData) {
      final isLoggedIn = sessionData.isLoggedIn;
      final isGoingToLogin = state.matchedLocation == Routes.login;

      // Kalo udah login tapi mau ke login page, redirect ke home
      if (isLoggedIn && isGoingToLogin) {
        return Routes.home;
      }

      // Kalo belum login dan bukan ke login page, redirect ke login
      if (!isLoggedIn && !isGoingToLogin) {
        return Routes.login;
      }

      return null;
    },
    loading: () => null,
    error: (_, __) => Routes.login,
  );
}

final routerProvider = Provider<GoRouter>((ref) => router(ref));
