import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repositories/produto_repository.dart';
import 'produto_grade_item.dart';

class GradeProdutos extends StatelessWidget {
  final bool mostrarFavoritos;

  GradeProdutos({
    Key? key,
    this.mostrarFavoritos = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var repositorio = Provider.of<ProdutoRepository>(context);

    var lista = repositorio.produtos;
    if (mostrarFavoritos) {
      lista = repositorio.favoritos;
    }

    return !repositorio.hasData
        ? Center(
            child: CircularProgressIndicator(),
          )
        : GridView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final produto = lista[index];
              return ChangeNotifierProvider.value(
                value: produto,
                child: ProdutoGradeItem(),
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 3 / 2,
            ),
          );
  }
}
