import 'dart:collection';
import 'dart:convert';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/produto.dart';
import '../services/autenticacao_servico.dart';
import '../utils/defs.dart';
import '../utils/enums.dart';

class ProdutoRepository with ChangeNotifier {
  final List<Produto> _lista = [];

  final ServicoAutenticacao _servicoAutenticacao;

  /*
  URL com o endPoint da API. No caso do
  Firebase, trabalha-se com coleções, que neste
  caso chamamos de protudos. Note que
  no caso do Firebase, é necessário adicionar
  um .json ao final
  */
  Uri _getApiEndPoint() {
    return Uri.https(URL_API, '/produtos.json',
        {'auth': _servicoAutenticacao.usuario?.token});
  }

  /*
  Atributos utilizados para indicar
  alguns status a respeito das ações
  do repositório.
  */
  var _status = Status.idle;
  var _actionResult = ActionResult.none;
  var _statusData = DataStatus.empty;

  ProdutoRepository(this._servicoAutenticacao);

  Status get status => _status;
  ActionResult get result => _actionResult;
  bool get hasData => _statusData == DataStatus.loaded;

  List<Produto> get produtos {
    return UnmodifiableListView(_lista);
  }

  List<Produto> get favoritos {
    return UnmodifiableListView(
      _lista.where((produto) => produto.favorito),
    );
  }

  ///Método para carregar a lista de um repositório remoto
  ///
  ///Faz a requisição utilizando o método get na URL da api,
  ///e processa o resultado. Em caso de sucesso retorna
  ///um [Result] com a lista de produtos. A classe [Result]
  ///pode conter o value ou error.
  Future<Result<List<Produto>>> _loadRemote() async {
    try {
      final resp = await http.get(_getApiEndPoint());
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as Map;

        final lista = <Produto>[];

        data.forEach((key, value) {
          value['id'] = key;
          final produto = Produto.fromJson(value);
          lista.add(produto);
        });
        //Caso o resultado seja positivo
        //retorna-se o Result como sendo um value,
        //indicando que não houve erro
        return Result.value(lista);
      } else {
        //Caso o resultado seja negativo
        //retorna-se o Result como sendo um error,
        //indicando que houve erro na requisicao
        return Result.error(resp.body);
      }
    } on Exception catch (e) {
      return Result.error(e.toString());
    }
  }

  ///Invoca o método _loadRemote e processa os resultados.
  ///Note que o tratamento para verificar se ocorreu
  ///erro na requisição acontece aqui.
  carregarProdutos() async {
    final res = await _loadRemote();

    String? msg;
    if (res.isValue) {
      _lista.addAll(res.asValue!.value);
      _actionResult = ActionResult.success;
      _statusData = DataStatus.loaded;
    } else {
      msg = res.asError!.error as String;
      _actionResult = ActionResult.error;
    }

    _status = Status.done;
    notifyListeners();
  }

  ///Método utilizado para salvar um produto remotamente.
  ///Utilizando uma requisição do tipo post envia-se
  ///os dados como json.
  Future<Result<Produto>> _saveRemote(Produto p) async {
    try {
      final resp =
          await http.post(_getApiEndPoint(), body: json.encode(p.toJson()));

      if (resp.statusCode == 200) {
        var data = json.decode(resp.body);
        return Result.value(p.copyWith(id: data['name']));
      } else {
        return Result.error(resp.statusCode);
      }
    } on Exception catch (e) {
      return Result.error(e.toString());
    }
  }

  ///Cria um produto, envia para o _saveRemote e
  ///processa o resultado.
  ///
  Future<String?> adicionar(
      String titulo, String descricao, double valor, String urlImagem) async {
    //Indica que está processando
    _status = Status.working;
    notifyListeners();

    final produto = Produto(
      id: '',
      titulo: titulo,
      descricao: descricao,
      urlImagem: urlImagem,
      valor: valor,
    );

    final result = await _saveRemote(produto);

    //processamento do resultado. Se não houve erro
    //adiciona o novo produto na lista. Caso contrário
    //envia a mensagem de erro.
    String? msg;
    if (result.isValue) {
      _actionResult = ActionResult.success;
      _lista.add(result.asValue!.value);
    } else {
      _actionResult = ActionResult.error;
      msg = result.asError!.error as String;
    }

    //indica que finalizou o processamento
    _status = Status.done;
    notifyListeners();
    return msg;
  }

  remover(Produto produto) {
    _lista.remove(produto);
    notifyListeners();
  }
}
