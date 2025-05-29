// PROJETO SERGIO NODE/api/tests/viagem.test.js
const request = require('supertest');
// NÂO importe 'app' de '../server' aqui diretamente.
// O supertest vai se conectar ao servidor já rodando em http://localhost:3000.

// Remova completamente os blocos beforeAll e afterAll que você tinha anteriormente neste arquivo.

describe('API de Viagem - Cálculos (Equipe 2)', () => {

    // Teste de cenário básico em baixa temporada
    it('deve calcular o custo total de uma viagem para o Brasil em baixa temporada para 2 pessoas', async () => {
        // Conecte-se ao servidor na URL. Certifique-se que o servidor está rodando (npm start) antes dos testes.
        const res = await request('http://localhost:3000')
            .post('/viagens2/calcular') // Seu endpoint da API
            .send({
                pais: "Brasil",
                temporada: "baixa",
                companhiaAerea: "Latam",
                hotel: "Pousada Simples",
                diasEstadia: 7,
                quantidadeRestaurantes: 3,
                quantidadePessoas: 2
            });

        // Cálculo esperado:
        // País: 1500 + Companhia Aérea: 800 + Hotel (300/dia * 7 dias): 2100 + Restaurantes (3 * 120): 360
        // Subtotal: 1500 + 800 + 2100 + 360 = 4760
        // Total para 2 pessoas: 4760 * 2 = 9520
        expect(res.statusCode).toEqual(200);
        expect(res.body.success).toBe(true);
        expect(parseFloat(res.body.custoTotal)).toBeCloseTo(9520.00, 2);
        expect(res.body.mensagem).toEqual("Cálculo da viagem realizado com sucesso!");
    });

    // Teste de cenário em alta temporada (aumento de 20%)
    it('deve aplicar acréscimo de 20% para alta temporada', async () => {
        const res = await request('http://localhost:3000')
            .post('/viagens2/calcular')
            .send({
                pais: "Portugal",
                temporada: "alta", // Alta temporada
                companhiaAerea: "Azul",
                hotel: "Hotel Luxo",
                diasEstadia: 5,
                quantidadeRestaurantes: 2,
                quantidadePessoas: 1
            });

        // Cálculo esperado:
        // País: 3000 + Companhia Aérea: 950 + Hotel (1000/dia * 5 dias): 5000 + Restaurantes (2 * 120): 240
        // Subtotal: 3000 + 950 + 5000 + 240 = 9190
        // Total em alta temporada: 9190 * 1.2 = 11028
        expect(res.statusCode).toEqual(200);
        expect(res.body.success).toBe(true);
        expect(parseFloat(res.body.custoTotal)).toBeCloseTo(11028.00, 2);
    });

    // Teste de validação: campos faltando
    it('deve retornar erro 400 se campos obrigatórios estiverem faltando', async () => {
        const res = await request('http://localhost:3000')
            .post('/viagens2/calcular')
            .send({
                pais: "Brasil",
                temporada: "baixa",
                // faltando companhiaAerea
                hotel: "Pousada Simples",
                diasEstadia: 5,
                quantidadeRestaurantes: 2,
                quantidadePessoas: 1
            });
        expect(res.statusCode).toEqual(400);
        expect(res.body.success).toBe(false);
        expect(res.body.mensagem).toEqual("Todos os campos da viagem são obrigatórios.");
    });

    // Teste de validação: valores numéricos inválidos
    it('deve retornar erro 400 se diasEstadia for zero ou negativo', async () => {
        const res = await request('http://localhost:3000')
            .post('/viagens2/calcular')
            .send({
                pais: "Brasil",
                temporada: "baixa",
                companhiaAerea: "Latam",
                hotel: "Pousada Simples",
                diasEstadia: 0, // Inválido
                quantidadeRestaurantes: 2,
                quantidadePessoas: 1
            });
        expect(res.statusCode).toEqual(400);
        expect(res.body.success).toBe(false);
        expect(res.body.mensagem).toEqual("Dias de estadia, restaurantes e quantidade de pessoas devem ser números inteiros positivos (ou zero para restaurantes).");
    });

    // Teste de validação: país não encontrado
    it('deve retornar erro 400 se o país não estiver na lista', async () => {
        const res = await request('http://localhost:3000')
            .post('/viagens2/calcular')
            .send({
                pais: "Marte", // País inválido
                temporada: "baixa",
                companhiaAerea: "Latam",
                hotel: "Pousada Simples",
                diasEstadia: 5,
                quantidadeRestaurantes: 2,
                quantidadePessoas: 1
            });
        expect(res.statusCode).toEqual(400);
        expect(res.body.success).toBe(false);
        expect(res.body.mensagem).toEqual("País 'Marte' não encontrado na lista de destinos.");
    });
});