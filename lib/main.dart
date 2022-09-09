import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/carrinho.dart';
import 'pages/adicionar_produto.dart';
import 'pages/autenticacao.dart';
import 'pages/detalhes_carrinho.dart';
import 'pages/detalhes_produto.dart';
import 'pages/home.dart';
import 'pages/lista_produtos.dart';
import 'pages/splash.dart';
import 'repositories/produto_repository.dart';
import 'services/autenticacao_servico.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ServicoAutenticacao()),
        ChangeNotifierProxyProvider<ServicoAutenticacao, ProdutoRepository>(
          create: (context) => ProdutoRepository(
              Provider.of<ServicoAutenticacao>(context, listen: false)),
          update: (context, servicoAutenticacao, anterior) =>
              ProdutoRepository(servicoAutenticacao),
        ),
        ChangeNotifierProvider(
          create: (context) => Carrinho(),
        ),
      ],
      child: MaterialApp(
        title: "App de Produtos",
        debugShowCheckedModeBanner: false,
        initialRoute: Splash.routeName,
        routes: {
          Splash.routeName: (context) => Splash(),
          Autenticacao.routeName: (context) => Autenticacao(),
          Home.routeName: (context) => Home(),
          DetalhesProduto.routeName: (ctx) => DetalhesProduto(),
          DetalhesCarrinho.routeName: (ctx) => DetalhesCarrinho(),
          ListaProdutos.routeName: (ctx) => ListaProdutos(),
          AdicionarProduto.routeName: (context) => AdicionarProduto()
        },
      ),
    );
  }
}
