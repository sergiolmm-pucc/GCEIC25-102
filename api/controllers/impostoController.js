// Controller para lidar com as requisições relacionadas a impostos

const NotaFiscal = require("../models/NotaFiscal"); // Supondo que você tenha um modelo NotaFiscal
const ICMS = require("../models/ICMS"); // Supondo que você tenha um modelo ICMS
const Ipi = require("../models/Ipi");

exports.getNotaFiscal = (req, res) => {
	const { valor_produto, valor_ipi, valor_pis, valor_cofins, valor_icms } =
		req.query;

	const notaFiscal = new NotaFiscal({
		valor_produto: parseFloat(valor_produto) || 0,
		valor_ipi: parseFloat(valor_ipi) || 0,
		valor_pis: parseFloat(valor_pis) || 0,
		valor_cofins: parseFloat(valor_cofins) || 0,
		valor_icms: parseFloat(valor_icms) || 0,
	});

	// Valida os parâmetros
	if (
		!valor_produto ||
		!valor_ipi ||
		!valor_pis ||
		!valor_cofins ||
		!valor_icms
	) {
		return res
			.status(400)
			.json({ error: "Parâmetros obrigatórios não informados" });
	}
	if (
		isNaN(notaFiscal.valor_produto) ||
		isNaN(notaFiscal.valor_ipi) ||
		isNaN(notaFiscal.valor_pis) ||
		isNaN(notaFiscal.valor_cofins) ||
		isNaN(notaFiscal.valor_icms)
	) {
		return res.status(400).json({ error: "Parâmetros inválidos" });
	}

	res.json(notaFiscal.toJSON());
};

exports.getICMS = (req, res) => {
	const { valor_produto, aliquota_icms } = req.query;

	const icms = new ICMS({
		valor_produto: parseFloat(valor_produto) || 0,
		aliquota_icms: parseFloat(aliquota_icms) || 0,
	});

	// Valida os parâmetros
	if (!valor_produto || !aliquota_icms) {
		return res
			.status(400)
			.json({ error: "Parâmetros obrigatórios não informados" });
	}
	if (isNaN(icms.valor_produto) || isNaN(icms.aliquota_icms)) {
		return res.status(400).json({ error: "Parâmetros inválidos" });
	}

  res.json(icms.toJSON());
};

exports.getValorIpiTotal = (req, res) => {
	const { valor_produto, aliquota_ipi, quantidade } = req.query;

	const ipi = new Ipi({
		valor_produto: parseFloat(valor_produto) || 0,
		aliquota_ipi: parseFloat(aliquota_ipi) || 0,
		quantidade: parseInt(quantidade) || 0,
	});

	if (!valor_produto || !aliquota_ipi || !quantidade) {
		return res
		.status(400)
		.json({ error: "Parâmetros obrigatórios não informados" });
	}

	if (isNaN(ipi.valor_produto) || isNaN(ipi.aliquota_ipi) || isNaN(ipi.quantidade)) {
        return res
		.status(400)
		.json({ error: "Parâmetros inválidos"});
    }

	res.json(ipi.toJSON());
}