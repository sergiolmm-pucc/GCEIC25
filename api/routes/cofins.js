const express = require('express');
const router = express.Router();

router.post('/', (req, res) => {
  console.log('Recebido cálculo de COFINS:', req.body);

  const { valorProduto, percentualCOFINS } = req.body;

  if (typeof valorProduto !== 'number' || typeof percentualCOFINS !== 'number') {
    return res.status(400).json({ erro: 'Dados inválidos' });
  }

  const cofins = valorProduto * (percentualCOFINS / 100);
  res.json({ cofins: cofins.toFixed(2) });
});

module.exports = router;
