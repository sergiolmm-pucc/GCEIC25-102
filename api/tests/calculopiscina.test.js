// piscina.test.js
const { calcularPiscina } = require("../controllers/calculoPiscinaController");

describe("Teste da função calcularPiscina", () => {
  let req, res;

  beforeEach(() => {
    res = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn(),
    };
  });

  test("Deve calcular corretamente o custo total da piscina", () => {
    req = {
      body: {
        largura: 10,
        comprimento: 5,
        profundidade: 2,
        custoAguaPorLitro: 0.005,
        custoEletrica: 1500,
        custoHidraulica: 1200,
        manutencaoMensal: 200,
      },
    };

    calcularPiscina(req, res);

    expect(res.json).toHaveBeenCalledWith({
      success: true,
      volume_m3: "100.00",
      litros: "100000",
      custoAgua: "500.00",
      custoEletrica: "1500.00",
      custoHidraulica: "1200.00",
      manutencaoMensal: "200.00",
      custoTotal: "3400.00",
    });
  });

  test("Deve usar valores padrão se custos não forem passados", () => {
    req = {
      body: {
        largura: 2,
        comprimento: 3,
        profundidade: 1.5,
      },
    };

    calcularPiscina(req, res);

    expect(res.json).toHaveBeenCalledWith({
      success: true,
      volume_m3: "9.00",
      litros: "9000",
      custoAgua: "45.00",
      custoEletrica: "1500.00",
      custoHidraulica: "1200.00",
      manutencaoMensal: "200.00",
      custoTotal: "2945.00",
    });
  });

  test("Deve retornar erro se largura, comprimento ou profundidade não forem informados", () => {
    req = {
      body: {
        largura: 10,
        comprimento: null,
        profundidade: 2,
      },
    };

    calcularPiscina(req, res);

    expect(res.status).toHaveBeenCalledWith(400);
    expect(res.json).toHaveBeenCalledWith({
      success: false,
      message: "Parâmetros largura, comprimento e profundidade são obrigatórios",
    });
  });

  test("Deve calcular corretamente com valores decimais", () => {
    req = {
      body: {
        largura: 3.5,
        comprimento: 4.2,
        profundidade: 1.8,
        custoAguaPorLitro: 0.006,
        custoEletrica: 1600,
        custoHidraulica: 1300,
        manutencaoMensal: 250,
      },
    };

    calcularPiscina(req, res);

    expect(res.json).toHaveBeenCalledWith({
      success: true,
      volume_m3: "26.46",
      litros: "26460",
      custoAgua: "158.76",
      custoEletrica: "1600.00",
      custoHidraulica: "1300.00",
      manutencaoMensal: "250.00",
      custoTotal: "3308.76",
    });
  });
});
