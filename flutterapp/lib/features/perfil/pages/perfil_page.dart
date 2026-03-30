import 'package:flutter/material.dart';
import 'package:flutterapp/core/api/api.dart';
import 'package:flutterapp/core/services/auth_service.dart';
import 'package:flutterapp/core/services/token_storage.dart';
import 'package:flutterapp/core/routing/app_routing.dart';
import 'package:flutterapp/core/services/notification_service.dart';
import 'package:flutterapp/core/theme/pallete.dart';
import 'package:flutterapp/features/perfil/models/perfil.dart';
import 'package:flutterapp/features/perfil/services/perfil_service.dart';
import 'package:intl/intl.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  Perfil? _perfil;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _buscarDados();
  }

  Future<void> _buscarDados() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final dados = await PerfilService.buscarPerfil();
      setState(() {
        _perfil = dados;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void logout() async {
    final dispositivoId = await AuthService().getDispositivoIdLogado();

    if (dispositivoId != null) {
      try {
        await ApiClient.instance.delete('tokens-dispositivo/$dispositivoId/');
        debugPrint('Token removido do backend (ID: $dispositivoId)');
      } catch (e) {
        debugPrint('Erro ao remover token do backend: $e');
      }
    }
    await TokenStorage.clearTokens();
    await AuthService().logout();
    await NotificationService().logout();
    router.go('/login');
  }

  Container getContainer(IconData icone, String label, String? content) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(255, 248, 250, 252),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: const Color.fromARGB(255, 217, 245, 242),
            ),
            padding: EdgeInsets.all(10),
            child: Icon(icone, size: 24, color: AppPallete.primary),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              Text(
                content ?? '-',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppPallete.primary),
            )
          : _hasError
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text('Falha ao carregar perfil'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _buscarDados,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppPallete.primary,
                    ),
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
            )
          : Column(
              children: [
                Container(
                  decoration: BoxDecoration(color: AppPallete.primary),
                  height: 140,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Olá, ${_perfil?.nomeCompleto}",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 9),
                        Text(
                          'Aqui estão suas informações:',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      getContainer(
                        Icons.person_2_outlined,
                        'Nome completo',
                        _perfil?.nomeCompleto,
                      ),
                      SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 248, 250, 252),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: const Color.fromARGB(255, 217, 245, 242),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.calendar_today_outlined,
                                size: 24,
                                color: AppPallete.primary,
                              ),
                            ),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Data de nascimento',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  DateFormat(
                                    'dd/MM/yyyy',
                                  ).format(_perfil!.dataNascimento),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      getContainer(
                        Icons.email_outlined,
                        'Email',
                        _perfil?.email,
                      ),
                      SizedBox(height: 12),
                      getContainer(Icons.phone, 'Telefone', _perfil?.telefone),
                      SizedBox(height: 12),
                      getContainer(Icons.wallet_sharp, 'CPF', _perfil?.cpf),
                      SizedBox(height: 32),
                      FilledButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Sair'),
                                content: const Text(
                                  'Tem certeza que deseja sair?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: logout,
                                    child: const Text(
                                      'Sair',
                                      style: TextStyle(
                                        color: AppPallete.danger,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Voltar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: AppPallete.danger,
                          shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout_rounded),
                            SizedBox(width: 2),
                            Text(
                              'Sair',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
