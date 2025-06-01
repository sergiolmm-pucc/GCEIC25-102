exports.calcular = (req, res) => {
    let {
        distancia = 0,
        kilometragemPorLitro,
        precoGasolina = 0,
        precoManutencao = 0,
        pedagios = 0,
        outros = 0,
        numPessoas
    } = req.body;

    kilometragemPorLitro = parseFloat(kilometragemPorLitro);
    numPessoas = parseInt(numPessoas);

    if (!kilometragemPorLitro || !numPessoas || numPessoas <= 0 || kilometragemPorLitro <= 0) {
        return res.status(400).json({ success: false, message: "A kilometragem por litro e o número de pessoas são obrigatórios e devem ser maior que zero." });
    }

    if (!distancia && !precoGasolina && !precoManutencao && !pedagios && !outros){ 
        return res.status(400).json({ success: false, message: "Você deve informar ao menos um campo!" });
    }

    const totalLitrosGasolina = distancia / kilometragemPorLitro;
    const totalGasolina = precoGasolina * totalLitrosGasolina;
    const precoTotal = totalGasolina + precoManutencao + pedagios + outros;
    const precoPorPessoa = precoTotal / numPessoas;

    res.status(200).json({
        success: true,
        payload: {
            totalGasolina,
            totalLitrosGasolina,
            precoTotal,
            precoPorPessoa,
        }
    });
}
