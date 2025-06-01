const express = require("express");
const router = express.Router();
const piscinaController = require("../controllers/calculoPiscinaController");

router.post("/", piscinaController.calcularPiscina);

module.exports = router;