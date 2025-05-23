class Ipi {
	constructor({ valor_produto, aliquota_ipi, quantidade }) {
		this.valor_produto = valor_produto;
		this.aliquota_ipi = aliquota_ipi;
		this.quantidade = quantidade;
	}

	getValorIpiTotal() {
		const valor_total_produtos = this.valor_produto * this.quantidade;
		return (valor_total_produtos * this.aliquota_ipi) / 100;
	}

	toJSON() {
		return {
			valor_produto: this.valor_produto,
			aliquota_ipi: this.aliquota_ipi,
			quantidade: this.quantidade,
			valor_ipi_total: this.getValorIpiTotal(),
		};
	}
}

module.exports = Ipi;