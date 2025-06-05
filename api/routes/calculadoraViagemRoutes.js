const express = require('express');
const router = express.Router();

const loginController = require('../controllers/loginCalculadoraViagemController');
const calculoController = require('../controllers/calculoViagemEquipe5Controller');

router.post('/consumo-estimado', calculoController.consumoEstimado);

router.post('/estimativa-tempo', calculoController.estimativaTempo);

router.post('/login', loginController.login);

router.post('/calcular', calculoController.calcular)

module.exports = router;

