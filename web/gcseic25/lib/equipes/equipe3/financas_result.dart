class FinancasResult {
  final double inss;
  final double irpf;
  final double gastosTotais;
  final double salarioLiquido;
  final double valorInvestimento;
  final double valorLazer;
  final double saldoFinal;

  FinancasResult({
    required this.inss,
    required this.irpf,
    required this.gastosTotais,
    required this.salarioLiquido,
    required this.valorInvestimento,
    required this.valorLazer,
    required this.saldoFinal,
  });

  factory FinancasResult.fromJson(Map<String, dynamic> json) {
    return FinancasResult(
      inss: (json['inss'] as num).toDouble(),
      irpf: (json['irpf'] as num).toDouble(),
      gastosTotais: (json['gastosTotais'] as num).toDouble(),
      salarioLiquido: (json['salarioLiquido'] as num).toDouble(),
      valorInvestimento: (json['valorInvestimento'] as num).toDouble(),
      valorLazer: (json['valorLazer'] as num).toDouble(),
      saldoFinal: (json['saldoFinal'] as num).toDouble(),
    );
  }
}
