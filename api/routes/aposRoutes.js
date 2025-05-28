// Routes Grupo 09 - Cálculo de Aposentadoria

const express = require('express');
const router = express.Router();
const { calcularAposentadoria, calcularRegra, calcularPontuacao, calcularTempoAposentadoria} = require('../controllers/aposController');

router.post('/calculoAposentadoria', calcularAposentadoria); // Isabella Maria
router.post('/calculoRegra', calcularRegra); // Izabelle Oliveira
router.post('/calculoPontuacao', calcularPontuacao); // Emilly Bó 
// router.post(); // Gabriel Cardoso
router.post('/calculoTempoAposentadoria', calcularTempoAposentadoria) // Guilherme Maia

module.exports = router;