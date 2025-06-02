// PROJETO SERGIO NODE/api/controllers/viagemController.js

const calcularCustoViagem = (req, res) => {
    const {
        pais,
        temporada,
        companhiaAerea,
        hotel,
        diasEstadia,
        quantidadeRestaurantes,
        quantidadePessoas
    } = req.body;

    if (!pais || !temporada || !companhiaAerea || !hotel ||
        diasEstadia === undefined || quantidadeRestaurantes === undefined || quantidadePessoas === undefined) {
        return res.status(400).json({
            success: false,
            mensagem: "Todos os campos da viagem são obrigatórios."
        });
    }

    const parsedDiasEstadia = parseInt(diasEstadia);
    const parsedQuantidadeRestaurantes = parseInt(quantidadeRestaurantes);
    const parsedQuantidadePessoas = parseInt(quantidadePessoas);

    // *** MENSAGEM DE ERRO CORRIGIDA AQUI ***
    if (isNaN(parsedDiasEstadia) || parsedDiasEstadia <= 0 ||
        isNaN(parsedQuantidadeRestaurantes) || parsedQuantidadeRestaurantes < 0 || // Restaurantes pode ser 0
        isNaN(parsedQuantidadePessoas) || parsedQuantidadePessoas <= 0) {
        return res.status(400).json({
            success: false,
            mensagem: "Dias de estadia, restaurantes e quantidade de pessoas devem ser números inteiros positivos (ou zero para restaurantes)." // <--- LINHA ALTERADA
        });
    }

    let custoTotal = 0;

    const precosPaises = {
        "Brasil": 1500, "Argentina": 1800, "Chile": 2000, "Portugal": 3000,
        "Espanha": 3200, "Franca": 3500, "Italia": 3400, "Alemanha": 3300,
        "EUA": 4000, "Canada": 3800
    };
    if (!precosPaises[pais]) {
        return res.status(400).json({
            success: false,
            mensagem: `País '${pais}' não encontrado na lista de destinos.`
        });
    }
    custoTotal += precosPaises[pais];

    const precosCompanhiaAerea = { "Latam": 800, "Azul": 950, "Gol": 750 };
    if (!precosCompanhiaAerea[companhiaAerea]) {
        return res.status(400).json({
            success: false,
            mensagem: `Companhia aérea '${companhiaAerea}' não encontrada.`
        });
    }
    custoTotal += precosCompanhiaAerea[companhiaAerea];

    const precosHotelPorDia = {
        "Hotel Luxo": 1000, "Hotel Conforto": 600, "Pousada Simples": 300,
        "Hostel Economico": 150
    };
    if (!precosHotelPorDia[hotel]) {
        return res.status(400).json({
            success: false,
            mensagem: `Hotel '${hotel}' não encontrado.`
        });
    }
    custoTotal += (precosHotelPorDia[hotel] * parsedDiasEstadia);

    custoTotal += parsedQuantidadeRestaurantes * 120;


    // *** ORDEM DO CÁLCULO DA TEMPORADA ALTERADA AQUI ***
    if (temporada.toLowerCase() === 'alta') {
        custoTotal *= 1.2; // <--- AGORA APLICADO AO SUBTOTAL COMPLETO ANTES DAS PESSOAS
    } else if (temporada.toLowerCase() !== 'baixa') {
        return res.status(400).json({
            success: false,
            mensagem: "Temporada deve ser 'alta' ou 'baixa'."
        });
    }

    custoTotal *= parsedQuantidadePessoas; // <--- APLICADO POR ÚLTIMO

    res.json({
        success: true,
        custoTotal: parseFloat(custoTotal).toFixed(2),
        mensagem: "Cálculo da viagem realizado com sucesso!"
    });
};

module.exports = {
    calcularCustoViagem
};