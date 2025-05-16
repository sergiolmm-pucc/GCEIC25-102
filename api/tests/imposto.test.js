// imposto.test.js
// equipe 1 - kauan, paulo, gian e vinicius
const { getICMS } = require("../controllers/impostoController");
const ICMS = require("../models/ICMS");
const Ipi = require("../models/Ipi");

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

describe("Classe IPI", () => {
  test("Deve calcular corretamente o valor do IPI", () => {
    const ipi = new Ipi({ valor_produto: 100, aliquota_ipi: 15, quantidade: 1 });
    expect(ipi.getValorIpiTotal()).toBe(15);
  });

  test("toJSON deve retornar o objeto esperado", () => {
    const ipi = new Ipi({ valor_produto: 50, aliquota_ipi: 10, quantidade: 1 });
    expect(ipi.toJSON()).toEqual({
      valor_produto: 50,
      aliquota_ipi: 10,
      quantidade: 1,
      valor_ipi_total: 5
    });
  });

  test("Deve calcular IPI corretamente com quantidade maior que 1", () => {
    const ipi = new Ipi({ valor_produto: 100, aliquota_ipi: 10, quantidade: 2 });
    expect(ipi.getValorIpiTotal()).toBe(20);
  });

  test("Deve retornar erro se valor_produto ou aliquota_ipi não forem informados", () => {
    const ipi = new Ipi({ valor_produto: null, aliquota_ipi: 10, quantidade: 1 });
    expect(ipi.valor_produto).toBe(null);
    expect(ipi.aliquota_ipi).toBe(10);
  });

  test("Deve retornar erro se valor_produto ou aliquota_ipi não forem números", () => {
    const ipi = new Ipi({ valor_produto: "xyz", aliquota_ipi: 10, quantidade: 1 });
    expect(ipi.valor_produto).toBe("xyz");
    expect(ipi.aliquota_ipi).toBe(10);
  });

  test("Deve retornar erro se valor_produto ou aliquota_ipi forem negativos", () => {
    const ipi = new Ipi({ valor_produto: -100, aliquota_ipi: 10, quantidade: 1 });
    expect(ipi.valor_produto).toBe(-100);
    expect(ipi.aliquota_ipi).toBe(10);
  });

  test("Deve retornar erro se valor_produto ou aliquota_ipi forem zero", () => {
    const ipi = new Ipi({ valor_produto: 0, aliquota_ipi: 10, quantidade: 1 });
    expect(ipi.valor_produto).toBe(0);
    expect(ipi.aliquota_ipi).toBe(10);
  });
});