class User {
  final int? id;
  final int idServer;
  final int userID;

  User({this.id, required this.idServer, required this.userID});

  Map<String, dynamic> toMap() {
    return {'id': id, 'idServer': idServer, 'userID': userID};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      idServer: map['idServer'] as int,
      userID: map['userID'] as int,
    );
  }
}
