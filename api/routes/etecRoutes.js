const express = require("express");
const router = express.Router();

// Importa o controller
const etecController = require("../controllers/etecController");

// Define rotas usando as funções do controller
router.post("/calcularCustoMensal", etecController.calcularCustoMensal);
router.post("/calcularFerias", etecController.calcularFerias);
router.post("/calcularDecimoTerceiro", etecController.calcularDecimoTerceiro);
router.post("/calcularESocial", etecController.calcularESocial);
router.post("/calcularRescisao", etecController.calcularRecisao);

module.exports = router;
