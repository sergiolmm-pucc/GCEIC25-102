import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PiscinaPage extends StatefulWidget {
  final String title;

  const PiscinaPage({this.title = 'Página da Piscina', Key? key}) : super(key: key);

  @override
  _PiscinaPageState createState() => _PiscinaPageState();
}

class _PiscinaPageState extends State<PiscinaPage> {
  final larguraController = TextEditingController();
  final comprimentoController = TextEditingController();
  final profundidadeController = TextEditingController();
  String resultado = 'Preencha os campos e clique em calcular.';

  Future<void> calcularPiscina() async {
    final largura = double.tryParse(larguraController.text) ?? 0;
    final comprimento = double.tryParse(comprimentoController.text) ?? 0;
    final profundidade = double.tryParse(profundidadeController.text) ?? 0;

    final url = Uri.parse('https://sincere-magnificent-cobweb.glitch.me/calcularPiscina');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'largura': largura,
        'comprimento': comprimento,
        'profundidade': profundidade,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        resultado = '''
Volume: ${data['litros']} litros
Custo Àgua: R\$ ${data['custoAgua']}
Gasto Mensal: R\$ ${data['manutencaoMensal']}
Custo Eletrica: R\$ ${data['custoEletrica']}
Custo Hidraulica: R\$ ${data['custoHidraulica']}
Custo Total: R\$ ${data['custoTotal']}
''';
      });
    } else {
      setState(() {
        resultado = 'Erro ao consultar API.';
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
              controller: larguraController,
              decoration: InputDecoration(labelText: 'Largura da piscina (m)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: comprimentoController,
              decoration: InputDecoration(labelText: 'Comprimento da piscina (m)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: profundidadeController,
              decoration: InputDecoration(labelText: 'Profundidade média (m)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: calcularPiscina,
              child: Text('Calcular'),
            ),
            SizedBox(height: 20),
            Text(
              resultado,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
