const request = require('supertest');
const express = require('express');
const etecRoutes = require('../routes/etecRoutes');

const app = express();
app.use(express.json());
app.use('/ETEC', etecRoutes);

describe('POST /ETEC/calcular', () => {
  it('Deve retornar os encargos corretamente', async () => {
    const res = await request(app).post('/ETEC/calcular').send({ salario: 1500 });
    expect(res.statusCode).toEqual(200);
    expect(res.body.totalEncargos).toBeCloseTo(410);
  });

  it('Deve retornar erro se salário for inválido', async () => {
    const res = await request(app).post('/ETEC/calcular').send({ salario: -100 });
    expect(res.statusCode).toEqual(400);
  });
});
