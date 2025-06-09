// Arthur Maluf 22005252
// Lucas Bertola 22005810
// Marcos Miotto 23004827
// Pedro Simões 23008779

const express = require('express');
const router = express.Router();

// Importa o controller
const calculationController = require('../controllers/solarPanelController');

// Define rotas usando as funções do controller
router.post('/calcular', calculationController.calcular);
router.post('/impacto-ambiental', calculationController.impactoAmbiental);
router.post('/orientacao', calculationController.orientacao);

// Rota para login
router.post('/login', calculationController.login);

module.exports = router;