class Agendamento {
  Agendamento({
    required this.id,
    required this.medicoNome,
    required this.status,
    required this.dataAtendimento,
    required this.horaAgendamento,
    required this.filaID,
  });

  factory Agendamento.fromJson(Map<String, dynamic> json) {
    return Agendamento(
      id: json['id'] as int,
      medicoNome: json['medico_nome'] as String,
      status: json['status'] as String,
      dataAtendimento: DateTime.parse(json['data_atendimento'] as String),
      horaAgendamento: DateTime.parse(
        "1970-01-01 ${json['hora_agendamento'] as String}",
      ),
      filaID: json['fila_id'] as String?,
    );
  }
  final int id;
  final String medicoNome;
  final String status;
  final DateTime dataAtendimento;
  final DateTime horaAgendamento;
  final String? filaID;
}

// "id":1392,"medico_nome":"Joao Silva","data_atendimento":"2025-12-24",
// "hora_agendamento":"11:30:00","fila_id":null}
