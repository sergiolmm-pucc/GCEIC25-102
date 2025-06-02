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
  bool isLoading = false;

  Future<void> calculateCost() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('https://sincere-magnificent-cobweb.glitch.me/calcular-custo-casa-container');

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

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        result = data['custoTotal']?.toDouble();
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

  Widget _numberField(String label, int initial, Function(int) onChanged) {
    return TextFormField(
      key: ValueKey(label),
      initialValue: initial.toString(),
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      onChanged: (v) => onChanged(int.tryParse(v) ?? initial),
    );
  }

  Widget _doubleField(String label, double initial, Function(double) onChanged) {
    return TextFormField(
      key: ValueKey(label),
      initialValue: initial.toString(),
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      onChanged: (v) => onChanged(double.tryParse(v) ?? initial),
    );
  }

  Widget _dropdown(String label, String currentValue, List<String> options, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      key: ValueKey(label),
      decoration: InputDecoration(labelText: label),
      value: currentValue,
      onChanged: onChanged,
      items: options.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
    );
  }

  Widget _switch(String label, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      key: ValueKey(label),
      title: Text(label),
      value: value,
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de Casa Contêiner'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _numberField('Quantidade de Contêineres', containers, (v) => setState(() => containers = v)),
              _dropdown('Tamanho do Contêiner', containerSize, ['40ft', '20ft'], (v) => setState(() => containerSize = v!)),
              _dropdown('Nível de Acabamento', finishLevel, ['basico', 'intermediario', 'luxo'], (v) => setState(() => finishLevel = v!)),
              _dropdown('Tipo de Fundação', foundationType, ['sapata', 'radier', 'pilotis'], (v) => setState(() => foundationType = v!)),
              _dropdown('Isolamento', insulation, ['nenhum', 'poliuretano', 'lã de rocha'], (v) => setState(() => insulation = v!)),

              _switch('Instalação Elétrica', electricity, (v) => setState(() => electricity = v)),
              _switch('Hidráulica', plumbing, (v) => setState(() => plumbing = v)),
              _switch('Energia Solar', solarEnergy, (v) => setState(() => solarEnergy = v)),

              _numberField('Janelas', windows, (v) => setState(() => windows = v)),
              _numberField('Portas', doors, (v) => setState(() => doors = v)),

              _switch('Móveis Planejados', customFurniture, (v) => setState(() => customFurniture = v)),
              _switch('Projeto Pronto', projectReady, (v) => setState(() => projectReady = v)),

              _doubleField('Distância (km)', distance, (v) => setState(() => distance = v)),
              _numberField('Quantidade de Cômodos', rooms, (v) => setState(() => rooms = v)),

              SizedBox(height: 24),

              Semantics(
                label: 'Botão Calcular Custo',
                button: true,
                child: ElevatedButton(
                  key: Key('BotaoCalcularCusto'),
                  onPressed: isLoading ? null : calculateCost,
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Calcular Custo'),
                ),
              ),

              if (result != null)
                Semantics(
                  label: 'Resultado do Custo Total',
                  readOnly: true,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Text(
                      'Custo Total: R\$ ${result!.toStringAsFixed(2)}',
                      key: Key('ResultadoCustoTotal'),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
