const express = require('express');
const router = express.Router();

const loginController = require('../controllers/loginCalculadoraViagemController');
const calculoController = require('../controllers/calculoViagemEquipe5Controller');

router.post('/login', loginController.login);

router.post('/calcular', calculoController.calcular)

module.exports = router;