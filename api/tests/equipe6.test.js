const controller = require('../controllers/equipe6Controller');

describe('Equipe 6 - Cálculo de salário com INSS, FGTS e divisão 40/30/30', () => {
  const createResMock = () => {
    return {
      status: jest.fn().mockReturnThis(),
      json: jest.fn()
    };
  };

  test.each([
    {
      salario: 1000,
      inss: 0,
      fgts: 0,
      liquido: 1000,
    },
    {
      salario: 2500,
      inss: 0,
      fgts: 0,
      liquido: 2500,
    },
    {
      salario: 3500,
      inss: 280,
      fgts: 280,
      liquido: 2940,
    }
  ])('Salário $salario → cálculo correto', ({ salario, inss, fgts, liquido }) => {
    const req = { body: { salario } };
    const res = createResMock();

    controller.calcularSalario(req, res);

    expect(res.status).not.toHaveBeenCalled(); // Deve retornar 200

    expect(res.json).toHaveBeenCalledWith({
      inss: inss.toFixed(2),
      fgts: fgts.toFixed(2),
      salarioLiquido: liquido.toFixed(2),
      sugestaoDivisao: {
        necessidades: (liquido * 0.4).toFixed(2),
        lazer: (liquido * 0.3).toFixed(2),
        poupanca: (liquido * 0.3).toFixed(2)
      }
    });
  });

  test.each([
    { descricao: 'salário ausente', body: {} },
    { descricao: 'salário como string', body: { salario: "mil" } },
    { descricao: 'salário negativo', body: { salario: -1000 } },
    { descricao: 'salário igual a 0', body: { salario: 0 } },
    { descricao: 'salário null', body: { salario: null } },
  ])('Entrada inválida ($descricao)', ({ body }) => {
    const req = { body };
    const res = createResMock();

    controller.calcularSalario(req, res);

    expect(res.status).toHaveBeenCalledWith(400);
    expect(res.json).toHaveBeenCalledWith({ error: 'Salário inválido' });
  });
});
