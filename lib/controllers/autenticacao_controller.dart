import 'package:flutter/foundation.dart';
import 'package:validators/validators.dart';

import '../services/autenticacao_servico.dart';
import '../utils/enums.dart';

class AutenticacaoController with ChangeNotifier {
  String _email = '';
  String _senha = '';
  String _confirmacaoSenha = '';
  bool _cadastrar = false;
  Status _processando = Status.idle;
  ActionResult _resultado = ActionResult.none;
  String? _errormsg;

  final ServicoAutenticacao _servicoAutenticacao;

  AutenticacaoController(this._servicoAutenticacao);

  bool get cadastrando => _cadastrar;
  bool get processando => _processando == Status.working;
  bool get hasError => _resultado == ActionResult.error;
  String get errorMsg => _errormsg ?? '';

  String? validarEmail(String? val) {
    if (val == null || val.isEmpty) {
      return "E-mail não pode ser vazio";
    }
    if (!isEmail(val)) {
      return "E-mail inválido";
    }

    return null;
  }

  String? validarSenha(String? val) {
    if (val == null || val.isEmpty) {
      return "A senha não pode ser vazia";
    }
    if (val.length < 6) {
      return "A senha deve ter mais de 5 digitos";
    }
    return null;
  }

  String? validarConfirmaSenha(String? val) {
    if (_cadastrar) {
      if (_senha != _confirmacaoSenha) {
        return "As senhas não são iguais";
      }
    }

    return null;
  }

  setEmail(String val) {
    _email = val;
  }

  setSenha(String val) {
    _senha = val;
  }

  setConfirmacaoSenha(String val) {
    _confirmacaoSenha = val;
  }

  alterarCadastrar() {
    _cadastrar = !_cadastrar;
    notifyListeners();
  }

  ///Invoca um dos métodos do serviço de autenticação
  ///e processa o resultado.
  executar() async {
    _processando = Status.working;
    _errormsg = '';
    _resultado = ActionResult.none;
    notifyListeners();

    String? ret;
    if (_cadastrar) {
      ret = await _servicoAutenticacao.singUp(_email, _senha);
    } else {
      ret = await _servicoAutenticacao.singIn(_email, _senha);
    }

    if (ret != null) {
      _errormsg = ret;
      _resultado = ActionResult.error;
    }

    _processando = Status.done;
    notifyListeners();
  }
}
