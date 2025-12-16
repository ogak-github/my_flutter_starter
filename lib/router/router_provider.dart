import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mylogger/mylogger.dart';

import '../features/auth/ui/login_screen.dart';
import '../features/home/ui/home_screen.dart';
import '../features/session/provider/session_provider.dart';
import '../features/splash/ui/splash_screen.dart';
import 'routes.dart';

/// Listenable yang bisa dipake buat trigger refresh router
class SessionChangeNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}

final sessionChangeNotifier = SessionChangeNotifier();

GoRouter router(Ref ref) {
  // Listen ke session changes dan trigger router refresh
  ref.listen(sessionProvider, (previous, next) {
    MyLogger("Router").d("Session changed: $next");
    sessionChangeNotifier.notify();
  });

  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: Routes.splash, // Start dari splash dulu
    refreshListenable: sessionChangeNotifier,
    redirect: (context, state) => redirectFn(context, state, ref),
    routes: <RouteBase>[
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
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

/// Fungsi redirect untuk GoRouter
/// Kalo udah login, redirect ke home (kecuali udah di home)
/// Kalo belum login, redirect ke login (kecuali udah di login)
/// Kalo udah loading, redirect ke splash (kecuali udah di splash) untuk menghindari race condition antara login screen dan home screen
FutureOr<String?> redirectFn(
  BuildContext context,
  GoRouterState state,
  Ref ref,
) {
  final session = ref.read(sessionProvider);
  final currentPath = state.matchedLocation;

  return session.when(
    data: (sessionData) {
      final isLoggedIn = sessionData.isLoggedIn;

      MyLogger(
        "Router",
      ).d("Redirect check - isLoggedIn: $isLoggedIn, path: $currentPath");

      // Kalo udah login, redirect ke home (kecuali udah di home)
      if (isLoggedIn) {
        if (currentPath == Routes.home) return null;
        return Routes.home;
      }

      // Kalo belum login, redirect ke login (kecuali udah di login)
      if (currentPath == Routes.login) return null;
      return Routes.login;
    },
    loading: () {
      // Masih loading - stay di splash, atau redirect ke splash kalo belum di sana
      if (currentPath == Routes.splash) return null;
      return Routes.splash;
    },
    error: (_, __) => Routes.login,
  );
}

final routerProvider = Provider<GoRouter>((ref) => router(ref));
