import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async'; // Para o Timer
import 'package:http/http.dart' as http;
import 'package:gcseic25/equipes/base/base.dart';
import 'package:gcseic25/equipes/equipe6/calculadora6.dart';
import 'package:gcseic25/equipes/equipe_1/splash.dart';
import 'package:gcseic25/equipes/equipe3/splash_screen_equipe_tres.dart';
import 'package:gcseic25/equipes/equipe8/splash_screen_piscina.dart';
import 'equipes/equipe7/calculator_screen.dart';
import 'package:gcseic25/equipes/equipe2/splash_screen_equipe2.dart';

// Import da Equipe 5
import 'equipes/equipe 5/splash_screen.dart'
    as SplashScreenEquipe5; // <--- Import da Equipe 5

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // required semantics binding
  SemanticsBinding.instance.ensureSemantics();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Navegação',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
      routes: {
        '/splash1':
            (context) =>
                SplashScreen1(nextPage: ConsultaPage1(title: 'Base 1')),
        '/splash2':
            (context) =>
                SplashScreen(nextPage: ConsultaPage(title: 'Consulta 2')),
        '/splashEquipe1': (context) => SplashEquipe(),
        '/calculadora': (context) => CalculatorScreen(),
        '/gf': (context) => SplashScreenEquipeTres(),
        '/piscina': (context) => SplashScreenPiscina(), // Da equipe 8
        '/calculadora6': (context) => Calculadora6Page(), // Da equipe6
        '/gf': (context) => SplashScreenEquipeTres(), // Da CI_CD6
        '/equipe2': (context) => const SplashScreenEquipe2(), 
        '/splash5':
            (context) => SplashScreenEquipe5.SplashScreen(
              nextScreen: 'login',
            ), // Rota da Equipe 5
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela Inicial 102'), // <--- AppBar CORRETA
      ),
      body: Center(
        child: SingleChildScrollView(
          // <--- SingleChildScrollView CORRETA
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                // Botão Base 1
                width: 220,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/splash1');
                  },
                  child: const Text('Abrir Base 1'),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                // Botão Consulta 2
                width: 220,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/splash2');
                  },
                  child: const Text('Abrir Consulta 2'),
                ),
              ),
              const SizedBox(height: 20),
              Semantics( // ******** BOTÃO EQUIPE 1 ********
                identifier: 'Abrir Equipe 1',
                label: 'Abrir Equipe 1',
                button: true,
                child: SizedBox(
                  // Botão Equipe 1
                  width: 220,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/splashEquipe1');
                    },
                    child: const Text('Abrir Equipe 1'),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                // Botão Calculadora equipe 7
                width: 220,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/calculadora');
                  },
                  child: const Text('Calculadora equipe 7'),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                // Botão Calculadora Equipe 6
                width: 220,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/calculadora6');
                  },
                  child: const Text('Calculadora Equipe 6'),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                // Botão Gestor de Finanças Equipe 3
                width: 220,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/gf');
                  },
                  child: const Text('Gestor de Finanças Equipe 3'),
                ),
              ),
              const SizedBox(height: 20),
              // ******** INÍCIO ADIÇÕES DA SUA EQUIPE (EQUIPE 2) ********
              SizedBox(
                // Botão Sistema de Viagens Equipe 2
                width: 220,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/equipe2');
                  },
                  child: const Text('Sistema de Viagens Equipe 2'),
                ),
              ),
              const SizedBox(height: 20),
              // ********************************************************
              // ******** INÍCIO ADIÇÕES DA EQUIPE 5 ********
              SizedBox(
                // Botão Cálculo de Viagens Equipe 5
                width: 220,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/splash5');
                  },
                  child: const Text('Cálculo de Viagens Equipe 5'),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 220,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/piscina');
                  },
                  child: Text('Cálculo Construção de Piscina - Equipe 8'),
                ),
              ),
              SizedBox(height: 20),
              Semantics(
                // Botão Entrar (final)
                identifier: 'Entrar',
                label: 'Entrar',
                button: true,
                child: SizedBox(
                  width: 220,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/splash1');
                    },
                    child: const Text('Entrar'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// O restante do seu código (SplashScreen, ConsultaPage etc.) permanece INALTERADO
// no seu main.dart, como já está.

class SplashScreen extends StatefulWidget {
  final Widget nextPage;

  const SplashScreen({super.key, required this.nextPage});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => widget.nextPage),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Carregando...', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class ConsultaPage extends StatefulWidget {
  final String title;

  const ConsultaPage({super.key, required this.title});

  @override
  _ConsultaPageState createState() => _ConsultaPageState();
}

class _ConsultaPageState extends State<ConsultaPage> {
  String _responseText = 'Resultado aparecerá aqui.';

  Future<void> _fetchData() async {
    final response = await http.get(
      Uri.parse('https://sincere-magnificent-cobweb.glitch.me/datetime'),
    );
    if (response.statusCode == 200) {
      setState(() {
        _responseText = response.body;
      });
    } else {
      setState(() {
        _responseText = 'Erro ao consultar API.';
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
            ElevatedButton(onPressed: _fetchData, child: Text('Consultar API')),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(_responseText, style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
