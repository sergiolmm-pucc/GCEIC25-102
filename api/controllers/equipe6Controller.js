exports.calcularSalario = (req, res) => {
  const salario = parseFloat(req.body.salario);

  if (!salario || isNaN(salario)) {
    return res.status(400).json({ error: 'Salário inválido' });
  }

  const inss = salario * 0.08;
  const fgts = salario * 0.08;
  const salarioLiquido = salario - inss;

  res.json({
    inss: inss.toFixed(2),
    fgts: fgts.toFixed(2),
    salarioLiquido: salarioLiquido.toFixed(2),
  });
};
