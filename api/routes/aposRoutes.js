// Routes Grupo 09 - Cálculo de Aposentadoria

const express = require("express");
const router = express.Router();
const {
  calcularAposentadoria,
  calcularRegra,
  calcularPontuacao,
  calcularTempoAposentadoria,
  obterHistorico,
  registrarMiddleware,
} = require("../controllers/aposController");

// Registrar middleware para todas as rotas
router.use(registrarMiddleware);

router.post("/calculoAposentadoria", calcularAposentadoria); // Isabella Maria
router.post("/calculoRegra", calcularRegra); // Izabelle Oliveira
router.post("/calculoPontuacao", calcularPontuacao); // Emilly Bó
router.post("/calculoTempoAposentadoria", calcularTempoAposentadoria); // Guilherme Maia
router.get("/historico", obterHistorico); // Gabriel Cardoso

module.exports = router;
