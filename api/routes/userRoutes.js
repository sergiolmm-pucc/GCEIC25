const express = require('express');
const router = express.Router();

// Importa o controller
const userController = require('../controllers/userController');

// Define rotas usando as funções do controller
router.get('/', userController.listUsers);
router.get('/:id', userController.getUserById);
router.post('/', userController.createUser);

module.exports = router;
