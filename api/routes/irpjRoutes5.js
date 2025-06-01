const express = require('express');
const router = express.Router();
const { calcularIRPJ } = require('../controllers/impostosController5');

router.post('/irpj', calcularIRPJ);

module.exports = router; 