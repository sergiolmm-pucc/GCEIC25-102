// PROJETO SERGIO NODE/web/gcseic25/lib/equipes/equipe2/about_screen_equipe2.dart
import 'package:flutter/material.dart';

class AboutScreenEquipe2 extends StatelessWidget {
  const AboutScreenEquipe2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre a Equipe 2')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 80,
                // Substitua pela URL da sua imagem (pode ser um link da web ou um asset local)
                backgroundImage: NetworkImage('https://via.placeholder.com/150/0000FF/FFFFFF?text=Equipe+2'), // Exemplo
                backgroundColor: Colors.blue, // Cor de fundo se a imagem não carregar
              ),
              const SizedBox(height: 25),
              const Text(
                'Equipe 2 - PROJETO SERGIO NODE',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              const SizedBox(height: 15),
              const Text(
                'Membros da Equipe:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 5),
              const Text('• Gabriel de Arruda Dupas - RA: 22023741'),
              const Text('• Felipe de Arruda Dupas - RA: 22022814'),
              const Text('• [Nome Completo do Aluno 3] - RA: [Seu RA]'),
              const Text('• [Nome Completo do Aluno 4] - RA: [Seu RA]'),
              // Adicione mais membros conforme necessário
              const SizedBox(height: 30),
              const Text(
                'Sobre o Projeto:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              const Text(
                'Este aplicativo foi desenvolvido como parte do projeto da disciplina PROJETO SERGIO NODE. Ele oferece uma calculadora de viagens completa, permitindo aos usuários estimar o custo de suas viagens com base em diversos fatores como país, temporada, companhia aérea, hotel e duração da estadia.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Versão: 1.0.0',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}