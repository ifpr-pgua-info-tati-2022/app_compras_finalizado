import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/carrinho.dart';
import '../pages/detalhes_carrinho.dart';
import '../repositories/produto_repository.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/grade_produtos.dart';

class Home extends StatefulWidget {
  static final routeName = "/";

  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _mostrarFavoritos = false;

  @override
  void initState() {
    super.initState();
    Provider.of<ProdutoRepository>(context, listen: false).carregarProdutos();
  }

  mudarFiltroFavoritos() {
    setState(() {
      _mostrarFavoritos = !_mostrarFavoritos;
    });
  }

  @override
  Widget build(BuildContext context) {
    final carrinho = Provider.of<Carrinho>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Produtos"),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              mudarFiltroFavoritos();
            },
            itemBuilder: (ctx) {
              return [
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: [
                      if (_mostrarFavoritos)
                        Icon(
                          Icons.check,
                          color: Colors.black,
                        ),
                      Text(
                        "Favoritos",
                      ),
                    ],
                  ),
                ),
              ];
            },
          ),
          Badge(
            badgeContent: Text(carrinho.totalItens.toString()),
            position: BadgePosition.topEnd(top: 0, end: 2),
            badgeColor: Colors.amber,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(DetalhesCarrinho.routeName);
              },
              icon: Icon(Icons.shopping_cart),
            ),
          )
        ],
      ),
      body: GradeProdutos(mostrarFavoritos: _mostrarFavoritos),
      drawer: CustomDrawer(),
    );
  }
}
