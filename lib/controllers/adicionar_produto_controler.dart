import 'package:flutter/foundation.dart';

import '../repositories/produto_repository.dart';
import '../utils/enums.dart';

class AdicionarProdutoControler with ChangeNotifier {
  String _titulo = "";
  String _descricao = "";
  double _valor = 0.0;
  String _urlImagem = "";

  final ProdutoRepository _repositorio;

  AdicionarProdutoControler(this._repositorio);

  String get titulo => _titulo;
  String get descricao => _descricao;
  double get valor => _valor;
  String get urlImagem => _urlImagem;

  Status _status = Status.idle;

  bool get processando => _status == Status.working;

  bool get isValid {
    return validarTitulo(_titulo) == null &&
        validarDescricao(_descricao) == null &&
        validarValor(_valor.toString()) == null &&
        validarUrl(_urlImagem) == null;
  }

  String? validarTitulo(String? val) {
    if (val == null || val.isEmpty) {
      return "O título não pode ser vazio";
    }
    if (val.length < 5) {
      return "O título deve conter mais que 5 letras";
    }
    return null;
  }

  String? validarDescricao(String? val) {}

  String? validarValor(String? val) {
    if (val == null || val.isEmpty) {
      return "O valor não pode ser vazio";
    }
    double? v = double.tryParse(val);
    if (v == null) {
      return "Valor inválido";
    }
    if (v <= 0) {
      return "O valor deve ser maior que 0";
    }
    return null;
  }

  String? validarUrl(String? val) {}

  setTitulo(String val) {
    _titulo = val;
    print(_titulo);
    notifyListeners();
  }

  setDescricao(String val) {
    _descricao = val;
    notifyListeners();
  }

  setValor(double val) {
    _valor = val;
    notifyListeners();
  }

  setUrl(String val) {
    _urlImagem = val;
    notifyListeners();
  }

  ///Adiciona um produto no repositorio e processa
  ///o resultado.
  Future<String?> adicionar() async {
    _status = Status.working;
    notifyListeners();

    final resp = await _repositorio.adicionar(
      _titulo,
      _descricao,
      _valor,
      _urlImagem,
    );

    _status = Status.done;
    notifyListeners();

    return resp;
  }
}
