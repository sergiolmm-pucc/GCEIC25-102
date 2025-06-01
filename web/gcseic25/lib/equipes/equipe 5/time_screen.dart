import 'package:flutter/material.dart';

class TimeScreen extends StatefulWidget {
  @override
  _TimeScreenState createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen> {
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _velocityController = TextEditingController();
  final TextEditingController _kmPerLiterController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();

  String _result = '';

  void _calculateTime() {
    final double? distance = double.tryParse(_distanceController.text);
    final double? velocity = double.tryParse(_velocityController.text);
    final double? kmPerLiter = double.tryParse(_kmPerLiterController.text);
    final int? people = int.tryParse(_peopleController.text);

    if (distance == null ||
        velocity == null ||
        velocity == 0 ||
        kmPerLiter == null ||
        people == null ||
        people == 0) {
      setState(() {
        _result = 'Preencha todos os campos corretamente!';
      });
      return;
    }

    final double time = distance / velocity;
    setState(() {
      _result =
          'Tempo estimado: ${time.toStringAsFixed(2)} horas\n'
          'Consumo total: ${(distance / kmPerLiter).toStringAsFixed(2)} litros\n'
          'Consumo por pessoa: ${(distance / kmPerLiter / people).toStringAsFixed(2)} litros/pessoa';
    });
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
                    // Botão sem funcionalidade de cálculo
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
