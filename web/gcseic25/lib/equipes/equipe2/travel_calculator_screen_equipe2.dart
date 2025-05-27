// PROJETO SERGIO NODE/web/gcseic25/lib/equipes/equipe2/travel_calculator_screen_equipe2.dart
import 'package:flutter/material.dart';
import 'package:gcseic25/equipes/equipe2/api_service.dart'; // Importa o serviço de API
import 'package:gcseic25/equipes/equipe2/about_screen_equipe2.dart'; // Importa a tela Sobre
import 'package:gcseic25/equipes/equipe2/help_screen_equipe2.dart';   // Importa a tela Ajuda

class TravelCalculatorScreenEquipe2 extends StatefulWidget {
  const TravelCalculatorScreenEquipe2({Key? key}) : super(key: key);

  @override
  State<TravelCalculatorScreenEquipe2> createState() => _TravelCalculatorScreenEquipe2State();
}

class _TravelCalculatorScreenEquipe2State extends State<TravelCalculatorScreenEquipe2> {
  final ApiService _apiService = ApiService(); // Instancia o serviço de API

  String? _selectedPais;
  String? _selectedTemporada;
  String? _selectedCompanhiaAerea;
  String? _selectedHotel;
  final TextEditingController _diasEstadiaController = TextEditingController();
  final TextEditingController _quantidadeRestaurantesController = TextEditingController();
  final TextEditingController _quantidadePessoasController = TextEditingController();

  String _resultadoCalculo = "Preencha os campos para calcular sua viagem!";
  bool _isLoading = false;

  final List<String> _paises = [
    "Brasil", "Argentina", "Chile", "Portugal", "Espanha", "Franca", "Italia", "Alemanha", "EUA", "Canada"
  ];
  final List<String> _temporadas = ["Baixa", "Alta"];
  final List<String> _companhiasAereas = ["Latam", "Azul", "Gol"];
  final List<String> _hoteis = [
    "Hotel Luxo", "Hotel Conforto", "Pousada Simples", "Hostel Economico"
  ];

  @override
  void dispose() {
    _diasEstadiaController.dispose();
    _quantidadeRestaurantesController.dispose();
    _quantidadePessoasController.dispose();
    super.dispose();
  }

  Future<void> _calcularViagem() async {
    // Validação de inputs
    if (_selectedPais == null ||
        _selectedTemporada == null ||
        _selectedCompanhiaAerea == null ||
        _selectedHotel == null ||
        _diasEstadiaController.text.isEmpty ||
        _quantidadeRestaurantesController.text.isEmpty ||
        _quantidadePessoasController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _resultadoCalculo = "Calculando...";
    });

    try {
      final int diasEstadia = int.parse(_diasEstadiaController.text);
      final int quantidadeRestaurantes = int.parse(_quantidadeRestaurantesController.text);
      final int quantidadePessoas = int.parse(_quantidadePessoasController.text);

      if (diasEstadia <= 0 || quantidadeRestaurantes < 0 || quantidadePessoas <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Por favor, insira valores válidos (dias e pessoas > 0, restaurantes >= 0).')),
          );
          setState(() {
              _isLoading = false;
              _resultadoCalculo = "Erro de validação.";
          });
          return;
      }


      final Map<String, dynamic> dadosViagem = {
        "pais": _selectedPais,
        "temporada": _selectedTemporada,
        "companhiaAerea": _selectedCompanhiaAerea,
        "hotel": _selectedHotel,
        "diasEstadia": diasEstadia,
        "quantidadeRestaurantes": quantidadeRestaurantes,
        "quantidadePessoas": quantidadePessoas,
      };

      // Chama a API Node.js
      final response = await _apiService.post('viagens2/calcular', dadosViagem);

      if (response['success']) {
        setState(() {
          _resultadoCalculo = "Custo Total da Viagem: R\$ ${response['custoTotal']}";
        });
      } else {
        setState(() {
          _resultadoCalculo = "Erro ao calcular: ${response['mensagem']}";
        });
      }
    } catch (e) {
      setState(() {
        _resultadoCalculo = "Ocorreu um erro inesperado: ${e.toString()}";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
    title: const Text('Calculadora de Viagens Equipe 2'),
    actions: <Widget>[
      IconButton(
        icon: const Icon(Icons.info_outline),
        tooltip: 'Sobre',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AboutScreenEquipe2()),
          );
        },
      ),
      const SizedBox(width: 18.0), // Adicione espaço aqui (ajuste o valor conforme necessário)
      IconButton(
        icon: const Icon(Icons.help_outline),
        tooltip: 'Ajuda',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HelpScreenEquipe2()),
          );
        },
      ),
      const SizedBox(width: 10.0), // Opcional: Adiciona um pequeno espaço na extremidade direita
    ],
  ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedPais,
                    hint: const Text('Selecione o País'),
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: _paises.map((String pais) {
                      return DropdownMenuItem<String>(
                        value: pais,
                        child: Text(pais),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedPais = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedTemporada,
                    hint: const Text('Temporada (Alta/Baixa)'),
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: _temporadas.map((String temporada) {
                      return DropdownMenuItem<String>(
                        value: temporada,
                        child: Text(temporada),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedTemporada = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedCompanhiaAerea,
                    hint: const Text('Companhia Aérea'),
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: _companhiasAereas.map((String companhia) {
                      return DropdownMenuItem<String>(
                        value: companhia,
                        child: Text(companhia),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCompanhiaAerea = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedHotel,
                    hint: const Text('Hotel'),
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: _hoteis.map((String hotel) {
                      return DropdownMenuItem<String>(
                        value: hotel,
                        child: Text(hotel),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedHotel = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _diasEstadiaController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Dias de Estadia',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _quantidadeRestaurantesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantidade de Restaurantes',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _quantidadePessoasController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantidade de Pessoas',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _calcularViagem,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Calcular Viagem', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _resultadoCalculo,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
    );
  }
}