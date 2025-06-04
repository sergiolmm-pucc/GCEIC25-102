exports.calcularEncargosETEC = (salario) => {
  const inss = salario * 0.08;
  const fgts = salario * 0.08;
  const ferias = salario / 12;
  const decimoTerceiro = salario / 12;

  return {
    salario,
    inss,
    fgts,
    ferias,
    decimoTerceiro,
    totalEncargos: inss + fgts + ferias + decimoTerceiro
  };
};