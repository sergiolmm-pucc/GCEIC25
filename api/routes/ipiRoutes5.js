const express = require('express');
const router = express.Router();
const { calcularIPI } = require('../controllers/impostosController5'); // ajuste o caminho conforme a estrutura do seu projeto

router.post('/ipi', calcularIPI);

module.exports = router;
 