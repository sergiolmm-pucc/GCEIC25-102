import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'sobre.dart';
import 'ajuda.dart';
import 'calculo_icms.dart';
import 'calculo_ipi.dart';
import 'estrutura_impostos.dart';
import 'calculo_pis_cofins.dart';
import 'nota_fiscal_page.dart';

class UsoAppPage extends StatefulWidget {
  @override
  _UsoAppPageState createState() => _UsoAppPageState();
}

class _UsoAppPageState extends State<UsoAppPage> {
  String resultado = 'Clique para consultar a API.';
  EstruturaImpostos estruturaImpostos = EstruturaImpostos(
    valor_produto: 0.0,
    icms: 0.0,
    pis: 0.0,
    cofins: 0.0,
    ipi: 0.0,
  );

  Future<void> consultarAPI() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/imposto/'),
      ); // substitua pelo seu endpoint
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
              onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (_) => NotaFiscalPage()))},
              child: Text('Nota Fiscal'),
            ),
            SizedBox(height: 20),
            Text(resultado),
            Divider(height: 40),
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SobrePage()),
                  ),
              child: Text('Sobre a Equipe'),
            ),
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AjudaPage()),
                  ),
              child: Text('Ajuda'),
            ),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => CalculoIcmsPage(
                          title: 'Cálculo ICMS',
                          estruturaImpostos: estruturaImpostos,
                        ),
                  ),
                );
                // Atualiza a tela principal ao voltar da tela de cálculo
                setState(() {});
              },
              child: Text('Cálculo ICMS'),
            ),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CalculoIpiPage(
                      title: 'Cálculo IPI',
                      estruturaImpostos: estruturaImpostos,
                    ),
                  ),
                );
                // Atualiza a tela principal ao voltar da tela de cálculo
                setState(() {});
              },
              child: Text('Cálculo IPI'),
            ),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => PisCofinsPage(
                          title: 'Cálculo de PIS/COFINS',
                          estruturaImpostos: estruturaImpostos,
                        ),
                  ),
                );
                // Atualiza a tela principal ao voltar da tela de cálculo
                setState(() {});
              },
              child: Text('Cálculo de PIS/COFINS'),
            ),
            Text(
              'Estrutura de Impostos: ICMS: ${estruturaImpostos.icms}, PIS: ${estruturaImpostos.pis}, COFINS: ${estruturaImpostos.cofins}, IPI: ${estruturaImpostos.ipi}',
            ),
          ],
        ),
      ),
    );
  }
}
