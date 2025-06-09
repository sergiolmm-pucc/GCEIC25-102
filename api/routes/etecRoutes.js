const express = require('express');
const router = express.Router();
const { calcularEncargos } = require('../controllers/etecController');

router.post('/calcularequipe4', calcularEncargos);

module.exports = router;