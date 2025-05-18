import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CalculoIpiPage extends StatefulWidget {
  final String title;
  const CalculoIpiPage({super.key, required this.title});

  @override
  State<CalculoIpiPage> createState() => _CalculoIpiPageState();
}

class _CalculoIpiPageState extends State<CalculoIpiPage> {
  final valorController = TextEditingController();
  final aliquotaController = TextEditingController();
  final quantidadeController = TextEditingController();
  String resultado = '';
  double valor_ipi_total = 0.0;
  double valor_produto = 0.0;
  double aliquota_ipi = 0.0;
  double quantidade = 0.0;

  Future<void> calcularIPI() async {
    final valor = valorController.text;
    final aliquota = aliquotaController.text;
    final quantidade = quantidadeController.text;

    if (valor.isEmpty || aliquota.isEmpty || quantidade.isEmpty) {
      setState(() => resultado = 'Preencha todos os campos.');
      return;
    }

    try {
      final url = Uri.parse(
        'http://localhost:3000/imposto/calculo-ipi?valor_produto=$valor&aliquota_ipi=$aliquota&quantidade=$quantidade',
      );
      final resp = await http.get(url);
      
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        setState(() {
          valor_ipi_total = data['valor_ipi_total']?.toDouble() ?? 0.0;
          valor_produto = data['valor_produto']?.toDouble() ?? 0.0;
          aliquota_ipi = data['aliquota_ipi']?.toDouble() ?? 0.0;
          this.quantidade = data['quantidade']?.toDouble() ?? 0.0;
          
          resultado =
              'Valor unitário: R\$ $valor_produto\n'
              'Quantidade: ${this.quantidade}\n'
              'Alíquota IPI: $aliquota_ipi%\n'
              'Valor do IPI: R\$ $valor_ipi_total\n'
              'Valor total: R\$ ${(valor_produto * this.quantidade) + valor_ipi_total}';
        });
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setDouble('valor_ipi_total', valor_ipi_total);
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
            TextField(
              controller: valorController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Valor unitário do produto'),
            ),
            TextField(
              controller: quantidadeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantidade'),
            ),
            TextField(
              controller: aliquotaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Alíquota IPI (%)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: calcularIPI,
              child: const Text('Calcular IPI'),
            ),
            const SizedBox(height: 16),
            Text(resultado, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}