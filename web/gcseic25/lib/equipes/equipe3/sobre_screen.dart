import 'package:flutter/material.dart';

class SobreScreen extends StatelessWidget {
  const SobreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre a Equipe'),
        backgroundColor: Colors.cyanAccent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center( // Centraliza todo o conteúdo
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Equipe Gestor de Finanças',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: const [
                  _Member(
                    name: 'Matheus Zanon',
                    imagePath: 'assets/MatheusZanonCarita.png',
                  ),
                  _Member(
                    name: 'Felipe Yabiko',
                    imagePath: 'assets/FelipeYabiko.png',
                  ),
                  _Member(
                    name: 'Bernardo Amaro',
                    imagePath: 'assets/BernardoAmaro.png',
                  ),
                  _Member(
                    name: 'João Rocha',
                    imagePath: 'assets/JoaoRocha.png',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Member extends StatelessWidget {
  final String name;
  final String imagePath;

  const _Member({
    required this.name,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage(imagePath),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
