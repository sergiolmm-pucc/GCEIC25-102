class EstruturaImpostos {
  double _valor_produto;
  double _icms;
  double _pis;
  double _cofins;
  double _ipi;

  // Construtor padrão com valores obrigatórios
  EstruturaImpostos({
    required double valor_produto,
    required double icms,
    required double pis,
    required double cofins,
    required double ipi,
  }) : _icms = icms,
      _valor_produto= valor_produto,
       _pis = pis,
       _cofins = cofins,
       _ipi = ipi;

  // Construtor sem valores (todos zero)
  EstruturaImpostos.vazio()
    : _icms = 0.0,
      _valor_produto = 0.0,
      _pis = 0.0,
      _cofins = 0.0,
      _ipi = 0.0;

  // Getters
  double get icms => _icms;
  double get valor_produto => _valor_produto;
  double get pis => _pis;
  double get cofins => _cofins;
  double get ipi => _ipi;

  // Setters
  set icms(double value) => _icms = value;
  set valor_produto (double value) => _valor_produto = value;
  set pis(double value) => _pis = value;
  set cofins(double value) => _cofins = value;
  set ipi(double value) => _ipi = value;

  Map<String, dynamic> toMap() {
    return {'icms': _icms, 'pis': _pis, 'cofins': _cofins, 'ipi': _ipi, 'valor_produto': _valor_produto};
  }

  factory EstruturaImpostos.fromMap(Map<String, dynamic> map) {
    return EstruturaImpostos(
      valor_produto: map['valor_produto'] ?? 0.0,
      icms: map['icms'] ?? 0.0,
      pis: map['pis'] ?? 0.0,
      cofins: map['cofins'] ?? 0.0,
      ipi: map['ipi'] ?? 0.0,
    );
  }
}
