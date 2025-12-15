import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mylogger/mylogger.dart';

import 'router/router_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MyAppLogger().init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(useMaterial3: true),
      
    );
  }
}
