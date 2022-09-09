import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/home.dart';
import '../pages/lista_produtos.dart';
import '../services/autenticacao_servico.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _servicoAutenticacao =
        Provider.of<ServicoAutenticacao>(context, listen: false);

    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("Produtos e Cia"),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          Text("Olá ${_servicoAutenticacao.usuario!.email}"),
          Divider(),
          ListTile(
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(Home.routeName),
            leading: Icon(Icons.home),
            title: Text('Home'),
          ),
          ListTile(
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(ListaProdutos.routeName),
            leading: Icon(Icons.ad_units),
            title: Text('Registro de produtos'),
          ),
          Divider(),
          ListTile(
            onTap: () {
              _servicoAutenticacao.logout();
            },
            leading: Icon(Icons.logout),
            title: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
