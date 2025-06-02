// PROJETO SERGIO NODE/web/gcseic25/lib/equipes/equipe2/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http; // Certifique-se que o 'http' está no pubspec.yaml

class ApiService {
  // Ajuste para o seu site API. Para desenvolvimento local, use localhost.
  // Quando for para produção, mude para o URL do seu site API (ex: https://seusistemaviagens-api.com)
  final String _baseUrl = 'https://sincere-magnificent-cobweb.glitch.me/';

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        // Se a API retornar um erro (status 4xx ou 5xx), tentamos ler a mensagem dela
        final errorBody = json.decode(response.body);
        return {
          'success': false,
          'mensagem': errorBody['mensagem'] ?? 'Erro na requisição: ${response.statusCode} ${response.reasonPhrase}'
        };
      }
    } catch (e) {
      // Erro de rede, servidor indisponível, etc.
      return {
        'success': false,
        'mensagem': 'Erro de conexão ou servidor: ${e.toString()}'
      };
    }
  }
}
