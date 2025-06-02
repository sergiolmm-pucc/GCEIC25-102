import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sobre o Time',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/equipe5.png', height: 300),
            const SizedBox(height: 32),
            const ListTile(
              leading: Icon(Icons.person),
              title: Text('Bernardo Wiemer'),
              subtitle: Text('RA: 22023125'),
            ),
            const ListTile(
              leading: Icon(Icons.person),
              title: Text('Lucas Giazzi'),
              subtitle: Text('RA: 22019941'),
            ),
            const ListTile(
              leading: Icon(Icons.person),
              title: Text('Yuri Viegas'),
              subtitle: Text('RA: 22021857'),
            ),
          ],
        ),
      ),
    );
  }
}
