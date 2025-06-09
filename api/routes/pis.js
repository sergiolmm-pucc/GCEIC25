const express = require('express');
const router = express.Router();
const { calcularPIS } = require('../controllers/impostosController7');

router.post('/', calcularPIS);

module.exports = router;
