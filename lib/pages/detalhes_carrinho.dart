import 'package:flutter/material.dart';

class DetalhesCarrinho extends StatelessWidget {
  static final String routeName = '/detalhes_carrinho';

  const DetalhesCarrinho({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Seu Carrinho"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("Itens"),
          ],
        ),
      ),
    );
  }
}
