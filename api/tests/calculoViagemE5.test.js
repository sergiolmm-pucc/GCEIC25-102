const controller = require('../controllers/calculoViagemEquipe5Controller');

describe('Teste da função calcular', () => {
    const buildRes = () => ({
        status: jest.fn().mockReturnThis(),
        json: jest.fn()
    });

    test('Deve calcular com sucesso todos os custos', () => {
        const req = {
            body: {
                distancia: 100,
                kilometragemPorLitro: 10,
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
                totalGasolina: 50, // 100 km / 10 km/L * R$5
                totalLitrosGasolina: 10, // 100km / 10km/L
                precoTotal: 110,   // 50 + 20 + 30 + 10
                precoPorPessoa: 55 // 110 / 2
            }
        });
    });

    test('Deve retornar erro se kilometragem ou número de pessoas estiver ausente', () => {
        const req = {
            body: {
                distancia: 100,
                precoGasolina: 5
            }
        };

        const res = buildRes();
        controller.calcular(req, res);

        expect(res.status).toHaveBeenCalledWith(400);
        expect(res.json).toHaveBeenCalledWith({
            success: false,
            message: "A kilometragem por litro e o número de pessoas são obrigatórios e devem ser maior que zero."
        });
    });

    test('Deve retornar erro se nenhum dos campos principais for fornecido', () => {
        const req = {
            body: {
                kilometragemPorLitro: 10,
                numPessoas: 2
            }
        };

        const res = buildRes();
        controller.calcular(req, res);

        expect(res.status).toHaveBeenCalledWith(400);
        expect(res.json).toHaveBeenCalledWith({
            success: false,
            message: "Você deve informar ao menos um campo!"
        });
    });

    test('Deve lidar com número de pessoas igual a zero', () => {
        const req = {
            body: {
                distancia: 100,
                kilometragemPorLitro: 10,
                precoGasolina: 5,
                precoManutencao: 20,
                pedagios: 30,
                outros: 10,
                numPessoas: 0
            }
        };

        const res = buildRes();
        controller.calcular(req, res);

        expect(res.status).toHaveBeenCalledWith(400);
        expect(res.json).toHaveBeenCalledWith({
            success: false,
            message: "A kilometragem por litro e o número de pessoas são obrigatórios e devem ser maior que zero."
        });
    });

    test('Deve lidar com kilometragem igual a zero', () => {
        const req = {
            body: {
                distancia: 100,
                kilometragemPorLitro: 0,
                precoGasolina: 5,
                precoManutencao: 20,
                pedagios: 30,
                outros: 10,
                numPessoas: 3
            }
        };

        const res = buildRes();
        controller.calcular(req, res);

        expect(res.status).toHaveBeenCalledWith(400);
        expect(res.json).toHaveBeenCalledWith({
            success: false,
            message: "A kilometragem por litro e o número de pessoas são obrigatórios e devem ser maior que zero."
        });
    });
});
