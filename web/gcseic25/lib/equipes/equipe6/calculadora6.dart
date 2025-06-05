import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Calculadora6Page extends StatefulWidget {
  @override
  _Calculadora6PageState createState() => _Calculadora6PageState();
}

class _Calculadora6PageState extends State<Calculadora6Page> {
  final TextEditingController _salarioController = TextEditingController();
  String? _inss;
  String? _fgts;
  String? _salarioLiquido;
  String? _necessidades;
  String? _lazer;
  String? _poupanca;
  String? _error;
  bool _loading = false;

  Future<void> calcularSalario() async {
    final salarioStr = _salarioController.text;
    if (salarioStr.isEmpty) {
      setState(() {
        _error = "Informe o salário";
      });
      return;
    }

    final salario = double.tryParse(salarioStr);
    if (salario == null) {
      setState(() {
        _error = "Salário inválido";
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final response = await http.post(
        Uri.parse('https://sincere-magnificent-cobweb.glitch.me/equipe6'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'salario': salario}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final divisao = data['sugestaoDivisao'] ?? {};

        setState(() {
          _inss = data['inss'];
          _fgts = data['fgts'];
          _salarioLiquido = data['salarioLiquido'];
          _necessidades = divisao['necessidades'];
          _lazer = divisao['lazer'];
          _poupanca = divisao['poupanca'];
          _error = null;
        });
      } else {
        final errorData = jsonDecode(response.body);
        setState(() {
          _error = errorData['error'] ?? "Erro ao calcular salário";
          _inss = null;
          _fgts = null;
          _salarioLiquido = null;
          _necessidades = null;
          _lazer = null;
          _poupanca = null;
        });
      }
    } catch (e) {
      setState(() {
        _error = "Erro na conexão: $e";
        _inss = null;
        _fgts = null;
        _salarioLiquido = null;
        _necessidades = null;
        _lazer = null;
        _poupanca = null;
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _salarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora Equipe 6'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _salarioController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Salário bruto',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : calcularSalario,
              child: _loading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Calcular'),
            ),
            SizedBox(height: 24),
            if (_error != null)
              Text(
                _error!,
                style: TextStyle(color: Colors.red),
              ),
            if (_inss != null && _fgts != null && _salarioLiquido != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('INSS: R\$ $_inss'),
                  Text('FGTS: R\$ $_fgts'),
                  Text('Salário Líquido: R\$ $_salarioLiquido'),
                  SizedBox(height: 16),
                  Text(
                    'Sugestão de divisão (40/30/30):',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('• Necessidades: R\$ $_necessidades'),
                  Text('• Lazer: R\$ $_lazer'),
                  Text('• Poupança: R\$ $_poupanca'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}