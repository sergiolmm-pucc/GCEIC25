const express = require('express');
const router = express.Router();
const { calcularAposentadoria, calcularRegra } = require('../controllers/aposController');

router.post('/calculoAposentadoria', calcularAposentadoria);
router.post('/calculoRegra', calcularRegra);

module.exports = router;