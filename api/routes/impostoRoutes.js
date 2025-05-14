const express = require('express');
const router = express.Router();

// Importa o controller
const impostosController = require('../controllers/impostoController');

// Define rotas usando as funções do controller
router.get('/resumo-nota-fiscal', impostosController.getNotaFiscal);

module.exports = router;
