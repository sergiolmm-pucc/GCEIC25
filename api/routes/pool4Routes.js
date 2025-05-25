const express = require('express');
const router = express.Router();

// Importa o controller
const pool4 = require('../controllers/pool4Controller');

// Define rotas usando as funções do controller
router.get('/calcular-volume', pool4.calcularVolume);
router.get('/eletrico', pool4.calcularMaterialEletrico);
router.get('/hidraulico', pool4.calcularMaterialHidraulico);
router.get('/agua', pool4.calcularCustoDAgua);
router.get('/manutencao', pool4.calcularManutencaoMensal);
router.get('/mob', pool4.calcularMob);

module.exports = router;