import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'item_carrinho.dart';
import 'produto.dart';

class Carrinho with ChangeNotifier {
  Map<String, ItemCarrinho> _items = {};

  Map<String, ItemCarrinho> get selecionados => UnmodifiableMapView(_items);

  ///Retorna a quantidade de itens no carrinho.
  int get totalItens {
    return _items.values.toList().fold(
          0,
          (acc, item) => acc + item.quantidade,
        );
    /*int acc = 0;
    for (var item in _items.values) {
      acc += item.quantidade;
    }*/
  }

  ///Calcula o valor total dos itens
  double get valorTotal {
    return _items.values
        .toList()
        .fold(0.0, (acc, item) => acc + item.quantidade * item.valor);
  }

  ///Retorna uma lista imutável dos itens
  List<ItemCarrinho> get itens {
    return UnmodifiableListView(_items.values.toList());
  }

  ///Remove um determinado item do carrinho
  remover(ItemCarrinho item) {
    _items.removeWhere((key, value) => item == value);
    notifyListeners();
  }

  ///Adiciona um novo produto ao carrinho, criando um novo item.
  ///Caso o produto já exista no carrinho, incrementa a quantidade.
  adicionar(Produto produto) {
    if (_items.containsKey(produto.id)) {
      _items.update(
        produto.id,
        (antigo) => ItemCarrinho(
          id: antigo.id,
          produto: produto,
          quantidade: antigo.quantidade + 1,
          valor: antigo.valor,
        ),
      );
    } else {
      _items.putIfAbsent(
        produto.id,
        () => ItemCarrinho(
          id: DateTime.now().toString(),
          produto: produto,
          quantidade: 1,
          valor: produto.valor,
        ),
      );
    }
    notifyListeners();
  }
}
