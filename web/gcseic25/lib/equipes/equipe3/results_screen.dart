import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'financas_result.dart';
import 'salary_input.dart';

class ResultsScreen extends StatelessWidget {
  final FinancasResult resultado;

  const ResultsScreen({super.key, required this.resultado});

  List<PieChartSectionData> showingSections() {
    return [
      PieChartSectionData(
        color: Colors.greenAccent,
        value: resultado.saldoFinal < 0 ? 0 : resultado.saldoFinal,
        title: '',
        radius: 90,
      ),
      PieChartSectionData(
        color: Colors.cyanAccent,
        value: resultado.valorInvestimento,
        title: '',
        radius: 90,
      ),
      PieChartSectionData(
        color: Colors.deepPurpleAccent,
        value: resultado.valorLazer,
        title: '',
        radius: 90,
      ),
      PieChartSectionData(
        color: Colors.redAccent,
        value: resultado.gastosTotais,
        title: '',
        radius: 90,
      ),
      PieChartSectionData(
        color: Colors.orangeAccent,
        value: resultado.inss + resultado.irpf,
        title: '',
        radius: 90,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Resumo Financeiro Mensal'),
        backgroundColor: Colors.cyanAccent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Coluna do gráfico com texto acima
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Representação Gráfica',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                        sections: showingSections(),
                        sectionsSpace: 3,
                        centerSpaceRadius: 50,
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  buildLegend(
                    Colors.greenAccent,
                    'Saldo',
                    resultado.saldoFinal < 0 ? 0 : resultado.saldoFinal,
                  ),
                  buildLegend(
                    Colors.cyanAccent,
                    'Investimento',
                    resultado.valorInvestimento,
                  ),
                  buildLegend(
                    Colors.deepPurpleAccent,
                    'Lazer',
                    resultado.valorLazer,
                  ),
                  buildLegend(
                    Colors.orangeAccent,
                    'INSS + IRPF',
                    resultado.inss + resultado.irpf,
                  ),
                  buildLegend(
                    Colors.redAccent,
                    'Gastos',
                    resultado.gastosTotais,
                  ),
                ],
              ),
            ),

            SizedBox(width: 50),

            // Coluna do resumo financeiro
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Seu resumo financeiro:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Tabela para alinhamento do resumo financeiro
                  Table(
                    columnWidths: {
                      0: FlexColumnWidth(3),
                      1: FlexColumnWidth(2),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      _buildTableRow("Salário Bruto", resultado.salarioLiquido + resultado.inss + resultado.irpf + resultado.gastosTotais),
                      _buildTableRow("Imposto de Renda + INSS", resultado.inss + resultado.irpf),
                      _buildTableRow("Total de Gastos Fixos", resultado.gastosTotais),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "Salário Líquido",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                          ),
                        ),
                        SizedBox(), // vazio para alinhar
                      ]),
                      _buildTableRow("Valor para Investir", resultado.valorInvestimento),
                      _buildTableRow("Valor para Lazer", resultado.valorLazer),
                      _buildTableRow("Saldo Final", resultado.saldoFinal < 0 ? 0 : resultado.saldoFinal),
                    ],
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: 180,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const SalaryInputScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text('Calcular Novamente', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, double valor) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(label, style: TextStyle(color: Colors.white70, fontSize: 16)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(
          'R\$ ${valor.toStringAsFixed(2)}',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          textAlign: TextAlign.right,
        ),
      ),
    ]);
  }

  Widget buildLegend(Color color, String label, double valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, left: 4),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(color: color, shape: BoxShape.rectangle),
          ),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              '$label: R\$ ${valor.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.white70, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
