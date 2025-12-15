import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_flutter_starter/features/auth/login_state.dart';

import 'sessions/session_provider.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        actions: [
          IconButton(
            onPressed: () async {
              if (context.mounted) {
                await ref.read(loginStateProvider.notifier).logout();
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          spacing: 16,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                session.value?.userData?.image ?? "",
              ),
            ),
            Text(session.value?.userData?.fullName ?? ""),
            Text(session.value?.userData?.email ?? ""),

            //Text(session.value?.isLoggedIn.toString() ?? ""),
          ],
        ),
      ),
    );
  }
}
