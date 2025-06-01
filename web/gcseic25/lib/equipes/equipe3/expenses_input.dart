import 'package:flutter/material.dart';
import 'percentages_input.dart';

class ExpensesInputScreen extends StatefulWidget {
  final double salarioBruto;
  const ExpensesInputScreen({super.key, required this.salarioBruto});

  @override
  ExpensesInputScreenState createState() => ExpensesInputScreenState();
}

class ExpensesInputScreenState extends State<ExpensesInputScreen> {
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
        builder:
            (_) => PercentagesInputScreen(
              salarioBruto: widget.salarioBruto,
              gastosFixos: gastos,
            ),
      ),
    );
  }

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.redAccent),
          tooltip: 'Sair',
          onPressed: _logout,
        ),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(24),
            constraints: BoxConstraints(
              maxWidth: 500, // Ajuste a largura máxima se quiser
            ),
            decoration: BoxDecoration(
              color: Color(0xD9000000),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Quais são seus gastos fixos?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
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
                // Delimita a altura máxima da lista pra não estourar o card!
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 200),
                  child:
                      gastos.isEmpty
                          ? Text(
                            'Nenhum gasto adicionado.',
                            style: TextStyle(color: Colors.grey[400]),
                          )
                          : ListView.builder(
                            shrinkWrap: true,
                            itemCount: gastos.length,
                            itemBuilder: (ctx, idx) {
                              final gasto = gastos[idx];
                              return ListTile(
                                title: Text(
                                  gasto['nome'],
                                  style: TextStyle(color: Colors.white),
                                ),
                                trailing: Text(
                                  'R\$ ${gasto['valor'].toStringAsFixed(2)}',
                                  style: TextStyle(color: Colors.cyanAccent),
                                ),
                              );
                            },
                          ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _goToNext,
                    child: Text(
                      'Próximo',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
