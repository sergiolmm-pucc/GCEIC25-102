import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'estrutura_impostos.dart';

class CalculoIcmsPage extends StatefulWidget {
  final String title;
  final EstruturaImpostos estruturaImpostos;
  const CalculoIcmsPage({super.key, required this.title, required this.estruturaImpostos});

  @override
  State<CalculoIcmsPage> createState() => _CalculoIcmsPageState();
}

class _CalculoIcmsPageState extends State<CalculoIcmsPage> {
  final valorController = TextEditingController();
  final aliquotaController = TextEditingController();
  String resultado = '';
  double valor_icms = 0.0;
  double valor_produto = 0.0;
  double aliquota_icms = 0.0;

  Future<void> calcularICMS() async {
    final valor = valorController.text;
    final aliquota = aliquotaController.text;

    if (valor.isEmpty || aliquota.isEmpty) {
      setState(() => resultado = 'Preencha todos os campos.');
      return;
    }

    try {
      final url = Uri.parse(
        'https://sincere-magnificent-cobweb.glitch.me/imposto/calculo-icms?valor_produto=$valor&aliquota_icms=$aliquota',
      );
      final resp = await http.get(url);
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        setState(() {
          valor_icms = data['valor_icms']?.toDouble() ?? 0.0;
          widget.estruturaImpostos.icms = valor_icms;
          valor_produto = data['valor_produto']?.toDouble() ?? 0.0;
          aliquota_icms = data['aliquota_icms']?.toDouble() ?? 0.0;
          resultado =
              'Valor do produto: R\$ $valor_produto\n'
              'Alíquota ICMS: $aliquota_icms%\n'
              'Valor do ICMS: R\$ $valor_icms\n'
              'Valor total: R\$ ${valor_produto + valor_icms}';
        });
      } else {
        setState(() {
          resultado = 'Erro: ${resp.statusCode}';
        });
      }
    } catch (e) {
      setState(() => resultado = 'Erro na requisição.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Semantics(
              label: 'Valor do produto',
              textField: true,
              child: TextField(
                controller: valorController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Valor do produto'),
              ),
            ),
            Semantics(
              label: 'Alíquota ICMS',
              textField: true,
              child: TextField(
                controller: aliquotaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Alíquota ICMS (%)'),
              ),
            ),
            const SizedBox(height: 16),
            Semantics(
              label: 'Calcular ICMS',
              button: true,
              child: ElevatedButton(
                onPressed: calcularICMS,
                child: const Text('Calcular ICMS'),
              ),
            ),
            const SizedBox(height: 16),
            Text(resultado, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
