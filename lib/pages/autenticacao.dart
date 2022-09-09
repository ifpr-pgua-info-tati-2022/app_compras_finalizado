import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/autenticacao_controller.dart';
import '../services/autenticacao_servico.dart';

class Autenticacao extends StatefulWidget {
  static const String routeName = '/autenticacao';

  const Autenticacao({Key? key}) : super(key: key);

  @override
  _AutenticacaoState createState() => _AutenticacaoState();
}

class _AutenticacaoState extends State<Autenticacao> {
  var ocultarSenha = false;
  late AutenticacaoController _controller;

  //chave utilizada para identificar o form.
  final _formKey = GlobalKey<FormState>();

  ///Método executado uma vez ao construir o
  ///estado do Widget.
  @override
  void initState() {
    super.initState();

    //inicialização do controlador
    _controller = AutenticacaoController(
        Provider.of<ServicoAutenticacao>(context, listen: false));

    //Para não precisar utilizar o AnimatedBuilder
    //é possível escutar as modificações do
    //controlador e atualizar o estado.
    _controller.addListener(() {
      setState(() {});
    });
  }

  executar() async {
    //O objeto Form, permite verificar se
    //todos os componentes estão válidos antes
    //de prosseguir.
    if (_formKey.currentState!.validate()) {
      await _controller.executar();

      if (_controller.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_controller.errorMsg),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _CustomTextFormField(
                  label: 'E-Mail',
                  hint: 'Digite seu email',
                  icon: Icon(Icons.mail),
                  validator: _controller.validarEmail,
                  onChanged: (value) {
                    _controller.setEmail(value ?? '');
                  },
                ),
                SizedBox(height: 10),
                _CustomTextFormField(
                  label: 'Senha',
                  hint: 'Digite sua senha',
                  icon: Icon(Icons.vpn_key),
                  suffixIcon: IconButton(
                    icon: Icon(ocultarSenha
                        ? Icons.remove_red_eye
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        ocultarSenha = !ocultarSenha;
                      });
                    },
                  ),
                  obscureText: ocultarSenha,
                  validator: _controller.validarSenha,
                  onChanged: (value) {
                    _controller.setSenha(value ?? '');
                  },
                ),
                if (_controller.cadastrando) SizedBox(height: 10),
                if (_controller.cadastrando)
                  _CustomTextFormField(
                    label: 'Cofirmar senha',
                    hint: 'Digite sua senha novamente',
                    obscureText: true,
                    icon: Icon(Icons.vpn_key),
                    validator: _controller.validarConfirmaSenha,
                    onChanged: (value) {
                      _controller.setConfirmacaoSenha(value ?? '');
                    },
                  ),
                SizedBox(height: 10),
                _controller.processando
                    ? CircularProgressIndicator()
                    : Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              executar();
                            },
                            child: Text(_controller.cadastrando
                                ? 'Cadastrar'
                                : 'Entrar'),
                          ),
                          TextButton(
                            onPressed: () {
                              _controller.alterarCadastrar();
                            },
                            child: Text(_controller.cadastrando
                                ? 'Logar'
                                : 'Novo usuário.'),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomTextFormField extends StatelessWidget {
  final String label;
  final String hint;
  final Icon? icon;
  final Widget? suffixIcon;
  final bool? obscureText;
  final TextInputType? inputType;
  final String? Function(String?)? validator;
  final String? Function(String?)? save;
  final void Function(String?)? onChanged;
  final String? initialValue;
  final TextEditingController? controller;

  const _CustomTextFormField({
    Key? key,
    required this.label,
    required this.hint,
    this.icon,
    this.suffixIcon,
    this.obscureText,
    this.inputType,
    this.validator,
    this.save,
    this.onChanged,
    this.initialValue,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      onSaved: save,
      onChanged: onChanged,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: inputType,
      obscureText: obscureText ?? false,
      initialValue: initialValue,
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        prefixIcon: icon,
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
