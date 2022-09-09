import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/carrinho.dart';
import '../models/produto.dart';
import '../pages/detalhes_produto.dart';

class ProdutoGradeItem extends StatelessWidget {
  const ProdutoGradeItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final produto = Provider.of<Produto>(context);
    return GridTile(
      child: GestureDetector(
        onDoubleTap: () {
          produto.changeFavorite();
        },
        onTap: () {
          Navigator.of(context).pushNamed(
            DetalhesProduto.routeName,
            arguments: {
              "id": produto.id,
            },
          );
        },
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: Image.network(
            produto.urlImagem,
            fit: BoxFit.fill,
          ),
        ),
      ),
      footer: GridTileBar(
        backgroundColor: Colors.black38,
        leading: IconButton(
          icon: Icon(
            produto.favorito ? Icons.favorite : Icons.favorite_border,
          ),
          onPressed: () {
            produto.changeFavorite();
          },
        ),
        title: Center(
          child: Text(produto.titulo),
        ),
        trailing: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Provider.of<Carrinho>(context, listen: false).adicionar(produto);
          },
        ),
      ),
    );
  }
}
