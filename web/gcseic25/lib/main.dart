import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(DateTimeApp());
}

class DateTimeApp extends StatelessWidget {
  const DateTimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API DateTime Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DateTimeHomePage(),
    );
  }
}

class DateTimeHomePage extends StatefulWidget {
  const DateTimeHomePage({super.key});

  @override
  _DateTimeHomePageState createState() => _DateTimeHomePageState();
}

class _DateTimeHomePageState extends State<DateTimeHomePage> {
  String _responseText = 'Clique no botão para obter a data e hora';

  Future<void> _fetchDateTime() async {
    final url = Uri.parse('https://sincere-magnificent-cobweb.glitch.me/datetime');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _responseText = data['datetime'] ?? 'Resposta inesperada';
        });
      } else {
        setState(() {
          _responseText = 'Erro ao obter dados: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _responseText = 'Erro: $e';
        print(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API DateTime Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _fetchDateTime,
              child: Text('Obter Data e Hora'),
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
