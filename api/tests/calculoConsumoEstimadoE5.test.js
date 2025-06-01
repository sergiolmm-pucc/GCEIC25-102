const controller = require('../controllers/calculoViagemEquipe5Controller');

test('Deve calcular consumo estimado com sucesso', () => {
    const req = {
        body: {
            distancia: 200,
            kilometragemPorLitro: 10
        }
    };

    const res = {
        status: jest.fn().mockReturnThis(),
        json: jest.fn()
    };

    controller.consumoEstimado(req, res);

    expect(res.status).toHaveBeenCalledWith(200);
    expect(res.json).toHaveBeenCalledWith({
        success: true,
        litrosNecessarios: 20
    });
});