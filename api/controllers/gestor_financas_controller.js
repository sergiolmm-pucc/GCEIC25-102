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
