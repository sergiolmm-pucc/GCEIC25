const express = require("express");
const router = express.Router();
const markupController = require("../controllers/mkp1Controller");

router.post("/markup-simples", markupController.calculoSimples);
router.post("/sugestao-preco", markupController.sugestaoPreco);
router.post("/markup-detalhado", markupController.calculoDetalhado);

router.post("/lucro-obtido", markupController.lucroObtido);

router.post("/simulacao", markupController.simulacao);

module.exports = router;
