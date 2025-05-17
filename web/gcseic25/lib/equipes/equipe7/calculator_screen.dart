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
    backgroundColor: Colors.white,
    appBar: AppBar(
      title: Text('Calculadora de Casa Contêiner'),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    body: SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildNumberField("Quantidade de Contêineres", containers, (v) => containers = v),
            SizedBox(height: 16),
            _styledDropdown("Tamanho do Contêiner", containerSize, ['40ft', '20ft'], (v) => setState(() => containerSize = v!)),
            SizedBox(height: 16),
            _styledDropdown("Nível de Acabamento", finishLevel, ['basico', 'intermediario', 'luxo'], (v) => setState(() => finishLevel = v!)),
            SizedBox(height: 16),
            _styledDropdown("Tipo de Fundação", foundationType, ['sapata', 'radier', 'pilotis'], (v) => setState(() => foundationType = v!)),
            SizedBox(height: 16),
            _styledDropdown("Isolamento", insulation, ['nenhum', 'poliuretano', 'lã de rocha'], (v) => setState(() => insulation = v!)),
            SizedBox(height: 16),
            _styledSwitch("Instalação Elétrica", electricity, (v) => setState(() => electricity = v)),
            _styledSwitch("Hidráulica", plumbing, (v) => setState(() => plumbing = v)),
            _styledSwitch("Energia Solar", solarEnergy, (v) => setState(() => solarEnergy = v)),
            SizedBox(height: 16),
            _buildNumberField("Janelas", windows, (v) => windows = v),
            SizedBox(height: 16),
            _buildNumberField("Portas", doors, (v) => doors = v),
            SizedBox(height: 16),
            _styledSwitch("Móveis Planejados", customFurniture, (v) => setState(() => customFurniture = v)),
            _styledSwitch("Projeto Pronto", projectReady, (v) => setState(() => projectReady = v)),
            SizedBox(height: 16),
            _buildDoubleField("Distância (km)", distance, (v) => distance = v),
            SizedBox(height: 16),
            _buildNumberField("Quantidade de Cômodos", rooms, (v) => rooms = v),
            SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: calculateCost,
              child: Text("Calcular Custo"),
            ),
            if (result != null)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text(
                  "Custo Total: R\$ ${result!.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

Widget _styledDropdown(String label, String currentValue, List<String> options, ValueChanged<String?> onChanged) {
  return DropdownButtonFormField<String>(
    value: currentValue,
    items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
    onChanged: onChanged,
    style: TextStyle(color: Colors.black),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.black),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    dropdownColor: Colors.white,
  );
}

Widget _styledSwitch(String label, bool value, ValueChanged<bool> onChanged) {
  return SwitchListTile(
    title: Text(label, style: TextStyle(color: Colors.black)),
    value: value,
    onChanged: onChanged,
    activeColor: Colors.black,
    contentPadding: EdgeInsets.zero,
  );
}

}
