function aplicarDesconto(valor, desconto) {
  if (desconto > valor) return 0;
  return valor - desconto;
}

function calculateCost({
  containers,
  container_size,
  finish_level,
  foundation_type,
  insulation,
  electricity,
  plumbing,
  solar_energy,
  windows,
  doors,
  custom_furniture,
  project_ready,
  distance = 0,
  rooms = 1,
}) {
  const baseCostPerContainer = { "40ft": 20000, "20ft": 13000 };
  const finishMultipliers = { basico: 1, intermediario: 3.5, luxo: 4 };
  const foundationCosts = { sapata: 5000, radier: 8000, pilotis: 10000 };
  const insulationCosts = { nenhum: 0, poliuretano: 4000, "lã de rocha": 5000 };

  let total = containers * (baseCostPerContainer[container_size] || 0);

  total *= finishMultipliers[finish_level] || 1;

  total += foundationCosts[foundation_type] || 5000;

  total += distance * 15;

  total += insulationCosts[insulation] || 0;

  if (electricity) total += 3000;
  if (plumbing) total += 3000;
  if (solar_energy) total += 12000;

  total += windows * 800;
  total += doors * 1000;

  if (custom_furniture) total += 8000;
  if (!project_ready) total += 4000;

  const costPerRoom = 4800;
  total += rooms * costPerRoom;

  return Math.round(total);
}

module.exports = { aplicarDesconto, calculateCost };
