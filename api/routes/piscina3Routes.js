const express = require('express');
const router = express.Router();
const piscinaController = require('../controllers/piscina3Controller');

router.post('/calcular', piscinaController.calcularCustos);
router.post('/login', piscinaController.realizarLogin);

module.exports = router;
