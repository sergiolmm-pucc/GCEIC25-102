const { calcularEncargosETEC } = require('../services/etecService');

exports.calcularEncargos = (req, res) => {
  const { salario } = req.body;
  if (!salario || salario <= 0) {
    return res.status(400).json({ erro: 'Salário inválido.' });
  }
  const resultado = calcularEncargosETEC(salario);
  res.json(resultado);
};
