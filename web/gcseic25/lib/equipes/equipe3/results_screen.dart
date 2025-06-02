import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'financas_result.dart';
import 'salary_input.dart';

class ResultsScreen extends StatelessWidget {
  final FinancasResult resultado;

  const ResultsScreen({super.key, required this.resultado});

  /// Gera as seções do PieChart usando os valores do resultado financeiro.
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

  /// Constrói uma linha de tabela com rótulo e valor formatado.
  TableRow _buildTableRow(String label, double valor) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            'R\$ ${valor.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  /// Constrói a linha da legenda abaixo do PieChart, mostrando cor, rótulo e valor.
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
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$label: R\$ ${valor.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Resumo Financeiro Mensal'),
        backgroundColor: Colors.cyanAccent,
        foregroundColor: Colors.black,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Defina um ponto de corte para larguras "wide" (desktop/web) vs "narrow" (mobile).
          const double breakpoint = 600;
          bool isWide = constraints.maxWidth >= breakpoint;

          // Mesma padding para ambos casos, mas adaptamos o layout.
          const EdgeInsets padding = EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20,
          );

          if (isWide) {
            // === LAYOUT PARA TELAS AMPLAS: Row com Gráfico à ESQUERDA e Resumo à DIREITA ===
            return Padding(
              padding: padding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // === Seção do Gráfico ===
                  Expanded(flex: 2, child: _buildChartSection()),

                  const SizedBox(width: 50),

                  // === Seção do Resumo Financeiro ===
                  Expanded(
                    flex: 3,
                    child: _buildSummarySection(isWide, context),
                  ),
                ],
              ),
            );
          } else {
            // === LAYOUT PARA TELAS NARROW (MÓVEL): Column com Gráfico em CIMA e Resumo em BAIXO ===
            return SingleChildScrollView(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildChartSection(),
                  const SizedBox(height: 30),
                  _buildSummarySection(isWide, context),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  /// Constrói a seção com o título "Representação Gráfica", o PieChart e a legenda.
  Widget _buildChartSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Representação Gráfica',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        // O AspectRatio força o PieChart a ser 1:1 (quadrado),
        // ocupando toda a largura disponível do pai.
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
        // Legenda
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
        buildLegend(Colors.deepPurpleAccent, 'Lazer', resultado.valorLazer),
        buildLegend(
          Colors.orangeAccent,
          'INSS + IRPF',
          resultado.inss + resultado.irpf,
        ),
        buildLegend(Colors.redAccent, 'Gastos', resultado.gastosTotais),
      ],
    );
  }

 
  Widget _buildSummarySection(bool isWide, BuildContext context) {
    return Column(
      crossAxisAlignment:
          isWide ? CrossAxisAlignment.center : CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Seu resumo financeiro:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 15),

        // TABELA PARA ALINHAMENTO DO RESUMO FINANCEIRO
        Table(
          columnWidths: const {0: FlexColumnWidth(3), 1: FlexColumnWidth(2)},
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            _buildTableRow(
              "Salário Bruto",
              resultado.salarioLiquido +
                  resultado.inss +
                  resultado.irpf +
                  resultado.gastosTotais,
            ),
            _buildTableRow(
              "Imposto de Renda + INSS",
              resultado.inss + resultado.irpf,
            ),
            _buildTableRow("Total de Gastos Fixos", resultado.gastosTotais),
            // Linha especial para destacar "Salário Líquido"
            const TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "Salário Líquido",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(), // vazio para alinhar
              ],
            ),
            _buildTableRow("Valor para Investir", resultado.valorInvestimento),
            _buildTableRow("Valor para Lazer", resultado.valorLazer),
            _buildTableRow(
              "Saldo Final",
              resultado.saldoFinal < 0 ? 0 : resultado.saldoFinal,
            ),
          ],
        ),

        const SizedBox(height: 30),
        // BOTÃO "Calcular Novamente"
        SizedBox(
          // Se for tela larga, fixa em 180px; se for tela estreita (mobile), ocupa 100% da largura
          width: isWide ? 180 : double.infinity,
          height: 48,
          child: ElevatedButton(
            key: const ValueKey('botaoCalcularNovamenteEquipeTres'),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SalaryInputScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyanAccent,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Calcular Novamente',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
