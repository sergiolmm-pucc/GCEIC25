const express = require('express');
const router = express.Router();
const markupController = require('../controllers/mkp1Controller');

router.post('/markup-simples', markupController.calculoSimples);


module.exports = router;