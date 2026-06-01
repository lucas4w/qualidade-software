import 'package:flutter/material.dart';

import 'package:flutterapp/core/theme/pallete.dart';

Widget errorWidget(
  String? content,
  VoidCallback retryCallback,
) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 64, color: Colors.grey),
        const SizedBox(height: 16),
        Text(content ?? 'Falha ao carregar os dados'),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: retryCallback,
          style: FilledButton.styleFrom(backgroundColor: AppPallete.primary),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.refresh_rounded),
              SizedBox(width: 8),
              Text('Tentar novamente'),
            ],
          ),
        ),
      ],
    ),
  );
}
