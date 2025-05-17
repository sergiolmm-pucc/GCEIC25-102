import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _formKey = GlobalKey<FormState>();

  int containers = 1;
  String containerSize = '40ft';
  String finishLevel = 'basico';
  String foundationType = 'sapata';
  String insulation = 'nenhum';
  bool electricity = false;
  bool plumbing = false;
  bool solarEnergy = false;
  int windows = 2;
  int doors = 1;
  bool customFurniture = false;
  bool projectReady = true;
  double distance = 0;
  int rooms = 1;

  double? result;

  Future<void> calculateCost() async {
    final url = Uri.parse('http://localhost:3000/calcular-custo-casa-container');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "containers": containers,
        "container_size": containerSize,
        "finish_level": finishLevel,
        "foundation_type": foundationType,
        "insulation": insulation,
        "electricity": electricity,
        "plumbing": plumbing,
        "solar_energy": solarEnergy,
        "windows": windows,
        "doors": doors,
        "custom_furniture": customFurniture,
        "project_ready": projectReady,
        "distance": distance,
        "rooms": rooms,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        result = data['custoTotal'].toDouble();
      });
    } else {
      setState(() {
        result = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao calcular o custo.")),
      );
    }
  }

  Widget _buildNumberField(String label, int initialValue, Function(int) onChanged) {
    return TextFormField(
      initialValue: initialValue.toString(),
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      onChanged: (value) => onChanged(int.tryParse(value) ?? initialValue),
    );
  }

  Widget _buildDoubleField(String label, double initialValue, Function(double) onChanged) {
    return TextFormField(
      initialValue: initialValue.toString(),
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      onChanged: (value) => onChanged(double.tryParse(value) ?? initialValue),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculadora de Casa Contêiner')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildNumberField("Quantidade de Contêineres", containers, (v) => containers = v),
              DropdownButtonFormField<String>(
                value: containerSize,
                items: ['40ft', '20ft']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => containerSize = v!),
                decoration: InputDecoration(labelText: "Tamanho do Contêiner"),
              ),
              DropdownButtonFormField<String>(
                value: finishLevel,
                items: ['basico', 'intermediario', 'luxo']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => finishLevel = v!),
                decoration: InputDecoration(labelText: "Nível de Acabamento"),
              ),
              DropdownButtonFormField<String>(
                value: foundationType,
                items: ['sapata', 'radier', 'pilotis']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => foundationType = v!),
                decoration: InputDecoration(labelText: "Tipo de Fundação"),
              ),
              DropdownButtonFormField<String>(
                value: insulation,
                items: ['nenhum', 'poliuretano', 'lã de rocha']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => insulation = v!),
                decoration: InputDecoration(labelText: "Isolamento"),
              ),
              SwitchListTile(
                title: Text("Instalação Elétrica"),
                value: electricity,
                onChanged: (v) => setState(() => electricity = v),
              ),
              SwitchListTile(
                title: Text("Hidráulica"),
                value: plumbing,
                onChanged: (v) => setState(() => plumbing = v),
              ),
              SwitchListTile(
                title: Text("Energia Solar"),
                value: solarEnergy,
                onChanged: (v) => setState(() => solarEnergy = v),
              ),
              _buildNumberField("Janelas", windows, (v) => windows = v),
              _buildNumberField("Portas", doors, (v) => doors = v),
              SwitchListTile(
                title: Text("Móveis Planejados"),
                value: customFurniture,
                onChanged: (v) => setState(() => customFurniture = v),
              ),
              SwitchListTile(
                title: Text("Projeto Pronto"),
                value: projectReady,
                onChanged: (v) => setState(() => projectReady = v),
              ),
              _buildDoubleField("Distância (km)", distance, (v) => distance = v),
              _buildNumberField("Quantidade de Cômodos", rooms, (v) => rooms = v),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: calculateCost,
                child: Text("Calcular Custo"),
              ),
              if (result != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Custo Total: R\$ ${result!.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
