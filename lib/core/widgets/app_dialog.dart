import 'package:flutter/material.dart';

Future<bool> showLogoutDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white70,
          ),
          onPressed: () async {
            // Close dialog dulu
            Navigator.pop(dialogContext, true);
          },
          child: const Text('Logout'),
        ),
      ],
    ),
  );
  return result ?? false;
}
