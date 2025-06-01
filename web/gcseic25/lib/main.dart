import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async'; // Para o Timer
import 'package:http/http.dart' as http;
import 'package:gcseic25/equipes/base/base.dart';

import 'equipes/equipe7/calculator_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // required semantics binding
  SemanticsBinding.instance.ensureSemantics();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        '/splash-calculadora': (context) => CalculatorSplashScreen(),
        '/login-calculadora': (context) => CalculatorLoginScreen(),
        '/calculadora': (context) => CalculatorScreen(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela Inicial 102'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/splash1');
              },
              child: Text('Abrir Base 1'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/splash2');
              },
              child: Text('Abrir Consulta 2'),
            ),
            SizedBox(height: 20),
            Semantics(
              label: 'Botão Calculadora equipe 7',
              button: true,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/splash-calculadora');
                },
                child: Text('Calculadora equipe 7'),
              ),
            ),
            SizedBox(height: 20),
            Semantics(
              identifier: 'Entrar',
              label: 'Entrar',
              button: true,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/splash1');
                },
                child: const Text('Entrar'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final Widget nextPage;

  const SplashScreen({required this.nextPage});

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

  const ConsultaPage({required this.title});

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

// Splash Screen específico para a calculadora
class CalculatorSplashScreen extends StatefulWidget {
  @override
  _CalculatorSplashScreenState createState() => _CalculatorSplashScreenState();
}

class _CalculatorSplashScreenState extends State<CalculatorSplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login-calculadora');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Semantics(
              label: 'Carregando Calculadora de Casa Container',
              readOnly: true,
              child: Text(
                'Carregando Calculadora de Casa Container',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Tela de Login para a calculadora
class CalculatorLoginScreen extends StatefulWidget {
  @override
  _CalculatorLoginScreenState createState() => _CalculatorLoginScreenState();
}

class _CalculatorLoginScreenState extends State<CalculatorLoginScreen> {
  final TextEditingController _usernameController = TextEditingController(text: 'admin');
  final TextEditingController _passwordController = TextEditingController(text: '123456');

  void _login() {
    Navigator.pushReplacementNamed(context, '/calculadora');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login - Calculadora'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Acesso à Calculadora de Casa Container',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              Semantics(
                label: 'Campo de usuário',
                textField: true,
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Usuário',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Semantics(
                label: 'Campo de senha',
                textField: true,
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 30),
              Semantics(
                label: 'Botão Login',
                button: true,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text('Login', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
