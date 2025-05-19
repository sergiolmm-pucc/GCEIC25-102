import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CalculoIcmsPage extends StatefulWidget {
  final String title;

  const CalculoIcmsPage({super.key, required this.title});

  @override
  _CalculoIcmsPageState createState() => _CalculoIcmsPageState();
}

class _CalculoIcmsPageState extends State<CalculoIcmsPage> {
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _aliquotaController = TextEditingController();
  String _responseText = 'Resultado aparecerá aqui.';

  Future<void> _calcularICMS() async {
    final valor = _valorController.text;
    final aliquota = _aliquotaController.text;

    if (valor.isEmpty || aliquota.isEmpty) {
      setState(() {
        _responseText = 'Preencha todos os campos.';
      });
      return;
    }

    try {
      final url = Uri.parse(
        'http://10.0.2.2:8080/imposto/icms?valor_produto=$valor&aliquota_icms=$aliquota',
      ); // ajuste conforme sua API

      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          _responseText = 'Valor do ICMS: ${response.body}';
        });
      } else {
        setState(() {
          _responseText = 'Erro: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _responseText = 'Erro na requisição: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _valorController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Valor do produto'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _aliquotaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Alíquota ICMS (%)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calcularICMS,
              child: Text('Calcular ICMS'),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(_responseText, style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
