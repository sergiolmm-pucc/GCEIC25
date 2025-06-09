const express = require('express');
const router = express.Router();

router.post('/', (req, res) => {
  console.log('Recebido cálculo de IPI:', req.body);

  const { valorProduto, percentualIPI } = req.body;

  if (typeof valorProduto !== 'number' || typeof percentualIPI !== 'number') {
    return res.status(400).json({ erro: 'Dados inválidos' });
  }

  const ipi = valorProduto * (percentualIPI / 100);
  res.json({ ipi: ipi.toFixed(2) });
});

module.exports = router;
