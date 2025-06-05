const express = require('express');
const router = express.Router();
const piscinaController = require('../controllers/piscina3Controller');

router.post('/calcular', piscinaController.calcularCustos);
router.get('/ajuda', piscinaController.ajuda);
router.post('/calcularEletrica', piscinaController.calcularEletrica);
router.post('/calcularHidraulica', piscinaController.calcularHidraulica);
router.post('/calcularCustoTotal', piscinaController.calcularCustoTotalGeral);

module.exports = router;
