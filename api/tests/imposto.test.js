// imposto.test.js
// equipe 1 - kauan, paulo, gian e vinicius
const { getICMS } = require("../controllers/impostoController");
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
});

describe("GET /calculo-icms", () => {
	test("Deve retornar 200 e o valor do ICMS corretamente", async () => {
		const res = await request(app).get(
			"/calculo-icms?valor_produto=100&aliquota_icms=25"
		);
		expect(res.statusCode).toBe(200);
		expect(res.body).toEqual({
			valor_produto: 100,
			aliquota_icms: 25,
			valor_icms: 25,
		});
	});

	test("Deve retornar 400 se faltar parâmetros", async () => {
		const res = await request(app).get("/calculo-icms?valor_produto=100");
		expect(res.statusCode).toBe(400);
		expect(res.body.error).toBe("Parâmetros obrigatórios não informados");
	});

	test("Deve retornar 400 para parâmetros inválidos", async () => {
		const res = await request(app).get(
			"/calculo-icms?valor_produto=abc&aliquota_icms=10"
		);
		expect(res.statusCode).toBe(400);
		expect(res.body.error).toBe("Parâmetros inválidos");
	});
});
