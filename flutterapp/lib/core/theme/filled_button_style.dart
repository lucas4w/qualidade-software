import 'package:flutter/material.dart';
import 'package:flutterapp/core/theme/pallete.dart';

ButtonStyle filledButtonStyle() {
  return FilledButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 15),
    backgroundColor: AppPallete.danger,
    shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(22)),
  );
}

Column getColumn(String label, String? content) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
      Text(content ?? '-', style: TextStyle(fontWeight: FontWeight.bold)),
    ],
  );
}

Row getRow(String label, IconData icon) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(icon),
      SizedBox(width: 2),
      Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
    ],
  );
}
