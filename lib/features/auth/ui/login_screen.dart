import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_flutter_starter/features/session/provider/session_provider.dart';

import '../provider/login_state.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: _LoginForm(),
        ),
      ),
    );
  }
}

class _LoginForm extends HookConsumerWidget {
  _LoginForm({super.key});

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginStateProvider);
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final obscureText = useState(true);
    final hintStyle = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(color: Theme.of(context).disabledColor);
    final errorStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
      color: Theme.of(context).colorScheme.error,
    );
    return Form(
      key: formKey,
      child: Column(
        spacing: 16,
        children: [
          TextFormField(
            controller: usernameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Username",
              hintText: "Enter your username",
              hintStyle: hintStyle,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your username";
              }

              return null;
            },
          ),
          TextFormField(
            controller: passwordController,
            obscureText: obscureText.value,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Password",
              hintText: "Enter your password",
              suffixIcon: IconButton(
                onPressed: () {
                  obscureText.value = !obscureText.value;
                },
                icon: Icon(
                  obscureText.value ? Icons.visibility : Icons.visibility_off,
                ),
              ),
              hintStyle: hintStyle,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter password";
              }

              return null;
            },
          ),
          loginState.hasError
              ? Text(loginState.error.toString(), style: errorStyle)
              : const SizedBox.shrink(),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: ElevatedButton(
              onPressed: loginState.isLoading
                  ? null
                  : () async {
                      if (formKey.currentState!.validate()) {
                        final loginState = ref.read(
                          loginStateProvider.notifier,
                        );
                        await loginState.login(
                          usernameController.text.trim(),
                          passwordController.text.trim(),
                        );
                        ref.invalidate(sessionProvider);
                      }
                    },
              child: loginState.isLoading
                  ? const Text("Authenticating...")
                  : const Text("Login"),
            ),
          ),
        ],
      ),
    );
  }
}
