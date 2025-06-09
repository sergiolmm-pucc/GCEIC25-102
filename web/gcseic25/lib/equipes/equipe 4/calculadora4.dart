import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Calculadora4Page extends StatefulWidget {
  const Calculadora4Page({super.key});

  @override
  State<Calculadora4Page> createState() => _Calculadora4PageState();
}

class _Calculadora4PageState extends State<Calculadora4Page> {
  final TextEditingController _salarioController = TextEditingController();
  Map<String, dynamic>? _resultado;
  String _erro = '';

  Future<void> _calcularEncargos() async {
    final salario = double.tryParse(_salarioController.text);
    if (salario == null || salario <= 0) {
      setState(() {
        _erro = 'Digite um salário válido.';
        _resultado = null;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://sincere-magnificent-cobweb.glitch.me/ETEC/calcularequipe4'), // ou 10.0.2.2 se for emulador Android
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'salario': salario}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _resultado = data;
          _erro = '';
        });
      } else {
        setState(() {
          _erro = 'Erro ao calcular encargos. Código: ${response.statusCode}';
          _resultado = null;
        });
      }
    } catch (e) {
      setState(() {
        _erro = 'Erro ao conectar à API.';
        _resultado = null;
      });
    }
  }

  Widget _buildResultado() {
    if (_resultado == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Salário: R\$ ${_resultado!['salario'].toStringAsFixed(2)}'),
        Text('INSS: R\$ ${_resultado!['inss'].toStringAsFixed(2)}'),
        Text('FGTS: R\$ ${_resultado!['fgts'].toStringAsFixed(2)}'),
        Text('Férias: R\$ ${_resultado!['ferias'].toStringAsFixed(2)}'),
        Text('13º Salário: R\$ ${_resultado!['decimoTerceiro'].toStringAsFixed(2)}'),
        const Divider(),
        Text(
          'Total de Encargos: R\$ ${_resultado!['totalEncargos'].toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cálculo Grupo 4')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Digite o salário para calcular os encargos trabalhistas:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _salarioController,
              decoration: const InputDecoration(
                labelText: 'Salário (ex: 2000)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calcularEncargos,
              child: const Text('Calcular Encargos'),
            ),
            const SizedBox(height: 20),
            if (_erro.isNotEmpty)
              Text(
                _erro,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 10),
            if (_resultado != null) _buildResultado(),
          ],
        ),
      ),
    );
  }
}