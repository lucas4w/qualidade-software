import 'package:flutter/material.dart';
import 'package:flutterapp/features/fila/models/status.dart';

class ForaDaFilaWidget extends StatelessWidget {
  final Status? status;
  const ForaDaFilaWidget({super.key, required this.status});

  Row getcolumn(IconData icone, String label, String? content) {
    return Row(
      children: [
        Icon(icone, size: 19, color: Colors.grey.shade600),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            Text(content ?? '-', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  BoxDecoration getBoxDecoration() {
    return BoxDecoration(
      color: Color.fromARGB(255, 239, 246, 255),
      border: Border.all(color: Color.fromARGB(255, 211, 231, 255)),
      borderRadius: BorderRadius.circular(12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        padding: EdgeInsets.all(14),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color.fromARGB(255, 236, 233, 195),
              ),
              padding: EdgeInsets.all(14),
              child: Icon(
                Icons.info_outline,
                color: Color.fromARGB(255, 208, 135, 1),
                size: 32,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Você ainda não está na fila',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            SizedBox(height: 27),
            Container(
              decoration: getBoxDecoration(),
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 24,
                        color: Color.fromARGB(255, 21, 93, 252),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Você tem agendamento!',
                        style: TextStyle(
                          color: Color.fromARGB(255, 45, 77, 190),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 28),
                    child: Text(
                      status!.mensagem ?? 'Você não está confirmado na fila.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 21, 93, 252),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color.fromARGB(255, 249, 250, 251),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informações da agenda',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 7),
                  getcolumn(
                    Icons.medical_information_outlined,
                    'Médico',
                    status?.medico,
                  ),
                  SizedBox(height: 4),
                  getcolumn(
                    Icons.calendar_today_outlined,
                    'Especialidade',
                    status?.especialidade,
                  ),
                  SizedBox(height: 4),
                  getcolumn(
                    Icons.location_on_outlined,
                    'Clínica',
                    status?.clinica,
                  ),
                  SizedBox(height: 4),
                  getcolumn(
                    Icons.access_time,
                    'Seu horário agendado',
                    status?.horarioAgendado,
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 217, 245, 242),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color.fromARGB(255, 131, 255, 211)),
              ),
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(
                    Icons.people_alt_outlined,
                    color: const Color.fromARGB(255, 0, 120, 111),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pessoas atualmente na fila',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        "${status?.totalNaFila} pessoas",
                        style: TextStyle(
                          fontSize: 19,
                          color: const Color.fromARGB(255, 0, 120, 111),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 18),
            Container(
              decoration: getBoxDecoration(),
              padding: EdgeInsets.all(12),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "💡 Dica:",
                      style: TextStyle(
                        color: Color.fromARGB(255, 45, 77, 190),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          ' Dirija-se à recepção para confirmar sua chegada e entrar na fila',
                      style: TextStyle(color: Color.fromARGB(255, 21, 93, 252)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
