// PROJETO SERGIO NODE/web/gcseic25/lib/equipes/equipe2/help_screen_equipe2.dart
import 'package:flutter/material.dart';

class HelpScreenEquipe2 extends StatelessWidget {
  const HelpScreenEquipe2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajuda Equipe 2')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Guia Rápido de Uso da Calculadora de Viagens:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            SizedBox(height: 15),
            Text(
              'Este aplicativo permite que você estime o custo total da sua viagem ideal, personalizando diversos aspectos:',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            _HelpSection(
              title: '1. Selecione o País de Destino:',
              content: 'Escolha um dos 10 países disponíveis em nossa lista. Cada país possui um custo base pré-definido.',
            ),
            _HelpSection(
              title: '2. Temporada da Viagem:',
              content: 'Indique se sua viagem ocorrerá em "Alta Temporada" ou "Baixa Temporada". Viagens em alta temporada têm um acréscimo de 20% no custo total.',
            ),
            _HelpSection(
              title: '3. Companhia Aérea:',
              content: 'Selecione uma das três companhias aéreas parceiras. Cada uma oferece um preço de passagem diferente.',
            ),
            _HelpSection(
              title: '4. Escolha do Hotel:',
              content: 'Opte por um dos 5 tipos de hotéis disponíveis, que variam em preço e qualidade (Luxo, Conforto, Pousada Simples, Hostel Econômico). O custo do hotel é calculado por diária.',
            ),
            _HelpSection(
              title: '5. Dias de Estadia:',
              content: 'Informe o número de dias que você pretende ficar no destino. Este valor é usado para calcular o custo total do hotel.',
            ),
            _HelpSection(
              title: '6. Quantidade de Restaurantes:',
              content: 'Digite quantos restaurantes você planeja visitar durante a viagem. Cada restaurante adiciona um custo fixo de R\$ 120,00 ao orçamento.',
            ),
            _HelpSection(
              title: '7. Quantidade de Pessoas:',
              content: 'Por fim, informe o número de pessoas que viajarão. O custo total da viagem será multiplicado por este número para um orçamento por pessoa.',
            ),

            SizedBox(height: 30),
            Text(
              'Clique no botão "Calcular Viagem" para ver a estimativa do custo total!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 20),
            Text(
              'Dúvidas ou Sugestões? Entre em contato com a Equipe 2.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget auxiliar para estruturar as seções de ajuda
class _HelpSection extends StatelessWidget {
  final String title;
  final String content;

  const _HelpSection({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.deepPurple),
          ),
          const SizedBox(height: 5),
          Text(
            content,
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}