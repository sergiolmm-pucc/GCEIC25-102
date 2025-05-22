import 'dart:convert';
import 'package:http/http.dart' as http;
import 'financas_result.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/gf';

  static Future<FinancasResult> calcularFinancas({
    required double salarioBruto,
    required List<Map<String, dynamic>> gastosFixos,
    required double percentualInvestimento,
    required double percentualLazer,
  }) async {
    final url = Uri.parse('$baseUrl/calcular-financas');

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
}
