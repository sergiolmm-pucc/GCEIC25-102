const controller = require('../controllers/calculoViagemEquipe5Controller');

test('Deve retornar tempo estimado corretamente', () => {
    const req = {
        body: {
            distancia: 240,
            velocidadeMedia: 80
        }
    };

    const res = {
        status: jest.fn().mockReturnThis(),
        json: jest.fn()
    };

    controller.estimativaTempo(req, res);

    expect(res.status).toHaveBeenCalledWith(200);
    expect(res.json).toHaveBeenCalledWith({
        success: true,
        payload: {
            tempoEstimadoHoras: 3,
            tempoFormatado: "3h 0min"
        }
    });
});