import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'financas_result.dart';

class ResultsScreen extends StatelessWidget {
  final FinancasResult resultado;

  const ResultsScreen({super.key, required this.resultado});

  List<PieChartSectionData> showingSections() {
    return [
      PieChartSectionData(
        color: Colors.greenAccent,
        value: resultado.saldoFinal < 0 ? 0 : resultado.saldoFinal,
        title:
            'Saldo\nR\$${(resultado.saldoFinal < 0 ? 0 : resultado.saldoFinal).toStringAsFixed(2)}',
        radius: 70,
        titleStyle:
            TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      PieChartSectionData(
        color: Colors.cyanAccent,
        value: resultado.valorInvestimento,
        title: 'Investimento\nR\$${resultado.valorInvestimento.toStringAsFixed(2)}',
        radius: 70,
        titleStyle:
            TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      PieChartSectionData(
        color: Colors.deepPurpleAccent,
        value: resultado.valorLazer,
        title: 'Lazer\nR\$${resultado.valorLazer.toStringAsFixed(2)}',
        radius: 70,
        titleStyle:
            TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      PieChartSectionData(
        color: Colors.redAccent,
        value: resultado.gastosTotais,
        title: 'Gastos\nR\$${resultado.gastosTotais.toStringAsFixed(2)}',
        radius: 70,
        titleStyle:
            TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      PieChartSectionData(
        color: Colors.orangeAccent,
        value: resultado.inss + resultado.irpf,
        title: 'INSS+IRPF\nR\$${(resultado.inss + resultado.irpf).toStringAsFixed(2)}',
        radius: 70,
        titleStyle:
            TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            Text(
              'Seu resumo financeiro:',
              style:
                  TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 24),
            AspectRatio(
              aspectRatio: 1.3,
              child: PieChart(
                PieChartData(
                  sections: showingSections(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            SizedBox(height: 36),
            buildRow("Salário Bruto",
                resultado.salarioLiquido + resultado.inss + resultado.irpf + resultado.gastosTotais),
            buildRow("Imposto de Renda + INSS", resultado.inss + resultado.irpf),
            buildRow("Total de Gastos Fixos", resultado.gastosTotais),
            SizedBox(height: 12),
            Text(
              "Salário Líquido",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
            ),
            buildRow("Valor para Investir", resultado.valorInvestimento),
            buildRow("Valor para Lazer", resultado.valorLazer),
            buildRow("Saldo Final", resultado.saldoFinal < 0 ? 0 : resultado.saldoFinal),
            SizedBox(height: 36),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
                foregroundColor: Colors.black,
                minimumSize: Size(double.infinity, 48),
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('Calcular Novamente',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  Widget buildRow(String label, double valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white70, fontSize: 16)),
          Text('R\$ ${valor.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}
