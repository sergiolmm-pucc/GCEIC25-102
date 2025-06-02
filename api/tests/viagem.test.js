// viagem.test.js
const request = require('supertest');

// Função utilitária para criar um mock de resposta Express
function mockResponse() {
  const res = {};
  res.status = jest.fn().mockReturnValue(res);
  res.json = jest.fn().mockReturnValue(res);
  return res;
}

describe('Função calcularCustoViagem', () => {
  let app;
  let viagemController;

  beforeAll(() => {
    // Carrega o controller diretamente
    viagemController = require('../controllers/viagemController');
    // Cria um app Express para testes de integração
    const express = require('express');
    app = express();
    app.use(express.json());
    app.post('/viagens2/calcular', viagemController.calcularCustoViagem);
  });

  test('Deve calcular corretamente o custo total em baixa temporada', async () => {
    const res = await request(app)
      .post('/viagens2/calcular')
      .send({
        pais: 'Brasil',
        temporada: 'baixa',
        companhiaAerea: 'Latam',
        hotel: 'Pousada Simples',
        diasEstadia: 7,
        quantidadeRestaurantes: 3,
        quantidadePessoas: 2
      });
    expect(res.statusCode).toBe(200);
    expect(res.body.success).toBe(true);
    expect(parseFloat(res.body.custoTotal)).toBeCloseTo(9520.00, 2);
    expect(res.body.mensagem).toBe('Cálculo da viagem realizado com sucesso!');
  });

  test('Deve aplicar acréscimo de 20% para alta temporada', async () => {
    const res = await request(app)
      .post('/viagens2/calcular')
      .send({
        pais: 'Portugal',
        temporada: 'alta',
        companhiaAerea: 'Azul',
        hotel: 'Hotel Luxo',
        diasEstadia: 5,
        quantidadeRestaurantes: 2,
        quantidadePessoas: 1
      });
    expect(res.statusCode).toBe(200);
    expect(res.body.success).toBe(true);
    expect(parseFloat(res.body.custoTotal)).toBeCloseTo(11028.00, 2);
    expect(res.body.mensagem).toBe('Cálculo da viagem realizado com sucesso!');
  });

  test('Deve retornar erro 400 se campos obrigatórios estiverem faltando', async () => {
    const res = await request(app)
      .post('/viagens2/calcular')
      .send({
        pais: 'Brasil',
        temporada: 'baixa',
        // faltando companhiaAerea
        hotel: 'Pousada Simples',
        diasEstadia: 5,
        quantidadeRestaurantes: 2,
        quantidadePessoas: 1
      });
    expect(res.statusCode).toBe(400);
    expect(res.body.success).toBe(false);
    expect(res.body.mensagem).toBe('Todos os campos da viagem são obrigatórios.');
  });

  test('Deve retornar erro 400 se diasEstadia for zero ou negativo', async () => {
    const res = await request(app)
      .post('/viagens2/calcular')
      .send({
        pais: 'Brasil',
        temporada: 'baixa',
        companhiaAerea: 'Latam',
        hotel: 'Pousada Simples',
        diasEstadia: 0,
        quantidadeRestaurantes: 2,
        quantidadePessoas: 1
      });
    expect(res.statusCode).toBe(400);
    expect(res.body.success).toBe(false);
    expect(res.body.mensagem).toBe('Dias de estadia, restaurantes e quantidade de pessoas devem ser números inteiros positivos (ou zero para restaurantes).');
  });

  test('Deve retornar erro 400 se o país não estiver na lista', async () => {
    const res = await request(app)
      .post('/viagens2/calcular')
      .send({
        pais: 'Marte',
        temporada: 'baixa',
        companhiaAerea: 'Latam',
        hotel: 'Pousada Simples',
        diasEstadia: 5,
        quantidadeRestaurantes: 2,
        quantidadePessoas: 1
      });
    expect(res.statusCode).toBe(400);
    expect(res.body.success).toBe(false);
    expect(res.body.mensagem).toBe("País 'Marte' não encontrado na lista de destinos.");
  });

  test('Deve retornar erro 400 se companhia aérea não existir', async () => {
    const res = await request(app)
      .post('/viagens2/calcular')
      .send({
        pais: 'Brasil',
        temporada: 'baixa',
        companhiaAerea: 'SpaceX',
        hotel: 'Pousada Simples',
        diasEstadia: 5,
        quantidadeRestaurantes: 2,
        quantidadePessoas: 1
      });
    expect(res.statusCode).toBe(400);
    expect(res.body.success).toBe(false);
    expect(res.body.mensagem).toBe("Companhia aérea 'SpaceX' não encontrada.");
  });

  test('Deve retornar erro 400 se hotel não existir', async () => {
    const res = await request(app)
      .post('/viagens2/calcular')
      .send({
        pais: 'Brasil',
        temporada: 'baixa',
        companhiaAerea: 'Latam',
        hotel: 'Hotel Inexistente',
        diasEstadia: 5,
        quantidadeRestaurantes: 2,
        quantidadePessoas: 1
      });
    expect(res.statusCode).toBe(400);
    expect(res.body.success).toBe(false);
    expect(res.body.mensagem).toBe("Hotel 'Hotel Inexistente' não encontrado.");
  });

  test('Deve retornar erro 400 se temporada for inválida', async () => {
    const res = await request(app)
      .post('/viagens2/calcular')
      .send({
        pais: 'Brasil',
        temporada: 'media',
        companhiaAerea: 'Latam',
        hotel: 'Pousada Simples',
        diasEstadia: 5,
        quantidadeRestaurantes: 2,
        quantidadePessoas: 1
      });
    expect(res.statusCode).toBe(400);
    expect(res.body.success).toBe(false);
    expect(res.body.mensagem).toBe("Temporada deve ser 'alta' ou 'baixa'.");
  });

  test('Deve retornar erro 400 se quantidadeRestaurantes for negativa', async () => {
    const res = await request(app)
      .post('/viagens2/calcular')
      .send({
        pais: 'Brasil',
        temporada: 'baixa',
        companhiaAerea: 'Latam',
        hotel: 'Pousada Simples',
        diasEstadia: 5,
        quantidadeRestaurantes: -1,
        quantidadePessoas: 1
      });
    expect(res.statusCode).toBe(400);
    expect(res.body.success).toBe(false);
    expect(res.body.mensagem).toBe('Dias de estadia, restaurantes e quantidade de pessoas devem ser números inteiros positivos (ou zero para restaurantes).');
  });

  test('Deve retornar erro 400 se quantidadePessoas for zero ou negativa', async () => {
    const res = await request(app)
      .post('/viagens2/calcular')
      .send({
        pais: 'Brasil',
        temporada: 'baixa',
        companhiaAerea: 'Latam',
        hotel: 'Pousada Simples',
        diasEstadia: 5,
        quantidadeRestaurantes: 2,
        quantidadePessoas: 0
      });
    expect(res.statusCode).toBe(400);
    expect(res.body.success).toBe(false);
    expect(res.body.mensagem).toBe('Dias de estadia, restaurantes e quantidade de pessoas devem ser números inteiros positivos (ou zero para restaurantes).');
  });
});