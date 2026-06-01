import 'package:flutter/material.dart';
import 'package:flutterapp/core/theme/pallete.dart';
import 'package:flutterapp/core/widgets/loading.dart';
import 'package:flutterapp/features/agendamentos/models/agendamento.dart';
import 'package:flutterapp/features/agendamentos/services/agendamento_service.dart';
import 'package:flutterapp/features/agendamentos/widgets/agendamentocard_widget.dart';
import 'package:flutterapp/core/widgets/carregamento_mixin.dart';
import 'package:flutterapp/core/widgets/retry_button.dart';

class AgendamentosPage extends StatefulWidget {
  const AgendamentosPage({super.key});

  @override
  State<AgendamentosPage> createState() => _AgendamentosPageState();
}

class _AgendamentosPageState extends State<AgendamentosPage>
    with CarregamentoMixin {
  List<Agendamento>? _agendamentos;

  @override
  void initState() {
    super.initState();
    _buscarDados();
  }

  Future<void> _buscarDados() async {
    iniciarCarregamento();

    try {
      final dados = await AgendamentoService.buscarAgendamentos();
      if (dados.isNotEmpty) {
        dados.sort((a, b) {
          final aNaFila = a.filaID != null;
          final bNaFila = b.filaID != null;

          if (aNaFila && !bNaFila) return -1;
          if (!aNaFila && bNaFila) return 1;
          return a.dataAtendimento.compareTo(b.dataAtendimento);
        });
      }
      setState(() {
        _agendamentos = dados;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  Future<void> cancelarAgendamento(int id) async {
    setState(() {
      isLoading = true;
    });

    try {
      bool success = await AgendamentoService.cancelarAgendamento(id);
      if (success) {
        setState(() {
          _agendamentos?.removeWhere((a) => a.id == id);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao cancelar agendamento')),
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Meus agendamentos',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppPallete.primary),
            )
          : hasError
          ? errorWidget('Falha ao carregar os agendamentos', _buscarDados)
          : _agendamentos == null || _agendamentos!.isEmpty
          ? retryButton(_buscarDados)
          : RefreshIndicator(
              onRefresh: _buscarDados,
              color: AppPallete.primary,
              child: ListView.builder(
                itemCount: _agendamentos!.length,
                itemBuilder: (context, index) {
                  final agend = _agendamentos![index];
                  return Column(
                    key: ValueKey(agend.id),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: AgendamentoCard(
                          agendamento: agend,
                          onCancel: () => cancelarAgendamento(agend.id),
                        ),
                      ),
                      const SizedBox(height: 11),
                    ],
                  );
                },
              ),
            ),
    );
  }
}
