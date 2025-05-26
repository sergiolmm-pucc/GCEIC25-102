import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  final String nextScreen; // Define qual tela será exibida após a SplashScreen

  const SplashScreen({super.key, required this.nextScreen});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (widget.nextScreen == 'login') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else if (widget.nextScreen == 'home') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Centraliza verticalmente
          children: [
            const Text(
              'Carregando...',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16), // Espaço entre o texto e o indicador
            CircularProgressIndicator(color: Colors.blue), // Bolinha girando
          ],
        ),
      ),
    );
  }
}
