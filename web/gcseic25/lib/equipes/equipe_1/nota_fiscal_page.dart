// lib/equipe_sua/nota_fiscal_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'estrutura_impostos.dart';
import 'dart:convert';

class NotaFiscalPage extends StatefulWidget {
  final EstruturaImpostos estruturaImpostos;

  const NotaFiscalPage({required this.estruturaImpostos});

  @override
  _NotaFiscalPageState createState() => _NotaFiscalPageState();
}

class _NotaFiscalPageState extends State<NotaFiscalPage> {
  String _resultado = 'Clique em "Consultar API" para ver o resumo.';

  Future<void> consultarNotaFiscal() async {
    final baseUrl = 'https://sincere-magnificent-cobweb.glitch.me/gf/imposto/resumo-nota-fiscal'; // use o IP correto conforme seu ambiente

    final uri = Uri.parse(baseUrl).replace(queryParameters: {
      'valor_produto': widget.estruturaImpostos.valor_produto.toString(),
      'valor_icms': widget.estruturaImpostos.icms.toString(),
      'valor_ipi': widget.estruturaImpostos.ipi.toString(),
      'valor_pis': widget.estruturaImpostos.pis.toString(),
      'valor_cofins': widget.estruturaImpostos.cofins.toString(),
    });

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        setState(() {
          _resultado = jsonEncode(body); // ou formate melhor se preferir
        });
      } else {
        setState(() {
          _resultado = 'Erro ${response.statusCode}: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _resultado = 'Erro de conexão: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resumo Nota Fiscal')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: consultarNotaFiscal,
              child: Text('Consultar API'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _resultado,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
