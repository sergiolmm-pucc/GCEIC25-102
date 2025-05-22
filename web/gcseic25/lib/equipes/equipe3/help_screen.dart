import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajuda - Gestor de Finanças'),
        backgroundColor: Colors.cyanAccent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(  // Centraliza o conteúdo
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600), // limitar largura pra melhor leitura
            child: const Text(
              '''Como usar o app Gestor de Finanças:

O Gestor de Finanças é um aplicativo Flutter para planejamento financeiro pessoal mensal, que consome uma API Node.js para cálculos financeiros.

Você deve informar:

- Seu salário bruto mensal.
- Seus gastos fixos (nome e valor).
- Percentuais para investimento e lazer.

O app calcula:

- INSS e IRPF com base em tabelas oficiais de 2025.
- Salário líquido.
- Valores para investimento, lazer e saldo final.

Tela inicial: Entrada do salário bruto.
Depois, você adiciona gastos fixos.
Em seguida, define percentuais para investimento e lazer.
Por fim, visualiza o resumo financeiro com gráfico de pizza e valores detalhados.

OBS: O login é fixo, com usuário admin e senha admin123.
''',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center, // texto centralizado
            ),
          ),
        ),
      ),
    );
  }
}
