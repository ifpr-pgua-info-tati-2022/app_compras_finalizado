import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/adicionar_produto.dart';
import '../repositories/produto_repository.dart';
import '../widgets/custom_drawer.dart';

class ListaProdutos extends StatelessWidget {
  static final routeName = '/lista_produtos';

  const ListaProdutos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repositorio = Provider.of<ProdutoRepository>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Produtos"),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AdicionarProduto.routeName),
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemBuilder: ((context, index) {
          final produto = repositorio.produtos[index];
          return Dismissible(
            key: ValueKey(produto.id),
            background: Container(
              color: Colors.red.shade300,
              child: Icon(Icons.delete),
              alignment: Alignment.centerRight,
            ),
            onDismissed: (direction) {
              repositorio.remover(produto);
            },
            child: Card(
              child: ListTile(
                  leading: SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.network(produto.urlImagem),
                  ),
                  title: Text(produto.titulo)),
            ),
          );
        }),
        itemCount: repositorio.produtos.length,
      ),
      drawer: CustomDrawer(),
    );
  }
}
