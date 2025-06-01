import 'package:flutter/material.dart';

class GasScreen extends StatefulWidget {
  @override
  _GasScreenState createState() => _GasScreenState();
}

class _GasScreenState extends State<GasScreen> {
  final TextEditingController distanceController = TextEditingController();
  final TextEditingController consumptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  String result = '';

  void calculateGas() {
    final double? distance = double.tryParse(distanceController.text);
    final double? consumption = double.tryParse(consumptionController.text);
    final double? price = double.tryParse(priceController.text);

    if (distance == null ||
        consumption == null ||
        consumption == 0 ||
        price == null) {
      setState(() {
        result = 'Preencha todos os campos corretamente!';
      });
      return;
    }

    final double litersNeeded = distance / consumption;
    final double totalCost = litersNeeded * price;

    setState(() {
      result =
          'Litros necessários: ${litersNeeded.toStringAsFixed(2)} L\n'
          'Custo total: R\$ ${totalCost.toStringAsFixed(2)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de Combustível'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: distanceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Distância (km)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: consumptionController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Consumo do veículo (km/l)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Preço do combustível (R\$)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(onPressed: calculateGas, child: Text('Calcular')),
              SizedBox(height: 24),
              Text(
                result,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
