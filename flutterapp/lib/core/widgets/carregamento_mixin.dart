import 'package:flutter/material.dart';

mixin CarregamentoMixin<T extends StatefulWidget> on State<T> {
  bool isLoading = true;
  bool hasError = false;

  void iniciarCarregamento() {
    setState(() {
      isLoading = true;
      hasError = false;
    });
  }
}
