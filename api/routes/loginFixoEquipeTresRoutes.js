const express = require('express');
const router = express.Router();

const loginController = require('../controllers/loginFixoEquipeTresController');

router.post('/loginFixoEquipeTres', loginController.loginFixoEquipeTres);

module.exports = router;