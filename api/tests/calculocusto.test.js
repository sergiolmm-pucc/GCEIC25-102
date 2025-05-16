const { calculateCost, aplicarDesconto } = require('../controllers/funcoes_base');
const baseController = require('../controllers/baseController');
const userController = require('../controllers/userController');
const request = require('supertest');
const express = require('express');

// Mock Express app for route testing
const app = express();
app.use(express.json());

// Import routes
const baseRoutes = require('../routes/baseRoutes');
const userRoutes = require('../routes/userRoutes');

// Apply routes to mock app
app.use('/', baseRoutes);
app.use('/users', userRoutes);

// Mock Response object
const mockResponse = () => {
  const res = {};
  res.status = jest.fn().mockReturnValue(res);
  res.json = jest.fn().mockReturnValue(res);
  res.send = jest.fn().mockReturnValue(res);
  return res;
};

// Mock Request object
const mockRequest = (body = {}, params = {}, query = {}) => ({
  body,
  params,
  query
});

describe('Teste de Funções Base', () => {
  // Testes para aplicarDesconto
  test('Aplicar desconto com valor maior que desconto', () => {
    const result = aplicarDesconto(100, 20);
    expect(result).toEqual(80);
  });

  test('Aplicar desconto com valor igual ao desconto', () => {
    const result = aplicarDesconto(50, 50);
    expect(result).toEqual(0);
  });

  test('Aplicar desconto com desconto maior que valor', () => {
    const result = aplicarDesconto(30, 50);
    expect(result).toEqual(0);
  });

  // Testes para calculateCost
  test('Calcula custo básico de container 20ft', () => {
    const input = {
      containers: 1,
      container_size: '20ft',
      finish_level: 'basico',
      foundation_type: 'sapata',
      insulation: 'nenhum',
      electricity: false,
      plumbing: false,
      solar_energy: false,
      windows: 2,
      doors: 1,
      custom_furniture: false,
      project_ready: true,
      distance: 0,
      rooms: 1
    };
    const result = calculateCost(input);
    expect(result).toEqual(13000 + 5000 + (2 * 800) + (1 * 1000) + (1 * 4800));
  });

  test('Calcula custo de container 40ft com acabamento intermediário', () => {
    const input = {
      containers: 1,
      container_size: '40ft',
      finish_level: 'intermediario',
      foundation_type: 'radier',
      insulation: 'poliuretano',
      electricity: true,
      plumbing: true,
      solar_energy: false,
      windows: 4,
      doors: 2,
      custom_furniture: true,
      project_ready: false,
      distance: 10,
      rooms: 2
    };
    const expectedBase = 20000;
    const expectedTotal = Math.round((expectedBase * 3.5) + 8000 + 4000 + (10 * 15) + 3000 + 3000 + (4 * 800) + (2 * 1000) + 8000 + 4000 + (2 * 4800));
    const result = calculateCost(input);
    expect(result).toEqual(expectedTotal);
  });

  test('Calcula custo com valores padrão para parâmetros opcionais', () => {
    const input = {
      containers: 1,
      container_size: '20ft',
      finish_level: 'basico',
      foundation_type: 'sapata',
      insulation: 'nenhum',
      electricity: false,
      plumbing: false,
      solar_energy: false,
      windows: 1,
      doors: 1,
      custom_furniture: false,
      project_ready: true
      // distance e rooms não fornecidos - devem usar valores padrão
    };
    const result = calculateCost(input);
    expect(result).toEqual(13000 + 5000 + 800 + 1000 + 4800); // 24600
  });
});

