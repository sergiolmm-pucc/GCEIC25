const express = require('express');
const router = express.Router();

// Importa o controller
const markupController = require('../controllers/markupController');

router.post('/markup', markupController.markupMultiplicador);

module.exports = router;