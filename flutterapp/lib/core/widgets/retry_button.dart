import 'package:flutter/material.dart';
import 'package:flutterapp/core/theme/pallete.dart';

Widget retryButton(VoidCallback onPressed) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Nenhuma notificação no momento'),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(backgroundColor: AppPallete.primary),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.refresh_rounded),
              SizedBox(width: 8),
              Text('Atualizar'),
            ],
          ),
        ),
      ],
    ),
  );
}
