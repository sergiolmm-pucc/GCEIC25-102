import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'estrutura_impostos.dart';

class PisCofinsPage extends StatefulWidget {
  final String title;
  final EstruturaImpostos estruturaImpostos;

  const PisCofinsPage({required this.title, required this.estruturaImpostos});

  @override
  _PisCofinsPageState createState() => _PisCofinsPageState();
}

class _PisCofinsPageState extends State<PisCofinsPage> {
  String _responseText = 'O resultado do cálculo aparecerá aqui.';
  String _regime = 'cumulativo';
  final TextEditingController _receitaBrutaController = TextEditingController();
  final TextEditingController _aliquotaController = TextEditingController();
  
  Future<void> _calcularPisCofins() async {
    if (_receitaBrutaController.text.isEmpty || _aliquotaController.text.isEmpty) {
      setState(() {
        _responseText = 'Por favor, preencha todos os campos.';
      });
      return;
    }
    
    try {
      final double receitaBruta = double.parse(_receitaBrutaController.text);
      final double aliquota = double.parse(_aliquotaController.text);
      
      final response = await http.post(
        Uri.parse('https://sincere-magnificent-cobweb.glitch.me/imposto/calcular-pis-cofins'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'regime': _regime,
          'receitaBruta': receitaBruta,
          'aliquota': aliquota
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          setState(() {
            _responseText = '''
            Regime: ${data['resultado']['regime']}
            Receita Bruta: ${data['resultado']['receitaBruta'].toStringAsFixed(2)}
            Valor PIS: ${data['resultado']['valorPis'].toStringAsFixed(2)}
            Valor COFINS: ${data['resultado']['valorCofins'].toStringAsFixed(2)}
            Total: ${data['resultado']['total'].toStringAsFixed(2)}
            ''';
            widget.estruturaImpostos.pis = data['resultado']['valorPis'];
            widget.estruturaImpostos.cofins = data['resultado']['valorCofins'];
          });
        } else {
          setState(() {
            _responseText = 'Erro: ${data['message'] ?? 'Erro desconhecido'}';
          });
        }
      } else {
        setState(() {
          _responseText = 'Erro ao comunicar com o servidor: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _responseText = 'Erro: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Cálculo de PIS/COFINS',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            
            // Seleção de regime
            Text('Regime Tributário:', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Cumulativo'),
                    value: 'cumulativo',
                    groupValue: _regime,
                    onChanged: (value) {
                      setState(() {
                        _regime = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Não Cumulativo'),
                    value: 'nao_cumulativo',
                    groupValue: _regime,
                    onChanged: (value) {
                      setState(() {
                        _regime = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            
            // Campo de receita bruta
            TextField(
              controller: _receitaBrutaController,
              decoration: InputDecoration(
                labelText: 'Receita Bruta (R\$)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 16),
            
            // Campo de alíquota
            TextField(
              controller: _aliquotaController,
              decoration: InputDecoration(
                labelText: 'Alíquota (%)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 24),
            
            // Botão para calcular
            ElevatedButton(
              onPressed: _calcularPisCofins,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Calcular PIS/COFINS', style: TextStyle(fontSize: 16)),
              ),
            ),
            SizedBox(height: 24),
            
            // Resultado
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                _responseText,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}