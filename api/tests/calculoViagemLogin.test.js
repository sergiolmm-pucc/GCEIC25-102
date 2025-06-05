const index = require('../controllers/loginCalculadoraViagemController');

describe('Teste de login', () => {
    test('Tentar fazer login com sucesso', () => {
        const req = {
            body: {
                username: 'tester',
                password: 'teste123'
            }
        };

        const res = {
            status: jest.fn().mockReturnThis(),   // permite encadear .json()
            json: jest.fn()
        };

        index.login(req, res);

        // Verifica se retornou status 200
        expect(res.status).toHaveBeenCalledWith(200);
        expect(res.json).toHaveBeenCalledWith({
            success: true,
            message: 'Login efetuado com sucesso!'
        });
    });

    test('Tentar fazer login com falha', () => {
        const req = {
            body: {
                username: 'errado',
                password: '123'
            }
        };

        const res = {
            status: jest.fn().mockReturnThis(),
            json: jest.fn()
        };

        index.login(req, res);

        expect(res.status).toHaveBeenCalledWith(401);
        expect(res.json).toHaveBeenCalledWith({
            success: false,
            message: 'Usuário ou senha incorretos.'
        });
    });
});
