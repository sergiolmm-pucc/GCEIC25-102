class ICMS {
	constructor({ valor_produto, aliquota_icms }) {
		this.valor_produto = valor_produto;
		this.aliquota_icms = aliquota_icms;
	}

	getValorICMS() {
		return this.valor_produto * (this.aliquota_icms / 100);
	}

	toJSON() {
		return {
			valor_produto: this.valor_produto,
			aliquota_icms: this.aliquota_icms,
			valor_icms: this.getValorICMS(),
		};
	}
}
