const express = require('express');
const router = express.Router();
const { calcularICMS } = require('../controllers/impostosController7');

router.post('/', calcularICMS);

module.exports = router;
