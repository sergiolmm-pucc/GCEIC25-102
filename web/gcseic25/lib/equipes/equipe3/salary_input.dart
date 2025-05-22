import 'package:flutter/material.dart';
import 'expenses_input.dart';

class SalaryInputScreen extends StatefulWidget {
  const SalaryInputScreen({super.key});

  @override
  _SalaryInputScreenState createState() => _SalaryInputScreenState();
}

class _SalaryInputScreenState extends State<SalaryInputScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _error;

  void _goToNext() {
    final input = _controller.text.replaceAll(',', '.');
    final value = double.tryParse(input);
    if (value == null || value <= 0) {
      setState(() => _error = "Digite um valor válido.");
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExpensesInputScreen(salarioBruto: value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Qual seu salário bruto mensal?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Digite aqui...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.transparent,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.cyanAccent),
                  ),
                  errorText: _error,
                ),
                onTap: () => setState(() => _error = null),
              ),
              SizedBox(height: 28),
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
            ],
          ),
        ),
      ),
    );
  }
}
