function inssFaixa1(salario) { return salario * 0.075; }
function inssFaixa2(salario) { return salario * 0.09 - 22.77; }
function inssFaixa3(salario) { return salario * 0.12 - 106.59; }
function inssFaixa4(salario) { return salario * 0.14 - 190.40; }
function inssTeto() { return 8157.41 * 0.14 - 190.40; }

function calcularINSS(salario) {
  if (salario <= 1518) return inssFaixa1(salario);
  if (salario <= 2793.88) return inssFaixa2(salario);
  if (salario <= 4190.83) return inssFaixa3(salario);
  if (salario <= 8157.41) return inssFaixa4(salario);
  return inssTeto();
}

// Funções auxiliares IRPF
function irpfIsento(salarioBase) { return 0; }
function irpfFaixa1(salarioBase) { return salarioBase * 0.075 - 169.44 - 607.20; }
function irpfFaixa2(salarioBase) { return salarioBase * 0.15 - 381.44 - 607.20; }
function irpfFaixa3(salarioBase) { return salarioBase * 0.225 - 662.77 - 607.20; }
function irpfFaixa4(salarioBase) {
  const ir = salarioBase * 0.275 - 896.00 - 607.20;
  return ir < 0 ? 0 : ir;
}

function calcularIRPF(salarioBase) {
  if (salarioBase <= 2259.20) return irpfIsento(salarioBase);
  if (salarioBase <= 2826.65) return irpfFaixa1(salarioBase);
  if (salarioBase <= 3751.05) return irpfFaixa2(salarioBase);
  if (salarioBase <= 4664.68) return irpfFaixa3(salarioBase);
  return irpfFaixa4(salarioBase);
}
