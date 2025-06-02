const express = require("express");
const router = express.Router();
const equipe6Controller = require("../controllers/equipe6Controller");

router.post("/", equipe6Controller.calcularSalario);
router.post("/login", equipe6Controller.login);

module.exports = router;
