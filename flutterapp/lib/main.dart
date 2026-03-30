import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/core/database/database_manager.dart';
import 'package:flutterapp/core/routing/app_routing.dart';
import 'package:flutterapp/core/theme/app_theme.dart';
import 'package:flutterapp/core/api/api.dart';
import 'package:flutterapp/features/notificacoes/services/notificacoes_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  DatabaseManager.instance.database;
  ApiClient.init();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  NotificacoesController.sincronizarContagem();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scaffoldMessengerKey: snackbarKey,
      title: 'RN Sem Fila',
      theme: AppTheme.theme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
