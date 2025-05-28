// Routes Grupo 09 - Cálculo de Aposentadoria

const express = require('express');
const router = express.Router();
const { calcularAposentadoria, calcularRegra, calcularPontuacao} = require('../controllers/aposController');

router.post('/calculoAposentadoria', calcularAposentadoria); // Isabella Maria
router.post('/calculoRegra', calcularRegra); // Izabelle Oliveira
router.post('/calculoPontuacao', calcularPontuacao); // Emilly Bó 
// router.post(); // Gabriel Cardoso
// router.post(); // Guilherme Maia

module.exports = router;