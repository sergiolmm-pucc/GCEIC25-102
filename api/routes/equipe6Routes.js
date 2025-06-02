const express = require("express");
const router = express.Router();
const equipe6Controller = require("../controllers/equipe6Controller");

// Rota POST /equipe6
router.post("/", equipe6Controller.calcularSalario);

module.exports = router;
