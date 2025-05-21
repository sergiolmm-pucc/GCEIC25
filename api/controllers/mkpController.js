// 1. Cálculo simples de markup
exports.calculoSimples = (req, res) => {
    const { custo, lucro } = req.body;
    if (!custo || !lucro) return res.status(400).json({ error: 'Campos obrigatórios: custo e lucro' });
    const precoVenda = custo * (1 + lucro);
    res.json({ precoVenda: precoVenda.toFixed(2) });
  };