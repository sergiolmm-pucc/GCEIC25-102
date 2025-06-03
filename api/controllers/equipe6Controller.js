exports.calcularSalario = (req, res) => {
  const salario = parseFloat(req.body.salario);

  if (!salario || isNaN(salario) || salario <= 0) {
    return res.status(400).json({ error: 'Salário inválido' });
  }
  
  let inss, fgts;
  if (salario <= 2824) {
    inss = 0;
    fgts = 0;
  } else {
    inss = salario * 0.08;
    fgts = salario * 0.08;
  }
  const salarioLiquido = salario - inss - fgts;

  const divisoes = {
    necessidades: (salarioLiquido * 0.4).toFixed(2),
    lazer: (salarioLiquido * 0.3).toFixed(2),
    poupanca: (salarioLiquido * 0.3).toFixed(2),
  };

  res.json({
    inss: inss.toFixed(2),
    fgts: fgts.toFixed(2),
    salarioLiquido: salarioLiquido.toFixed(2),
    sugestaoDivisao: divisoes
  });
};
exports.login = (req, res) => {
  const { username, password } = req.body;

  if (username === 'admin' && password === '12345') {
    return res.status(200).json({
      success: true,
      message: 'Login efetuado com sucesso!'
    });
  }

  return res.status(401).json({
    success: false,
    message: 'Usuário ou senha incorretos.'
  });
};