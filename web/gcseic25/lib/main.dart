import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async'; // Para o Timer
import 'package:http/http.dart' as http;
import 'package:gcseic25/equipes/base/base.dart';
import 'package:gcseic25/equipes/equipe_1/splash.dart';
import 'package:gcseic25/equipes/equipe3/splash_screen_equipe_tres.dart';
import 'equipes/equipe7/calculator_screen.dart';
import 'package:gcseic25/equipes/equipe2/splash_screen_equipe2.dart';


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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        '/splash1': (context) => SplashScreen1(nextPage: ConsultaPage1(title: 'Base 1')),
        '/splash2': (context) => SplashScreen(nextPage: ConsultaPage(title: 'Consulta 2')),
        '/splashEquipe1': (context) => SplashEquipe(),
        '/calculadora': (context) => CalculatorScreen(),
        '/gf': (context) => SplashScreenEquipeTres(),
        '/equipe2': (context) => const SplashScreenEquipe2(), 
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
        title: Text('Tela Inicial 102'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 220,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/splash1');
                  },
                  child: Text('Abrir Base 1'),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 220,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/splash2');
                  },
                  child: Text('Abrir Consulta 2'),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 220,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/splashEquipe1');
                  },
                  child: Text('Abrir Equipe 1'),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 220,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/calculadora');
                  },
                  child: Text('Calculadora equipe 7'),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 220,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/gf');
                  },
                  child: Text('Gestor de Finanças Equipe 3'),
                ),
              ),
              SizedBox(height: 20),
              
              SizedBox( 
                width: 220,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/equipe2'); 
                  },
                  child: const Text('Sistema de Viagens Equipe 2'),
                ),
              ),
              SizedBox(height: 20), 

              Semantics(
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
        child: Text(
          'Carregando...',
          style: TextStyle(fontSize: 24),
        ),
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
    //
    final response = await http.get(Uri.parse('https://sincere-magnificent-cobweb.glitch.me/datetime'));
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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _fetchData,
              child: Text('Consultar API'),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                _responseText,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}