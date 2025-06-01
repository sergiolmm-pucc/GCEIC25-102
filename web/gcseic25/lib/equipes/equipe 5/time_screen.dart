import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import necessário para TextInputFormatter
import 'dart:convert';
import 'package:http/http.dart' as http;

class TimeScreen extends StatefulWidget {
  @override
  _TimeScreenState createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen> {
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _velocityController = TextEditingController();

  String _result = '';
  void _calculateTime() async {
    debugPrint('Método _calculateTime chamado');

    final double? distance = double.tryParse(_distanceController.text);
    final double? velocity = double.tryParse(_velocityController.text);

    debugPrint('Distância: $distance, Velocidade: $velocity');

    if (distance == null || velocity == null || velocity == 0) {
      setState(() {
        _result = 'Preencha todos os campos corretamente!';
      });
      debugPrint('Campos inválidos ou velocidade igual a 0');
      return;
    }

    try {
      final tempoUrl = Uri.parse(
        'http://localhost:3000/calculadoraViagem/estimativa-tempo',
      );

      debugPrint('URL: $tempoUrl');

      final tempoResponse = await http.post(
        tempoUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"distancia": distance, "velocidadeMedia": velocity}),
      );

      debugPrint('Resposta do servidor: ${tempoResponse.body}');

      if (tempoResponse.statusCode != 200) {
        throw Exception("Erro ao calcular tempo estimado");
      }

      if (tempoResponse.statusCode == 200) {
        final resultado = jsonDecode(tempoResponse.body)['payload'];


        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Resultado da Estimativa"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Tempo estimado em horas:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "${resultado['tempoEstimadoHoras'].toStringAsFixed(2)} horas",
                ),
                SizedBox(height: 8),
                Text(
                  "Tempo estimado total:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "${resultado['tempoFormatado']}",
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } else {
        final error = jsonDecode(tempoResponse.body);
        throw Exception(error['message'] ?? 'Erro desconhecido');
      }
    } catch (e) {
      debugPrint('Erro na requisição: $e');

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Erro"),
          content: Text('Erro na requisição: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Estimativa de Tempo de Viagem',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _distanceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Distância (km)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _velocityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Velocidade Média (km/h)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _calculateTime();
                  },
                  child: const Text(
                    'CALCULAR',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
