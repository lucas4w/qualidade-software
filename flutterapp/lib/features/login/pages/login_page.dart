import 'package:flutter/material.dart';
import 'package:flutterapp/core/theme/app_theme.dart';
import 'package:flutterapp/core/theme/pallete.dart';
import 'package:flutterapp/features/login/services/login_service.dart';
import 'package:flutterapp/features/notificacoes/services/notificacoes_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutterapp/core/routing/app_routing.dart';
import 'package:flutterapp/core/services/notification_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final usuarioController = TextEditingController();
  final senhaController = TextEditingController();

  bool isLoading = false;

  String? errorMessage;

  FormFieldValidator<String> _validate() => (value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  };

  Future<void> _fazerLogin() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await LoginService.login(
        usuarioController.text.trim(),
        senhaController.text,
      );

      await NotificationService().initialize();
      NotificacoesController.sincronizarContagem();

      if (mounted) {
        router.go('/agendamentos');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    usuarioController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: const Alignment(0.0, -0.1),
        child: Container(
          height: 373,
          width: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Login RN SemFila',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text('Usuário', style: GoogleFonts.roboto(fontSize: 15)),
                  TextFormField(
                    decoration: inputTheme('Digite seu usuário'),
                    validator: _validate(),
                    controller: usuarioController,
                    cursorColor: AppPallete.primary,
                    style: const TextStyle(height: 1),
                    cursorErrorColor: AppPallete.primary,
                  ),
                  const SizedBox(height: 25),
                  Text('Senha', style: GoogleFonts.roboto(fontSize: 15)),
                  TextFormField(
                    decoration: inputTheme("Digite sua senha"),
                    obscureText: true,
                    validator: _validate(),
                    controller: senhaController,
                    cursorColor: AppPallete.primary,
                    style: const TextStyle(height: 1),
                    cursorErrorColor: AppPallete.primary,
                  ),
                  const SizedBox(height: 15),

                  if (errorMessage != null)
                    Center(
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  const SizedBox(height: 15),

                  ElevatedButton(
                    onPressed: isLoading ? null : _fazerLogin,
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(300, 44),
                      backgroundColor: AppPallete.primary,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text("Entrar"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
