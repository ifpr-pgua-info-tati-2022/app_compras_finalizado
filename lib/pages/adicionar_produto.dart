import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/adicionar_produto_controler.dart';
import '../repositories/produto_repository.dart';

class AdicionarProduto extends StatelessWidget {
  static const routeName = "/adicionar_produto";

  const AdicionarProduto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = AdicionarProdutoControler(
        Provider.of<ProdutoRepository>(context, listen: false));

    return Scaffold(
      appBar: AppBar(title: Text("Novo Produto")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            _CustomTextFormField(
              label: "Título",
              hint: "Digite o nome do produto",
              icon: Icon(Icons.title),
              validator: _controller.validarTitulo,
              onChanged: (p0) => _controller.setTitulo(p0 ?? ""),
            ),
            SizedBox(height: 10),
            _CustomTextFormField(
              label: "Descrição",
              hint: "Digite uma descrição",
              icon: Icon(Icons.description),
              validator: _controller.validarDescricao,
              onChanged: (p0) => _controller.setDescricao(p0 ?? ""),
            ),
            SizedBox(height: 10),
            _CustomTextFormField(
              label: "Valor",
              hint: "Digite um valor em R\$",
              icon: Icon(Icons.monetization_on),
              validator: _controller.validarValor,
              onChanged: (p0) => _controller.setValor(
                double.tryParse(p0 ?? "") ?? 0,
              ),
            ),
            SizedBox(height: 10),
            _CustomTextFormField(
              label: "Url da Imagem",
              hint: "Digite o endereço de uma imagem na internet",
              icon: Icon(Icons.image),
              validator: _controller.validarUrl,
              onChanged: (p0) => _controller.setUrl(p0 ?? ""),
            ),
            SizedBox(
              height: 10,
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => Stack(
                children: [
                  ElevatedButton(
                    onPressed: _controller.isValid
                        ? () async {
                            final ret = await _controller.adicionar();
                            if (ret == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Produto adicionado!"),
                                ),
                              );
                              Navigator.of(context).pop();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(ret!),
                                ),
                              );
                            }
                          }
                        : null,
                    child: Text("Adicionar"),
                  ),
                  if (_controller.processando) CircularProgressIndicator(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomTextFormField extends StatelessWidget {
  final String label;
  final String hint;
  final Icon icon;
  final String? Function(String?)? validator;
  final Function(String?)? onChanged;

  _CustomTextFormField({
    Key? key,
    required this.label,
    required this.hint,
    required this.icon,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        prefixIcon: icon,
        label: Text(label),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.black26),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
