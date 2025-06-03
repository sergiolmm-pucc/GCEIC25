const express = require('express');
const router = express.Router();
const piscinaController = require('../controllers/piscina3Controller');

router.post('/calcular', piscinaController.calcularCustos);
router.post('/sobre', piscinaController.sobre)
router.post('/splash', piscinaController.splashScreen);
router.get('/ajuda', piscinaController.ajuda);
router.post('/calcularEletrica', piscinaController.calcularEletrica);
router.post('/calcularHidraulica', piscinaController.calcularHidraulica);

module.exports = router;
