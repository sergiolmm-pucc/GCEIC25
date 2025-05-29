const express = require('express');
const router = express.Router();
const piscinaController = require('../controllers/piscina3Controller');

router.post('/calcular', piscinaController.calcularCustos);
router.post('/login', piscinaController.realizarLogin);
router.post('/sobre', piscinaController.sobre)
router.post('/splash', piscinaController.splashScreen);
router.get('/ajuda', piscinaController.ajuda);

module.exports = router;
