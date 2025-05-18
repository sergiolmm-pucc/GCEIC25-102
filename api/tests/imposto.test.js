// imposto.test.js
// equipe 1 - kauan, paulo, gian e vinicius
const { getICMS, calcularPisCofins } = require("../controllers/impostoController");
const ICMS = require("../models/ICMS");

describe("Classe ICMS", () => {
	test("Deve calcular corretamente o valor do ICMS", () => {
		const icms = new ICMS({ valor_produto: 100, aliquota_icms: 20 });
		expect(icms.getValorICMS()).toBe(20);
	});

	test("toJSON deve retornar o objeto esperado", () => {
		const icms = new ICMS({ valor_produto: 50, aliquota_icms: 10 });
		expect(icms.toJSON()).toEqual({
			valor_produto: 50,
			aliquota_icms: 10,
			valor_icms: 5,
		});
	});

	test("Deve retornar erro se valor_produto ou aliquota_icms não forem informados", () => {
		const icms = new ICMS({ valor_produto: null, aliquota_icms: 10 });
		expect(icms.valor_produto).toBe(null);
		expect(icms.aliquota_icms).toBe(10);
	});

	test("Deve retornar erro se valor_produto ou aliquota_icms não forem números", () => {
		const icms = new ICMS({ valor_produto: "abc", aliquota_icms: 10 });
		expect(icms.valor_produto).toBe("abc");
		expect(icms.aliquota_icms).toBe(10);
	});

	test("Deve retornar erro se valor_produto ou aliquota_icms forem negativos", () => {
		const icms = new ICMS({ valor_produto: -100, aliquota_icms: 10 });
		expect(icms.valor_produto).toBe(-100);
		expect(icms.aliquota_icms).toBe(10);
	});

	test("Deve retornar erro se valor_produto ou aliquota_icms forem zero", () => {
		const icms = new ICMS({ valor_produto: 0, aliquota_icms: 10 });
		expect(icms.valor_produto).toBe(0);
		expect(icms.aliquota_icms).toBe(10);
	});
});

describe("Função getICMS", () => {
	let req;
	let res;
  
	beforeEach(() => {
	  // Mock do objeto de resposta
	  res = {
		status: jest.fn().mockReturnThis(),
		json: jest.fn()
	  };
	});
  
	test("Deve calcular corretamente o ICMS com parâmetros válidos", () => {
	  // Arrange
	  req = {
		query: {
		  valor_produto: '100',
		  aliquota_icms: '18'
		}
	  };
	  
	  // Act
	  getICMS(req, res);
	  
	  // Assert
	  expect(res.json).toHaveBeenCalledWith({
		valor_produto: 100,
		aliquota_icms: 18,
		valor_icms: 18 // 100 * 0.18
	  });
	});
  
	test("Deve retornar erro quando parâmetros obrigatórios não são informados", () => {
	  // Arrange
	  req = {
		query: {
		  // Faltando valor_produto
		  aliquota_icms: '18'
		}
	  };
	  
	  // Act
	  getICMS(req, res);
	  
	  // Assert
	  expect(res.status).toHaveBeenCalledWith(400);
	  expect(res.json).toHaveBeenCalledWith({
		error: "Parâmetros obrigatórios não informados"
	  });
	});
  
	test("Deve retornar erro quando parâmetros inválidos são fornecidos", () => {
	  // Arrange
	  req = {
		query: {
		  valor_produto: 'abc',
		  aliquota_icms: '18'
		}
	  };
	  
	  // Act
	  getICMS(req, res);
	  
	  // Assert
	  expect(res.status).toHaveBeenCalledWith(400);
	  expect(res.json).toHaveBeenCalledWith({
		error: "Parâmetros inválidos"
	  });
	});
});

describe("Função calcularPisCofins", () => {
	let req;
	let res;
  
	beforeEach(() => {
	  // Mock do objeto de resposta
	  res = {
		status: jest.fn().mockReturnThis(),
		json: jest.fn()
	  };
	});
  
	test("Deve calcular corretamente PIS/COFINS no regime cumulativo", () => {
	  // Arrange
	  req = {
		body: {
		  regime: 'cumulativo',
		  receitaBruta: 10000,
		  aliquota: 100 // 100% da alíquota padrão
		}
	  };
	  
	  // Act
	  calcularPisCofins(req, res);
	  
	  // Assert
	  expect(res.json).toHaveBeenCalledWith({
		success: true,
		resultado: {
		  regime: 'cumulativo',
		  receitaBruta: 10000,
		  valorPis: 65, // (10000 * 0.65) / 100
		  valorCofins: 300, // (10000 * 3.0) / 100
		  total: 365 // 65 + 300
		}
	  });
	});
  
	test("Deve calcular corretamente PIS/COFINS no regime não-cumulativo", () => {
	  req = {
		body: {
		  regime: 'nao-cumulativo',
		  receitaBruta: 10000,
		  aliquota: 100
		}
	  };
	  
	  calcularPisCofins(req, res);
	  
	  expect(res.json).toHaveBeenCalledWith({
		success: true,
		resultado: {
		  regime: 'nao-cumulativo',
		  receitaBruta: 10000,
		  valorPis: 165, // (10000 * 1.65) / 100
		  valorCofins: 760, // (10000 * 7.6) / 100
		  total: 925 // 165 + 760
		}
	  });
	});
  
	test("Deve aplicar o fator de alíquota corretamente", () => {
	  req = {
		body: {
		  regime: 'cumulativo',
		  receitaBruta: 10000,
		  aliquota: 50 // 50% da alíquota padrão
		}
	  };
	  
	  calcularPisCofins(req, res);
	  
	  expect(res.json).toHaveBeenCalledWith({
		success: true,
		resultado: {
		  regime: 'cumulativo',
		  receitaBruta: 10000,
		  valorPis: 32.5, // ((10000 * 0.65) / 100) * 0.5
		  valorCofins: 150, // ((10000 * 3.0) / 100) * 0.5
		  total: 182.5
		}
	  });
	});
  
	test("Deve retornar erro quando parâmetros obrigatórios não são informados", () => {
	  req = {
		body: {
		  // Faltando regime
		  receitaBruta: 10000,
		  aliquota: 100
		}
	  };
	  
	  calcularPisCofins(req, res);
	  
	  expect(res.status).toHaveBeenCalledWith(400);
	  expect(res.json).toHaveBeenCalledWith({
		success: false,
		message: 'Todos os campos são obrigatórios: regime, receitaBruta e aliquota'
	  });
	});
});