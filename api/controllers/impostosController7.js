exports.calcularIPI = (req, res) => {
  console.log('⚙️  Requisição IPI recebida');
  const { valorProduto, percentualIPI } = req.body;

  if (typeof valorProduto !== 'number' || typeof percentualIPI !== 'number') {
    return res.status(400).json({ erro: 'Dados inválidos' });
  }

  const ipi = valorProduto * (percentualIPI / 100);
  res.json({ ipi: ipi.toFixed(2) });
};

exports.calcularICMS = (req, res) => {
  console.log('⚙️  Requisição ICMS recebida');
  const { valorProduto, percentualICMS } = req.body;

  if (typeof valorProduto !== 'number' || typeof percentualICMS !== 'number') {
    return res.status(400).json({ erro: 'Dados inválidos' });
  }

  const icms = valorProduto * (percentualICMS / 100);
  res.json({ icms: icms.toFixed(2) });
};

exports.calcularPIS = (req, res) => {
  console.log('⚙️  Requisição PIS recebida');
  const { valorProduto, percentualPIS } = req.body;

  if (typeof valorProduto !== 'number' || typeof percentualPIS !== 'number') {
    return res.status(400).json({ erro: 'Dados inválidos' });
  }

  const pis = valorProduto * (percentualPIS / 100);
  res.json({ pis: pis.toFixed(2) });
};

exports.calcularCOFINS = (req, res) => {
  console.log('⚙️  Requisição COFINS recebida');
  const { valorProduto, percentualCOFINS } = req.body;

  if (typeof valorProduto !== 'number' || typeof percentualCOFINS !== 'number') {
    return res.status(400).json({ erro: 'Dados inválidos' });
  }

  const cofins = valorProduto * (percentualCOFINS / 100);
  res.json({ cofins: cofins.toFixed(2) });
};