class NotaFiscal {
  constructor({ valor_produto, valor_ipi, valor_pis, valor_cofins, valor_icms }) {
    this.valor_produto = valor_produto;
    this.valor_ipi = valor_ipi;
    this.valor_pis = valor_pis;
    this.valor_cofins = valor_cofins;
    this.valor_icms = valor_icms;
  }

  getTotalTributos() {
    return (
      this.valor_ipi +
      this.valor_pis +
      this.valor_cofins +
      this.valor_icms
    );
  }

  getValorTotalNota() {
    return this.valor_produto + this.getTotalTributos();
  }

  toJSON() {
    return {
      valor_produto: this.valor_produto,
      valor_ipi: this.valor_ipi,
      valor_pis: this.valor_pis,
      valor_cofins: this.valor_cofins,
      valor_icms: this.valor_icms,
      total_tributos: this.getTotalTributos(),
      valor_total_nota: this.getValorTotalNota(),
    };
  }
}
