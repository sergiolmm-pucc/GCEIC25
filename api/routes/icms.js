const express = require('express');
const router = express.Router();

router.post('/', (req, res) => {
  console.log('Recebido cálculo de ICMS:', req.body);

  const { valorProduto, percentualICMS } = req.body;

  if (typeof valorProduto !== 'number' || typeof percentualICMS !== 'number') {
    return res.status(400).json({ erro: 'Dados inválidos' });
  }

  const icms = valorProduto * (percentualICMS / 100);
  res.json({ icms: icms.toFixed(2) });
});

module.exports = router;
