import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import necessário para TextInputFormatter
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController distanceController = TextEditingController();
  final TextEditingController fuelPriceController = TextEditingController();
  final TextEditingController maintenanceController = TextEditingController();
  final TextEditingController tollController = TextEditingController();
  final TextEditingController otherExpensesController = TextEditingController();
  final TextEditingController kmPerLiterController = TextEditingController();
  final TextEditingController peopleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculadora de Viagem',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Calcule os custos da sua viagem',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: distanceController,
              decoration: const InputDecoration(
                labelText: 'Distância (em km)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: kmPerLiterController,
              decoration: const InputDecoration(
                labelText: 'Kilometragem por Litro (km/l)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: fuelPriceController,
              decoration: const InputDecoration(
                labelText: 'Preço do Combustível (R\$/litro)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: maintenanceController,
              decoration: const InputDecoration(
                labelText: 'Custo de Manutenção (R\$)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: tollController,
              decoration: const InputDecoration(
                labelText: 'Pedágios (R\$)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: otherExpensesController,
              decoration: const InputDecoration(
                labelText: 'Outras Despesas (R\$)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: peopleController,
              decoration: const InputDecoration(
                labelText: 'Número de pessoas: ',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  calcularViagem();
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
                  textStyle: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> calcularViagem() async {
    final double? distancia = double.tryParse(distanceController.text);
    final double? precoGasolina = double.tryParse(fuelPriceController.text);
    final double? precoManutencao = double.tryParse(maintenanceController.text);
    final double? pedagios = double.tryParse(tollController.text);
    final double? outros = double.tryParse(otherExpensesController.text);
    final double? kilometragemPorLitro = double.tryParse(
      kmPerLiterController.text,
    );
    final int? numPessoas = int.tryParse(peopleController.text);

    if (distancia == null ||
        kilometragemPorLitro == null ||
        precoGasolina == null ||
        numPessoas == null) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text("Erro"),
              content: const Text(
                "Preencha todos os campos obrigatórios: distância, km/L, preço da gasolina e número de pessoas.",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
      );
      return;
    }

    try {
      // 1. Requisição para consumo-estimado
      final consumoUrl = Uri.parse(
        'https://sincere-magnificent-cobweb.glitch.me/calculadoraViagem/consumo-estimado', // Em localhost por causa do erro no glitch
      );

      final consumoResponse = await http.post(
        consumoUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "distancia": distancia,
          "kilometragemPorLitro": kilometragemPorLitro,
        }),
      );

      if (consumoResponse.statusCode != 200) {
        throw Exception("Erro ao calcular consumo estimado");
      }

      final consumoData = jsonDecode(consumoResponse.body);
      final double totalLitros = consumoData['litrosNecessarios'];

      // 2. Requisição para calcular valor total
      final calcularUrl = Uri.parse(
        'https://sincere-magnificent-cobweb.glitch.me/calculadoraViagem/calcular', // Em localhost por causa do erro no glitch
      );

      final calcularResponse = await http.post(
        calcularUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "totalLitrosGasolina": totalLitros,
          "precoGasolina": precoGasolina,
          "precoManutencao": precoManutencao ?? 0,
          "pedagios": pedagios ?? 0,
          "outros": outros ?? 0,
          "numPessoas": numPessoas,
        }),
      );

      if (calcularResponse.statusCode == 200) {
        final resultado = jsonDecode(calcularResponse.body)['payload'];

        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text("Resultado"),
                content: Text(
                  "Litros estimados: ${resultado['totalLitrosGasolina'].toStringAsFixed(2)} L\n"
                  "Total com gasolina: R\$ ${resultado['totalGasolina'].toStringAsFixed(2)}\n"
                  "Custo total: R\$ ${resultado['precoTotal'].toStringAsFixed(2)}\n"
                  "Por pessoa: R\$ ${resultado['precoPorPessoa'].toStringAsFixed(2)}",
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
        final error = jsonDecode(calcularResponse.body);
        throw Exception(error['message'] ?? 'Erro desconhecido');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
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
}
