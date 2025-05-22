const express = require('express');
const router = express.Router();

// Importa o controller
const userController = require('../controllers/baseController');

// Define rotas usando as funções do controller
router.get('/datetime', userController.datetime);
router.get('/data', userController.data);
router.post('/concat', userController.concat);


router.post('/salario-liquido', userController.salarioLiquido);
router.post('/inss', userController.inss);
/*
router.post('/fgts', userController.fgts);
router.post('/decimo', userController.decimo);
router.post('/ferias', userController.ferias);
router.post('/total-mensal', userController.totalMensal);
*/

module.exports = router;
