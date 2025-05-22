const express = require('express');
const router = express.Router();
const { calcularAposentadoria } = require('../controllers/aposController');

router.post('/calculoAposentadoria', calcularAposentadoria);

module.exports = router;