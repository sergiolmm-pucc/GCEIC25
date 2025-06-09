const express = require('express');
const router = express.Router();
const { calcularIPI } = require('../controllers/impostosController7');

router.post('/', calcularIPI);

module.exports = router;
