import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'sobre.dart';
import 'ajuda.dart';
import 'calculo_icms.dart';

class UsoAppPage extends StatefulWidget {
  @override
  _UsoAppPageState createState() => _UsoAppPageState();
}

class _UsoAppPageState extends State<UsoAppPage> {
  String resultado = 'Clique para consultar a API.';

  Future<void> consultarAPI() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/imposto/')); // substitua pelo seu endpoint
      if (response.statusCode == 200) {
        setState(() {
          resultado = response.body;
        });
      } else {
        setState(() {
          resultado = 'Erro: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        resultado = 'Erro de conexão.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tela Principal da Equipe')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: consultarAPI,
              child: Text('Consultar API'),
            ),
            SizedBox(height: 20),
            Text(resultado),
            Divider(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SobrePage())),
              child: Text('Sobre a Equipe'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AjudaPage())),
              child: Text('Ajuda'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CalculoIcmsPage(title: 'Cálculo ICMS'))),
              child: Text('Cálculo ICMS'),
            ),
          ],
        ),
      ),
    );
  }
}
