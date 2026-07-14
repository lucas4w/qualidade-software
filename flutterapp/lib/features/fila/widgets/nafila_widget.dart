import 'package:flutter/material.dart';
import 'package:flutterapp/core/theme/pallete.dart';
import 'package:flutterapp/features/fila/models/status.dart';
import 'package:flutterapp/core/theme/filled_button_style.dart';

class NafilaWidget extends StatelessWidget {
  final Status? status;
  final VoidCallback onSkip;
  final VoidCallback onLeave;

  const NafilaWidget({
    super.key,
    required this.status,
    required this.onSkip,
    required this.onLeave,
  });

  double calcularProgressoFila(int? totalPessoasFila, int? posicao) {
    if (totalPessoasFila == null || posicao == null || totalPessoasFila <= 0) {
      return 0.0;
    }
    int posicaoAtual = posicao.clamp(1, totalPessoasFila);
    double progresso =
        (totalPessoasFila - (posicaoAtual - 1)) / totalPessoasFila;

    return progresso;
  }

  Widget backButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text('Voltar'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progresso = calcularProgressoFila(
      status?.posicao,
      status?.totalPessoasFila,
    );
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        height: 600,
        width: double.infinity,
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(height: 24),
            Text(
              'Seu status na fila',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              "${status!.posicao}º",
              style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold),
            ),

            Text('Sua posição na fila'),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Progresso da fila'),
                Text("${(progresso * 100).toInt()}%"),
              ],
            ),
            SizedBox(height: 3),
            LinearProgressIndicator(
              value: progresso,
              minHeight: 10,
              borderRadius: BorderRadius.circular(7),
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppPallete.primary,
              ),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 217, 245, 242),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: 148,
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Icon(Icons.people_outline, color: AppPallete.primary),
                      SizedBox(width: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total na fila', style: TextStyle(fontSize: 12)),
                          Text(
                            "${status?.totalPessoasFila} pessoas",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 219, 234, 254),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time_outlined,
                        color: const Color.fromARGB(255, 44, 127, 254),
                      ),
                      SizedBox(width: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tempo estimado',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            "${status?.tempoEstimado} minutos",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 60),
            Text(
              "Essa ação só pode ser realizada uma vez",
              style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
              textAlign: TextAlign.left,
            ),
            FilledButton(
              onPressed: !(status?.passouVez ?? false)
                  ? () {
                      showDialog<void>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Pular vez'),
                            content: const Text(
                              'Tem certeza que deseja pular vez? Esta ação não pode ser desfeita.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  onSkip();
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Pular vez',
                                  style: TextStyle(color: AppPallete.danger),
                                ),
                              ),
                              backButton(context),
                            ],
                          );
                        },
                      );
                    }
                  : null,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: AppPallete.primary,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.skip_previous_sharp),
                  SizedBox(width: 2),
                  Text(
                    'Pular vez',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            FilledButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Sair da fila'),
                      content: const Text(
                        'Tem certeza que deseja sair da fila? Esta ação não pode ser desfeita.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            onLeave();
                          },
                          child: const Text(
                            'Sair da fila',
                            style: TextStyle(color: AppPallete.danger),
                          ),
                        ),
                        backButton(context),
                      ],
                    );
                  },
                );
              },
              style: filledButtonStyle(),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.close),
                  SizedBox(width: 2),
                  Text(
                    'Sair da fila',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