describe('Teste do BaseController', () => {
  test('datetime retorna data e hora ISO', () => {
    const req = mockRequest();
    const res = mockResponse();
    
    baseController.datetime(req, res);
    
    expect(res.json).toHaveBeenCalled();
    const jsonArg = res.json.mock.calls[0][0];
    expect(jsonArg).toHaveProperty('datetime');
    expect(typeof jsonArg.datetime).toBe('string');
    // Verifica se é uma data ISO válida
    expect(new Date(jsonArg.datetime).toISOString()).toEqual(jsonArg.datetime);
  });

  test('data retorna data e hora ISO', () => {
    const req = mockRequest();
    const res = mockResponse();
    
    baseController.data(req, res);
    
    expect(res.json).toHaveBeenCalled();
    const jsonArg = res.json.mock.calls[0][0];
    expect(jsonArg).toHaveProperty('datetime');
  });

  test('concat retorna valor concatenado com frase fixa', () => {
    const req = mockRequest({ value: 'Teste' });
    const res = mockResponse();
    
    baseController.concat(req, res);
    
    expect(res.json).toHaveBeenCalledWith({
      success: true,
      result: 'Teste - Esta é uma frase fixa.'
    });
  });

  test('concat retorna erro quando valor não é fornecido', () => {
    const req = mockRequest({ value: undefined });
    const res = mockResponse();
    
    baseController.concat(req, res);
    
    expect(res.status).toHaveBeenCalledWith(400);
    expect(res.json).toHaveBeenCalledWith({
      success: false,
      message: 'Valor não fornecido'
    });
  });

  test('calcularCustoCasaContainer calcula o custo total', () => {
    const input = {
      containers: 1,
      container_size: '20ft',
      finish_level: 'basico',
      foundation_type: 'sapata',
      insulation: 'nenhum',
      electricity: false,
      plumbing: false,
      solar_energy: false,
      windows: 1,
      doors: 1,
      custom_furniture: false,
      project_ready: true,
      distance: 0,
      rooms: 1
    };
    const req = mockRequest(input);
    const res = mockResponse();
    
    baseController.calcularCustoCasaContainer(req, res);
    
    expect(res.json).toHaveBeenCalled();
    const jsonArg = res.json.mock.calls[0][0];
    expect(jsonArg).toHaveProperty('custoTotal');
    expect(typeof jsonArg.custoTotal).toBe('number');
  });

  test('calcularCustoCasaContainer retorna erro em caso de falha', () => {
    // Missing required fields to force an error
    const req = mockRequest({
      // Completely empty object to cause an error
    });
    const res = mockResponse();
    
    baseController.calcularCustoCasaContainer(req, res);
    
    expect(res.status).toHaveBeenCalledWith(400);
    expect(res.json).toHaveBeenCalled();
    const jsonArg = res.json.mock.calls[0][0];
    expect(jsonArg).toHaveProperty('error');
  });
});

describe('Teste do UserController', () => {
  test('listUsers retorna dados do usuário', () => {
    const req = mockRequest();
    const res = mockResponse();
    
    userController.listUsers(req, res);
    
    expect(res.json).toHaveBeenCalled();
    const jsonArg = res.json.mock.calls[0][0];
    expect(jsonArg).toHaveProperty('datetime');
    expect(jsonArg).toHaveProperty('usuario', 'sergio');
    expect(jsonArg).toHaveProperty('turma', '102');
  });

  test('getUserById retorna usuário pelo ID', () => {
    const req = mockRequest({}, { id: '123' });
    const res = mockResponse();
    
    userController.getUserById(req, res);
    
    expect(res.send).toHaveBeenCalledWith('Buscando usuário com ID: 123');
  });

  test('createUser retorna mensagem de criação', () => {
    const req = mockRequest();
    const res = mockResponse();
    
    userController.createUser(req, res);
    
    expect(res.send).toHaveBeenCalledWith('Criando um novo usuário');
  });
});

describe('Teste de Integração das Rotas e Servidor', () => {
  test('GET /datetime retorna data e hora', async () => {
    const response = await request(app).get('/datetime');
    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty('datetime');
  });

  test('GET /data retorna data e hora', async () => {
    const response = await request(app).get('/data');
    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty('datetime');
  });

  test('POST /concat retorna valor concatenado', async () => {
    const response = await request(app)
      .post('/concat')
      .send({ value: 'Teste' })
      .set('Accept', 'application/json');
    
    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty('success', true);
    expect(response.body).toHaveProperty('result', 'Teste - Esta é uma frase fixa.');
  });

  test('POST /calcular-custo-casa-container calcula custo', async () => {
    const input = {
      containers: 1,
      container_size: '20ft',
      finish_level: 'basico',
      foundation_type: 'sapata',
      insulation: 'nenhum',
      electricity: false,
      plumbing: false,
      solar_energy: false,
      windows: 1,
      doors: 1,
      custom_furniture: false,
      project_ready: true,
      distance: 0,
      rooms: 1
    };
    
    const response = await request(app)
      .post('/calcular-custo-casa-container')
      .send(input)
      .set('Accept', 'application/json');
    
    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty('custoTotal');
    expect(typeof response.body.custoTotal).toBe('number');
  });

  test('GET /users retorna lista de usuários', async () => {
    const response = await request(app).get('/users');
    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty('usuario', 'sergio');
    expect(response.body).toHaveProperty('turma', '102');
  });

  test('GET /users/:id retorna usuário pelo ID', async () => {
    const response = await request(app).get('/users/123');
    expect(response.status).toBe(200);
    expect(response.text).toBe('Buscando usuário com ID: 123');
  });

  test('POST /users cria um novo usuário', async () => {
    const response = await request(app)
      .post('/users')
      .send({})
      .set('Accept', 'application/json');
    
    expect(response.status).toBe(200);
    expect(response.text).toBe('Criando um novo usuário');
  });
  
  test('POST /calcular-custo-casa-container retorna erro com parâmetros inválidos', async () => {
    const response = await request(app)
      .post('/calcular-custo-casa-container')
      .send({}) // Enviar objeto vazio para testar validação
      .set('Accept', 'application/json');
    
    expect(response.status).toBe(400);
    expect(response.body).toHaveProperty('error');
  });
});