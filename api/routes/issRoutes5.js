const express = require('express');
const router = express.Router();
const { calcularISS } = require('../controllers/impostosController5');

router.post('/iss', calcularISS);

module.exports = router; 