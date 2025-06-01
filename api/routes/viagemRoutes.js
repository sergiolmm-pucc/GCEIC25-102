// PROJETO SERGIO NODE/api/routes/viagemRoutes.js
const express = require('express');
const router = express.Router();
const viagemController = require('../controllers/viagemController');

// Endpoint para calcular o custo da viagem da sua equipe
// O prefixo 'viagens2/' será adicionado no server.js
router.post('/calcular', viagemController.calcularCustoViagem);

module.exports = router;