const { calculateCost } = require("./funcoes_base");

// GET /datetime
exports.datetime = (req, res) => {
  const now = new Date();
  res.json({
    datetime: now.toISOString(),
  });
};

// GET /datetime
exports.data = (req, res) => {
  const now = new Date();
  res.json({
    datetime: now.toISOString(),
  });
};

// POST /concat
exports.concat = (req, res) => {
  const { value } = req.body;
  if (!value) {
    return res
      .status(400)
      .json({ success: false, message: "Valor não fornecido" });
  }
  const result = `${value} - Esta é uma frase fixa.`;
  res.json({
    success: true,
    result: result,
  });
};

exports.calcularCustoCasaContainer = (req, res) => {
  try {
    const {
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
      distance,
      rooms,
    } = req.body;

    const input = {
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
      distance,
      rooms,
    };

    const custoTotal = calculateCost(input);
    res.json({ custoTotal });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};
