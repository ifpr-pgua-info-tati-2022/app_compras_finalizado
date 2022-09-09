import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/autenticacao.dart';
import '../pages/home.dart';
import '../services/autenticacao_servico.dart';

///Tela da splash, que serve para definir se será
///mostrado a tela de login ou a tela home.
class Splash extends StatelessWidget {
  static const routeName = '/splash';

  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final servicoAutenticacao = Provider.of<ServicoAutenticacao>(context);

    return servicoAutenticacao.logado ? Home() : Autenticacao();
  }
}
