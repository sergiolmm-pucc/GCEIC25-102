const {
  calcularINSS,
  calcularIRPF,
  inssFaixa1,
  inssFaixa2,
  inssFaixa3,
  inssFaixa4,
  inssTeto,
  irpfIsento,
  irpfFaixa1,
  irpfFaixa2,
  irpfFaixa3,
  irpfFaixa4,
  calcularFinancas
} = require('../controllers/gestor_financas_controller');
const { loginFixoEquipeTres } = require('../controllers/loginFixoEquipeTresController');

// Mock de req/res para o controller
function makeRes() {
  let statusCode = 200;
  let jsonData = null;
  return {
    status(code) {
      statusCode = code;
      return this;
    },
    json(data) {
      jsonData = data;
      return this;
    },
    send(data) {
      jsonData = data;
      return this;
    },
    get statusCode() {
      return statusCode;
    },
    _getJSONData() {
      return jsonData;
    }
  };
}

describe('Funções auxiliares de INSS', () => {
  test('inssFaixa1', () => {
    expect(inssFaixa1(1000)).toBeCloseTo(75);
  });
  test('inssFaixa2', () => {
    expect(inssFaixa2(2000)).toBeCloseTo(2000 * 0.09 - 22.77);
  });
  test('inssFaixa3', () => {
    expect(inssFaixa3(3000)).toBeCloseTo(3000 * 0.12 - 106.59);
  });
  test('inssFaixa4', () => {
    expect(inssFaixa4(5000)).toBeCloseTo(5000 * 0.14 - 190.40);
  });
  test('inssTeto', () => {
    expect(inssTeto()).toBeCloseTo(8157.41 * 0.14 - 190.40);
  });

  test('calcularINSS em todas as faixas', () => {
    expect(calcularINSS(1000)).toBeCloseTo(inssFaixa1(1000));
    expect(calcularINSS(2000)).toBeCloseTo(inssFaixa2(2000));
    expect(calcularINSS(3000)).toBeCloseTo(inssFaixa3(3000));
    expect(calcularINSS(5000)).toBeCloseTo(inssFaixa4(5000));
    expect(calcularINSS(9000)).toBeCloseTo(inssTeto());
  });
});

describe('Funções auxiliares de IRPF', () => {
  test('irpfIsento', () => {
    expect(irpfIsento(2000)).toBe(0);
  });
  test('irpfFaixa1', () => {
    expect(irpfFaixa1(2500)).toBeCloseTo(2500 * 0.075 - 169.44 - 607.20);
  });
  test('irpfFaixa2', () => {
    expect(irpfFaixa2(3500)).toBeCloseTo(3500 * 0.15 - 381.44 - 607.20);
  });
  test('irpfFaixa3', () => {
    expect(irpfFaixa3(4000)).toBeCloseTo(4000 * 0.225 - 662.77 - 607.20);
  });
  test('irpfFaixa4', () => {
    const base = 5000;
    const expected = base * 0.275 - 896.00 - 607.20;
    expect(irpfFaixa4(base)).toBeCloseTo(expected < 0 ? 0 : expected);
  });

  test('calcularIRPF em todas as faixas', () => {
    expect(calcularIRPF(2000)).toBe(0);
    expect(calcularIRPF(2500)).toBeCloseTo(irpfFaixa1(2500));
    expect(calcularIRPF(3500)).toBeCloseTo(irpfFaixa2(3500));
    expect(calcularIRPF(4000)).toBeCloseTo(irpfFaixa3(4000));
    expect(calcularIRPF(5000)).toBeCloseTo(irpfFaixa4(5000));
  });
});

describe('Controller calcularFinancas', () => {
  test('Cálculo de finanças válido', () => {
    const req = {
      body: {
        salarioBruto: 5000,
        gastosFixos: [
          { nome: 'Aluguel', valor: 1500 },
          { nome: 'Internet', valor: 100 }
        ],
        percentualInvestimento: 10,
        percentualLazer: 5
      }
    };
    const res = makeRes();

    calcularFinancas(req, res);
    const data = res._getJSONData();

    expect(res.statusCode).toBe(200);
    expect(data).toHaveProperty('inss');
    expect(data).toHaveProperty('irpf');
    expect(data).toHaveProperty('gastosTotais');
    expect(data).toHaveProperty('salarioLiquido');
    expect(data).toHaveProperty('valorInvestimento');
    expect(data).toHaveProperty('valorLazer');
    expect(data).toHaveProperty('saldoFinal');
  });

  test('Erro quando salário bruto é inválido', () => {
    const req = {
      body: {
        salarioBruto: -1000,
        gastosFixos: [],
        percentualInvestimento: 10,
        percentualLazer: 5
      }
    };
    const res = makeRes();

    calcularFinancas(req, res);
    const data = res._getJSONData();

    expect(res.statusCode).toBe(400);
    expect(data.erro).toBe('Salário bruto inválido ou ausente.');
  });

  test('Erro quando percentual de lazer é inválido', () => {
    const req = {
      body: {
        salarioBruto: 3000,
        gastosFixos: [],
        percentualInvestimento: 10,
        percentualLazer: 150
      }
    };
    const res = makeRes();

    calcularFinancas(req, res);
    const data = res._getJSONData();

    expect(res.statusCode).toBe(400);
    expect(data.erro).toBe('Percentual para lazer inválido.');
  });
});

describe('Controller loginFixoEquipeTres', () => {
  test('Login com credenciais corretas (admin/admin123)', () => {
    const req = {
      body: {
        username: 'admin',
        password: 'admin123'
      }
    };
    const res = makeRes();

    loginFixoEquipeTres(req, res);
    const data = res._getJSONData();

    expect(res.statusCode).toBe(200);
    expect(data.success).toBe(true);
    expect(data.message).toBe('Login efetuado com sucesso');
  });

  test('Login com credenciais incorretas', () => {
    const req = {
      body: {
        username: 'usuario',
        password: 'senhaerrada'
      }
    };
    const res = makeRes();

    loginFixoEquipeTres(req, res);
    const data = res._getJSONData();

    expect(res.statusCode).toBe(401);
    expect(data.success).toBe(false);
    expect(data.message).toBe('Usuário ou senha incorretos');
  });
});
