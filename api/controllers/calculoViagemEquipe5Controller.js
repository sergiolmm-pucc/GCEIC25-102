exports.calcular = (req, res) => {
  let {
    totalLitrosGasolina,
    precoGasolina = 0,
    precoManutencao = 0,
    pedagios = 0,
    outros = 0,
    numPessoas
  } = req.body;

  // Conversões
  totalLitrosGasolina = parseFloat(totalLitrosGasolina);
  precoGasolina = parseFloat(precoGasolina);
  precoManutencao = parseFloat(precoManutencao);
  pedagios = parseFloat(pedagios);
  outros = parseFloat(outros);
  numPessoas = parseInt(numPessoas);

  // Validações
  if (
    totalLitrosGasolina == null || isNaN(totalLitrosGasolina) || totalLitrosGasolina <= 0 ||
    precoGasolina == null || isNaN(precoGasolina) ||
    numPessoas == null || isNaN(numPessoas) || numPessoas <= 0
  ) {
    return res.status(400).json({
      success: false,
      message: "totalLitrosGasolina, precoGasolina e numPessoas são obrigatórios e devem ser maiores que zero."
    });
  }

  if (!precoGasolina && !precoManutencao && !pedagios && !outros) {
    return res.status(400).json({
      success: false,
      message: "Você deve informar ao menos um valor de custo."
    });
  }

  // Cálculo
  const totalGasolina = precoGasolina * totalLitrosGasolina;
  const precoTotal = totalGasolina + precoManutencao + pedagios + outros;
  const precoPorPessoa = precoTotal / numPessoas;

  res.status(200).json({
    success: true,
    payload: {
      totalGasolina: Number(totalGasolina.toFixed(2)),
      totalLitrosGasolina: Number(totalLitrosGasolina.toFixed(2)),
      precoTotal: Number(precoTotal.toFixed(2)),
      precoPorPessoa: Number(precoPorPessoa.toFixed(2))
    }
  });
};


exports.consumoEstimado = (req, res) => {
    const { distancia, kilometragemPorLitro } = req.body;

    if (!distancia || !kilometragemPorLitro) {
        return res.status(400).json({
            success: false,
            message: 'Distância e kilometragem por litro são obrigatórios.'
        });
    }

    if (kilometragemPorLitro <= 0) {
        return res.status(400).json({
            success: false,
            message: 'A kilometragem por litro deve ser maior que zero.'
        });
    }

    const litrosNecessarios = distancia / kilometragemPorLitro;

    res.status(200).json({
        success: true,
        litrosNecessarios: Number(litrosNecessarios.toFixed(2))
    });
};

exports.estimativaTempo = (req, res) => {
    const { distancia, velocidadeMedia } = req.body;

    console.log(distancia, velocidadeMedia)

    if (!distancia || !velocidadeMedia) {
        return res.status(400).json({
            success: false,
            message: 'Distância e velocidade média são obrigatórios.'
        });
    }

    if (velocidadeMedia <= 0) {
        return res.status(400).json({
            success: false,
            message: 'Velocidade média deve ser maior que zero.'
        });
    }

    const tempoHoras = distancia / velocidadeMedia;
    const horas = Math.floor(tempoHoras);
    const minutos = Math.round((tempoHoras - horas) * 60);


    res.status(200).json({
        success: true,
        payload: {
          tempoEstimadoHoras: Number(tempoHoras.toFixed(2)),
          tempoFormatado: `${horas}h ${minutos}min`
        }
    });
};