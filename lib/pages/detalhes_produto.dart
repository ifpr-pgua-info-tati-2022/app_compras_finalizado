import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/produto.dart';
import '../repositories/produto_repository.dart';

class DetalhesProduto extends StatelessWidget {
  static final routeName = "/detalhes_produto";

  const DetalhesProduto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repositorio = Provider.of<ProdutoRepository>(context);

    final parameters =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    final id = parameters['id'];

    final produto =
        repositorio.produtos.firstWhere((element) => element.id == id);

    return Scaffold(
      appBar: AppBar(title: Text("Detalhes do produto")),
      body: Container(
        child: Column(
          children: [
            Image.network(produto.urlImagem),
            Text(produto.titulo),
            Text("R\$ ${produto.valor}"),
            ChangeNotifierProvider.value(
              value: produto,
              child: Consumer<Produto>(
                builder: ((context, x, child) => IconButton(
                      onPressed: () {
                        x.changeFavorite();
                      },
                      icon: Icon(
                          x.favorito ? Icons.favorite : Icons.favorite_border),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
