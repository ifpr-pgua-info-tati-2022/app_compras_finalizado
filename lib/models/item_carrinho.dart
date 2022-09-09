import './produto.dart';

class ItemCarrinho {
  final String id;
  final Produto produto;
  final int quantidade;
  final double valor;

  ItemCarrinho({
    required this.id,
    required this.produto,
    required this.quantidade,
    required this.valor,
  });
}
