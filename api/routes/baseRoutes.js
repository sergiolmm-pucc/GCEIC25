const express = require('express');
const router = express.Router();

// Importa o controller
const userController = require('../controllers/baseController');

// Define rotas usando as funções do controller
router.get('/datetime', userController.datetime);
router.get('/data', userController.data);
router.post('/concat', userController.concat);

module.exports = router;
