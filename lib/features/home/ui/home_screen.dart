import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mylogger/mylogger.dart';

import '../../../core/widgets/app_dialog.dart';
import '../../session/provider/session_provider.dart';
import '../../auth/provider/login_state.dart';

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
              final result = await showLogoutDialog(context);
              MyLogger("Logout dialog result").d("$result");

              /// If result is true, then logout, else do nothing
              if (result) {
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
            if (session.value?.userData?.image != null &&
                session.value!.userData!.image!.isNotEmpty)
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(session.value!.userData!.image!),
              )
            else
              const CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
            Text(session.value?.userData?.fullName ?? ""),
            Text(session.value?.userData?.email ?? ""),
          ],
        ),
      ),
    );
  }
}
