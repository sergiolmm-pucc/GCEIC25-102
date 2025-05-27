import 'dart:convert';
import 'package:http/http.dart' as http;
import 'financas_result.dart';

class ApiService {
  static const String baseUrlFinancas = 'https://sincere-magnificent-cobweb.glitch.me/gf';
  static const String baseUrlLogin = 'https://sincere-magnificent-cobweb.glitch.me/loginFixoEquipeTres';

  static Future<FinancasResult> calcularFinancas({
    required double salarioBruto,
    required List<Map<String, dynamic>> gastosFixos,
    required double percentualInvestimento,
    required double percentualLazer,
  }) async {
    final url = Uri.parse('$baseUrlFinancas/calcular-financas');

    final body = jsonEncode({
      'salarioBruto': salarioBruto,
      'gastosFixos': gastosFixos,
      'percentualInvestimento': percentualInvestimento,
      'percentualLazer': percentualLazer,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return FinancasResult.fromJson(jsonResponse);
    } else {
      throw Exception('Erro ao calcular finanças: ${response.body}');
    }
  }

  static Future<bool> loginFixoEquipeTres(String username, String password) async {
    final url = Uri.parse('$baseUrlLogin/loginFixoEquipeTres');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] ?? false;
    } else {
      return false;
    }
  }
}