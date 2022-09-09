import 'package:flutter/material.dart';

class Produto with ChangeNotifier {
  final String id;
  final String titulo;
  final String descricao;
  final String urlImagem;
  final double valor;
  bool favorito;

  Produto({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.valor,
    required this.urlImagem,
    this.favorito = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'urlImagem': urlImagem,
      'valor': valor,
      'favorito': favorito
    };
  }

  void changeFavorite() {
    favorito = !favorito;
    notifyListeners();
  }

  factory Produto.fromJson(Map<String, dynamic> data) => Produto(
        id: data['id'],
        titulo: data['titulo'],
        descricao: data['descricao'],
        urlImagem: data['urlImagem'],
        valor: data['valor'],
        favorito: data['favorito'],
      );

  Produto copyWith(
      {String? id,
      String? titulo,
      String? descricao,
      String? urlImagem,
      double? valor,
      bool? favorito}) {
    return Produto(
        id: id ?? this.id,
        titulo: titulo ?? this.titulo,
        descricao: descricao ?? this.descricao,
        urlImagem: urlImagem ?? this.urlImagem,
        valor: valor ?? this.valor,
        favorito: favorito ?? this.favorito);
  }
}
