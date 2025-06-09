const express = require('express');
const router = express.Router();
const cpfValidatorController = require('../controllers/cpfValidatorController');

router.get('/validar/:cpf', cpfValidatorController.validate);

module.exports = router; 