import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:produtos/utils/defs.dart';

import '../models/usuario.dart';

///Classe que permite cadastrar, logar e deslogar
///um usuário utilizando o Firebase.
///
class ServicoAutenticacao with ChangeNotifier {
  static const urlDominio = 'identitytoolkit.googleapis.com';

  Usuario? _usuario;
  Usuario? get usuario => _usuario;
  bool _logado = false;

  Future<String?> _signUpOrIn(String email, String senha,
      {bool cadastrar = false}) async {
    var endPoint = '';
    String? msg;

    if (cadastrar) {
      endPoint = '/v1/accounts:signUp';
    } else {
      endPoint = '/v1/accounts:signInWithPassword';
    }

    final url = Uri.https(urlDominio, endPoint, {'key': API_KEY});
    final response = await http.post(
      url,
      body: json.encode(
        {
          'email': email,
          'password': senha,
          'returnSecureToken': true,
        },
      ),
    );

    final data = json.decode(response.body);

    if (response.statusCode == 400) {
      if (cadastrar) {
        if (data['error']['message'] == 'EMAIL_EXISTS') {
          msg = 'E-mail já cadastrado';
        } else {
          msg = 'Erro!';
        }
      } else {
        msg = 'E-mail ou senha inválidos';
      }
      return msg;
    }

    final user = Usuario(
      id: data['localId'],
      email: email,
      token: data['idToken'],
      expiracao: DateTime.now().add(
        Duration(
          seconds: int.parse(
            data['expiresIn'],
          ),
        ),
      ),
    );

    _usuario = user;
    _logado = true;
    notifyListeners();
  }

  logout() {
    _usuario = null;
    _logado = false;
    notifyListeners();
  }

  Future<String?> singUp(String email, String senha) async {
    return _signUpOrIn(email, senha, cadastrar: true);
  }

  Future<String?> singIn(String email, String senha) async {
    return _signUpOrIn(email, senha);
  }

  bool get logado {
    return _logado;
  }
}
