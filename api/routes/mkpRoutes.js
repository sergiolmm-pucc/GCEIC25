
const express = require('express');
const router = express.Router();
const mkpController = require('../controllers/mkpController');

router.post('/markup-simples', mkpController.calculoSimples);


module.exports = router;