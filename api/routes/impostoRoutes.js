const express = require('express');
const router = express.Router();

// Importa o controller
const impostosController = require('../controllers/impostoController');

// Define rotas usando as funções do controller
router.get('/resumo-nota-fiscal', impostosController.getNotaFiscal);
router.get('/calculo-icms', impostosController.getICMS);
router.get('/calculo-ipi', impostosController.getValorIpiTotal);
router.post('/calcular-pis-cofins', impostosController.calcularPisCofins);

module.exports = router;