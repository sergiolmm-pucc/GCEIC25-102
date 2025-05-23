// web/gcseic25/lib/equipes/equipeX/expenses_input.dart

import 'package:flutter/material.dart';
import 'percentages_input.dart';

class ExpensesInputScreen extends StatefulWidget {
  final double salarioBruto;
  const ExpensesInputScreen({super.key, required this.salarioBruto});

  @override
  _ExpensesInputScreenState createState() => _ExpensesInputScreenState();
}

class _ExpensesInputScreenState extends State<ExpensesInputScreen> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController valorController = TextEditingController();
  List<Map<String, dynamic>> gastos = [];

  void _addExpense() {
    String nome = nomeController.text.trim();
    String valorStr = valorController.text.replaceAll(',', '.').trim();
    double? valor = double.tryParse(valorStr);
    if (nome.isEmpty || valor == null || valor <= 0) return;

    setState(() {
      gastos.add({'nome': nome, 'valor': valor});
      nomeController.clear();
      valorController.clear();
    });
  }

  void _goToNext() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PercentagesInputScreen(
          salarioBruto: widget.salarioBruto,
          gastosFixos: gastos,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            SizedBox(height: 60),
            Text(
              'Quais são seus gastos fixos?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nomeController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Nome do Gasto',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.cyanAccent),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: 90,
                  child: TextField(
                    controller: valorController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Valor',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.cyanAccent),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.cyanAccent),
                  onPressed: _addExpense,
                  splashRadius: 24,
                ),
              ],
            ),
            SizedBox(height: 18),
            Expanded(
              child: ListView.builder(
                itemCount: gastos.length,
                itemBuilder: (ctx, idx) {
                  final gasto = gastos[idx];
                  return ListTile(
                    title: Text(gasto['nome'], style: TextStyle(color: Colors.white)),
                    trailing: Text('R\$ ${gasto['valor'].toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.cyanAccent)),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _goToNext,
                child: Text('Próximo', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}