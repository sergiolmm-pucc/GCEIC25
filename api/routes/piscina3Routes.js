const express = require('express');
const router = express.Router();
const piscinaController = require('../controllers/piscina3Controller');

router.post('/calcular', piscinaController.calcularCustos);

module.exports = router;
