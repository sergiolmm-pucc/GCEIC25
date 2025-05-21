// ipiController.js

function calcularIPI(req, res) {
  const { valorProduto, aliquotaIPI } = req.body;

  if (valorProduto == null || aliquotaIPI == null) {
    return res.status(400).json({ erro: 'Informe valorProduto e aliquotaIPI' });
  }

  const ipi = (valorProduto * aliquotaIPI) / 100;
  return res.json({ imposto: ipi.toFixed(2) });
}

module.exports = { calcularIPI };
