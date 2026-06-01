import 'package:flutter/material.dart';
import 'package:flutterapp/core/theme/pallete.dart';
import 'package:flutterapp/features/agendamentos/models/agendamento.dart';
import 'package:intl/intl.dart';
import 'package:flutterapp/core/routing/app_routing.dart';
import 'package:flutterapp/core/theme/filled_button_style.dart';

class AgendamentoCard extends StatelessWidget {
  final Agendamento agendamento;
  final VoidCallback onCancel;
  const AgendamentoCard({
    super.key,
    required this.agendamento,
    required this.onCancel,
  });

  Container getContainer(IconData icon, String label) {
    return Container(
      height: 80,
      width: 130,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: BoxBorder.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(8),
        color: const Color.fromARGB(255, 251, 252, 253),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Color.fromARGB(255, 112, 119, 136),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          SizedBox(height: 7),
          Row(
            children: [
              Icon(icon, size: 18, color: Color.fromARGB(255, 112, 119, 136)),
              SizedBox(width: 5),
              Text(
                label == 'Data'
                    ? DateFormat(
                        'dd/MM/yyyy',
                      ).format(agendamento.dataAtendimento)
                    : DateFormat('HH:mm').format(agendamento.horaAgendamento),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool filaEstaAtiva() {
    return agendamento.filaID != null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Card(
        elevation: 0,
        color: Colors.transparent,

        child: Padding(
          padding: EdgeInsetsGeometry.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PROFISSIONAL',
                        style: TextStyle(
                          letterSpacing: 2,
                          color: const Color.fromARGB(255, 183, 188, 199),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(Icons.person, size: 16),
                          SizedBox(width: 3),
                          Text(
                            "Dr(a). ${agendamento.medicoNome}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: filaEstaAtiva()
                          ? const Color.fromARGB(255, 230, 255, 245)
                          : const Color.fromARGB(255, 249, 250, 251),
                      borderRadius: BorderRadius.circular(16),
                      border: BoxBorder.all(
                        color: filaEstaAtiva()
                            ? Color.fromARGB(255, 131, 255, 211)
                            : Color.fromARGB(255, 236, 237, 241),
                      ),
                    ),

                    child: Row(
                      children: [
                        Icon(
                          Icons.remove_red_eye_outlined,
                          size: 15,
                          color: filaEstaAtiva()
                              ? AppPallete.primary
                              : Color.fromARGB(255, 112, 119, 136),
                        ),
                        SizedBox(width: 4),
                        Text(
                          filaEstaAtiva()
                              ? "Fila disponível"
                              : "Fila indisponível",
                          style: TextStyle(
                            color: filaEstaAtiva()
                                ? AppPallete.primary
                                : Color.fromARGB(255, 112, 119, 136),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.grey.shade300, height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  getContainer(Icons.calendar_today_outlined, 'Data'),
                  getContainer(Icons.access_time_outlined, 'Hora'),
                ],
              ),
              SizedBox(height: 20),
              FilledButton(
                onPressed: filaEstaAtiva()
                    ? () => router.push('/fila/${agendamento.filaID}')
                    : null,
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: AppPallete.primary,
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(22),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.remove_red_eye, size: 16),
                    SizedBox(width: 5),
                    Text(
                      'Ver fila',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 13),
              FilledButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirmar cancelamento'),
                        content: const Text(
                          'Tem certeza que deseja cancelar este agendamento? Esta ação não pode ser desfeita.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              onCancel();
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Confirmar',
                              style: TextStyle(
                                color: AppPallete.danger,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              foregroundColor: AppPallete.primary,
                            ),
                            child: const Text('Voltar'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: filledButtonStyle(),
                child: getRow('Cancelar agendamento', Icons.cancel_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
