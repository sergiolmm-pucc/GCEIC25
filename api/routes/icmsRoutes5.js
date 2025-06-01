const express = require('express');
const router = express.Router();
const { calcularICMS } = require('../controllers/impostosController5');

router.post('/icms', calcularICMS);

module.exports = router; 