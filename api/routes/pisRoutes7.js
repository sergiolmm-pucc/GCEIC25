const express = require('express');
const router = express.Router();

router.post('/', (req, res) => {
  console.log('Recebido cálculo de PIS:', req.body);

  const { valorProduto, percentualPIS } = req.body;

  if (typeof valorProduto !== 'number' || typeof percentualPIS !== 'number') {
    return res.status(400).json({ erro: 'Dados inválidos' });
  }

  const pis = valorProduto * (percentualPIS / 100);
  res.json({ pis: pis.toFixed(2) });
});

module.exports = router;
