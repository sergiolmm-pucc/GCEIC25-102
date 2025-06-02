// /calcularPiscina
exports.calcularPiscina = (req, res) => {
  const {
    largura,      
    comprimento,  
    profundidade, 
    custoAguaPorLitro = 0.005,        
    custoEletrica = 1500,             
    custoHidraulica = 1200,           
    manutencaoMensal = 200            
  } = req.body;

  
  if (!largura || !comprimento || !profundidade) {
    return res.status(400).json({
      success: false,
      message: "Parâmetros largura, comprimento e profundidade são obrigatórios",
    });
  }

  const volume = largura * comprimento * profundidade;
  const litros = volume * 1000; 

  const custoAgua = litros * custoAguaPorLitro;
  const custoTotal =
    custoAgua + custoEletrica + custoHidraulica + manutencaoMensal;

  res.json({
    success: true,
    volume_m3: volume.toFixed(2),
    litros: litros.toFixed(0),
    custoAgua: custoAgua.toFixed(2),
    custoEletrica: custoEletrica.toFixed(2),
    custoHidraulica: custoHidraulica.toFixed(2),
    manutencaoMensal: manutencaoMensal.toFixed(2),
    custoTotal: custoTotal.toFixed(2),
  });
};
