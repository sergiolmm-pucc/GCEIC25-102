const express = require("express");
const router = express.Router();
const {
  calcularFinancas,
} = require("../controllers/gestor_financas_controller");

router.post("/calcular-financas", calcularFinancas);

module.exports = router;
