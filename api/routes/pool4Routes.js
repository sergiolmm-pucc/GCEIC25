const express = require('express');
const router = express.Router();

// Importa o controller
const pool4 = require('../controllers/pool4Controller');

// Define rotas usando as funções do controller
router.post('/calcular-volume', pool4.calcularVolume);
router.post('/eletrico', pool4.calcularMaterialEletrico);
router.post('/hidraulico', pool4.calcularMaterialHidraulico);
router.post('/agua', pool4.calcularCustoDAgua);
router.post('/manutencao', pool4.calcularManutencaoMensal);
router.post('/mob', pool4.calcularMob);
router.post('/login', pool4.login);

module.exports = router;