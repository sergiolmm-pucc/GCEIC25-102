import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import necessário para TextInputFormatter

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
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Botão sem funcionalidade de cálculo
                  //aqui deve enviar para 'https://sincere-magnificent-cobweb.glitch.me/calculadoraViagem/calcular'
                  /* 
                  final url = Uri.parse('https://sincere-magnificent-cobweb.glitch.me/calculadoraViagem/calcular');
                  final response = await http.post(
                    url,
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode({}),
                  ); */

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
}
