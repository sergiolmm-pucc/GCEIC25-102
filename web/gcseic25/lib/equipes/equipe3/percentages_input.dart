import 'package:flutter/material.dart';
import 'api_service.dart';
import 'results_screen.dart';

class PercentagesInputScreen extends StatefulWidget {
  final double salarioBruto;
  final List<Map<String, dynamic>> gastosFixos;

  const PercentagesInputScreen({
    super.key,
    required this.salarioBruto,
    required this.gastosFixos,
  });

  @override
  PercentagesInputScreenState createState() => PercentagesInputScreenState();
}

class PercentagesInputScreenState extends State<PercentagesInputScreen> {
  final TextEditingController investimentoController = TextEditingController();
  final TextEditingController lazerController = TextEditingController();
  String? _errorInvestimento;
  String? _errorLazer;

  void _calcular() async {
    final investimentoStr = investimentoController.text.replaceAll(',', '.');
    final lazerStr = lazerController.text.replaceAll(',', '.');

    final investimento = double.tryParse(investimentoStr);
    final lazer = double.tryParse(lazerStr);

    setState(() {
      _errorInvestimento = null;
      _errorLazer = null;
    });

    bool valid = true;

    if (investimento == null || investimento < 0 || investimento > 100) {
      setState(() => _errorInvestimento = 'Digite um valor entre 0 e 100');
      valid = false;
    }

    if (lazer == null || lazer < 0 || lazer > 100) {
      setState(() => _errorLazer = 'Digite um valor entre 0 e 100');
      valid = false;
    }

    if (valid) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Center(child: CircularProgressIndicator()),
      );

      try {
        final resultado = await ApiService.calcularFinancas(
          salarioBruto: widget.salarioBruto,
          gastosFixos: widget.gastosFixos,
          percentualInvestimento: investimento!,
          percentualLazer: lazer!,
        );

        if (!mounted) return;
        Navigator.pop(context); // Fecha o loading
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultsScreen(resultado: resultado),
          ),
        );
      } catch (e) {
        if (!mounted) return;
        Navigator.pop(context); // Fecha o loading
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao calcular: $e')));
      }
    }
  }

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Percentuais'),
        backgroundColor: Colors.cyanAccent,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.redAccent),
            tooltip: 'Sair',
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            constraints: BoxConstraints(maxWidth: 500),
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
                  'Digite o percentual para investimento e o percentual para lazer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                TextField(
                  key: ValueKey('percentualInvestimentoEquipeTres'),
                  controller: investimentoController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Percentual para Investimento (%)',
                    labelStyle: TextStyle(color: Colors.white70),
                    errorText: _errorInvestimento,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyanAccent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.cyanAccent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  key: ValueKey('percentualLazerEquipeTres'),
                  controller: lazerController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Percentual para Lazer (%)',
                    labelStyle: TextStyle(color: Colors.white70),
                    errorText: _errorLazer,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyanAccent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.cyanAccent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 36),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    key: ValueKey('botaoCalcularEquipeTres'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _calcular,
                    child: Text(
                      'Calcular',
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
