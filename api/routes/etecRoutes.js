const express = require('express');
const router = express.Router();
const { calcularEncargos } = require('../controllers/etecController');

router.post('/calcular', calcularEncargos);

module.exports = router;
