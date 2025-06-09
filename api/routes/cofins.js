const express = require('express');
const router = express.Router();
const { calcularCOFINS } = require('../controllers/impostosController7');

router.post('/', calcularCOFINS);

module.exports = router;
