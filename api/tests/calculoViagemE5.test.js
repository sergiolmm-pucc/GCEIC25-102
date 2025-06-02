const controller = require('../controllers/calculoViagemEquipe5Controller');

describe('Rota /calcular (com totalLitrosGasolina)', () => {
  const buildRes = () => ({
    status: jest.fn().mockReturnThis(),
    json: jest.fn()
  });

  test('Deve calcular os valores corretamente com todos os campos', () => {
    const req = {
      body: {
        totalLitrosGasolina: 40,
        precoGasolina: 5,
        precoManutencao: 20,
        pedagios: 30,
        outros: 10,
        numPessoas: 2
      }
    };

    const res = buildRes();
    controller.calcular(req, res);

    expect(res.status).toHaveBeenCalledWith(200);
    expect(res.json).toHaveBeenCalledWith({
      success: true,
      payload: {
        totalGasolina: 200,       // 40 * 5
        totalLitrosGasolina: 40,
        precoTotal: 260,          // 200 + 20 + 30 + 10
        precoPorPessoa: 130       // 260 / 2
      }
    });
  });

  test('Deve retornar erro se totalLitrosGasolina estiver ausente', () => {
    const req = {
      body: {
        precoGasolina: 5,
        precoManutencao: 10,
        pedagios: 5,
        outros: 0,
        numPessoas: 2
      }
    };

    const res = buildRes();
    controller.calcular(req, res);

    expect(res.status).toHaveBeenCalledWith(400);
    expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
      success: false,
      message: expect.stringMatching(/totalLitrosGasolina/i)
    }));
  });

  test('Deve retornar erro se numPessoas for zero', () => {
    const req = {
      body: {
        totalLitrosGasolina: 20,
        precoGasolina: 5,
        precoManutencao: 10,
        pedagios: 5,
        outros: 5,
        numPessoas: 0
      }
    };

    const res = buildRes();
    controller.calcular(req, res);

    expect(res.status).toHaveBeenCalledWith(400);
    expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
      success: false,
      message: expect.stringMatching(/numPessoas/i)
    }));
  });

  test('Deve retornar erro se nenhum custo for informado', () => {
    const req = {
      body: {
        totalLitrosGasolina: 30,
        precoGasolina: 0,
        precoManutencao: 0,
        pedagios: 0,
        outros: 0,
        numPessoas: 2
      }
    };

    const res = buildRes();
    controller.calcular(req, res);

    expect(res.status).toHaveBeenCalledWith(400);
    expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
      success: false,
      message: expect.stringMatching(/informar ao menos um valor/i)
    }));
  });
});
