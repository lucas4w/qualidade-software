import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/core/api/api.dart';
import 'package:flutterapp/core/theme/pallete.dart';
import 'package:flutterapp/core/services/auth_service.dart';
import 'package:flutterapp/features/notificacoes/services/notificacoes_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  StreamSubscription<RemoteMessage>? _onMessageSubscription;

  Future<void> _enviarTokenParaServidor(String token) async {
    try {
      final String? pacienteId = await AuthService().getPacienteIDLogado();

      if (pacienteId == null) {
        debugPrint('Paciente ID não encontrado. Usuário não logado?');
        return;
      }

      final response = await ApiClient.instance.post(
        'tokens-dispositivo/',
        data: {
          'token_dispositivo': token,
          'paciente': int.tryParse(pacienteId) ?? pacienteId,
        },
      );
      final int dispositivoId = response.data['id']; // ← Captura o ID

      // Atualiza o banco local com o novo dispositivoId
      final String? userID = await AuthService().getUserIDLogado();
      if (userID != null) {
        await AuthService().salvarUsuarioLogado(
          pacienteId,
          userID,
          dispositivoId,
        );
      }
      debugPrint(
        'Token FCM salvo no backend com sucesso para paciente $pacienteId',
      );
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint(
          'Erro ao salvar token FCM: ${e.response?.statusCode} - ${e.response?.data}',
        );
      } else {
        debugPrint('Erro de rede ao salvar token FCM: ${e.message}');
      }
    } catch (e) {
      debugPrint('Erro inesperado ao enviar token FCM: $e');
    }
  }

  Future<void> initialize() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('Usuário negou permissão de notificações');
      return;
    }

    String? token;
    int retryCount = 0;

    while (token == null && retryCount < 3) {
      try {
        token = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        retryCount++;
        await Future.delayed(Duration(seconds: 2));
      }
    }
    if (token != null) {
      await _enviarTokenParaServidor(token);
    }

    NotificacoesController.sincronizarContagem();

    _messaging.onTokenRefresh.listen((newToken) async {
      await _enviarTokenParaServidor(newToken);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('notificação recebida em foreground');
      debugPrint('Título: ${message.notification?.title}');
      debugPrint('Corpo: ${message.notification?.body}');
      debugPrint('Dados extras: ${message.data}');
      NotificacoesController.sincronizarContagem();
      NotificacoesController.onNovaNotificacao.add(null);
      final notification = message.notification;

      if (notification != null) {
        snackbarKey.currentState?.showSnackBar(
          SnackBar(
            backgroundColor: Colors.white,
            elevation: 10,
            padding: EdgeInsets.all(12),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(bottom: 12, left: 10, right: 10),
            duration: Duration(seconds: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Row(
              children: [
                Icon(Icons.notifications_active, color: AppPallete.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    notification.body ?? '',
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('usuário abriu o app tocando na notificação');
      debugPrint('Dados: ${message.data}');
    });
  }

  Future<void> logout() async {
    await _onMessageSubscription?.cancel();
    _onMessageSubscription = null;
    debugPrint('Listeners de notificação limpos com sucesso');
  }
}
