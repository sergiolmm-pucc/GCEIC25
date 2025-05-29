const express = require('express');
const router = express.Router();

// Importa o controller
const loginController = require('../controllers/loginController');

router.post('/', loginController.login);

module.exports = router;