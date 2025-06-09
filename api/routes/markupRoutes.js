const express = require('express');
const router = express.Router();

// Importa o controller
const markupController = require('../controllers/markupController');

router.post('/', markupController.markupMultiplicador);

module.exports = router;