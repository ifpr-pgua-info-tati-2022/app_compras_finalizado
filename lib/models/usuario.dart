import 'dart:convert';

///Classe para representar um
///usuário cadastrado e logado no sistema.
class Usuario {
  final String id;
  final String email;
  final String token;
  final DateTime expiracao;

  Usuario(
      {required this.id,
      required this.email,
      required this.token,
      required this.expiracao});

  Usuario copyWith({
    String? id,
    String? email,
    String? token,
    DateTime? expiracao,
  }) {
    return Usuario(
      id: id ?? this.id,
      email: email ?? this.email,
      token: token ?? this.token,
      expiracao: expiracao ?? this.expiracao,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'token': token,
      'expiracao': expiracao.millisecondsSinceEpoch,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      email: map['email'],
      token: map['token'],
      expiracao: DateTime.fromMillisecondsSinceEpoch(map['expiracao']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Usuario.fromJson(String source) =>
      Usuario.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Usuario(id: $id, email: $email, token: $token, expiracao: $expiracao)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Usuario &&
        o.id == id &&
        o.email == email &&
        o.token == token &&
        o.expiracao == expiracao;
  }

  @override
  int get hashCode {
    return id.hashCode ^ email.hashCode ^ token.hashCode ^ expiracao.hashCode;
  }
}
