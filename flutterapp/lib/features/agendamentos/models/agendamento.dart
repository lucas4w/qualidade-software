class Agendamento {
  final int id;
  final String medicoNome;
  final String status;
  final DateTime dataAtendimento;
  final DateTime horaAgendamento;
  final String? filaID;

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
      id: json['id'],
      medicoNome: json['medico_nome'],
      status: json['status'],
      dataAtendimento: DateTime.parse(json['data_atendimento']),
      horaAgendamento: DateTime.parse("1970-01-01 ${json['hora_agendamento']}"),
      filaID: json['fila_id'],
    );
  }
}
// "id":1392,"medico_nome":"Joao Silva","data_atendimento":"2025-12-24",
// "hora_agendamento":"11:30:00","fila_id":null}