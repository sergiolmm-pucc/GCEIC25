
const express = require('express');
const router = express.Router();
const mkpController = require('../controllers/mkpController');

router.post('/markup-simples', mkpController.calculoSimples);

//Rota do lucro obtido
router.post('/lucro-obtido', markupController.lucroObtido);

module.exports = router;