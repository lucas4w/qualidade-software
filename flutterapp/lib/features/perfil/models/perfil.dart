class Perfil {
  final String cpf;
  final DateTime dataNascimento;
  final String telefone;
  final String email;
  final String nomeCompleto;

  Perfil({
    required this.cpf,
    required this.dataNascimento,
    required this.telefone,
    required this.email,
    required this.nomeCompleto,
  });

  factory Perfil.fromJson(Map<String, dynamic> json) {
    return Perfil(
      cpf: json['cpf'],
      dataNascimento: DateTime.parse(json['data_nascimento']),
      telefone: json['telefone'],
      email: json['email'],
      nomeCompleto: json['nome_completo'],
    );
  }
}
