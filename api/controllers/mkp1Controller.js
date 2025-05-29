exports.calculoSimples = (req, res) => {
    const { custo, lucro } = req.body;
    if (!custo || !lucro) return res.status(400).json({ error: 'Campos obrigatórios: custo e lucro' });
    const precoVenda = custo * (1 + lucro);
    res.json({ precoVenda: precoVenda.toFixed(2) });
  };

exports.calculoDetalhado = (req, res) => {
  const { custo, lucro, despesas, impostos } = req.body;
  if ([custo, lucro, despesas, impostos].some(v => v === undefined))
    return res.status(400).json({ error: 'Campos obrigatórios: custo, lucro, despesas, impostos' });

  const precoVenda = custo * (1 + despesas + impostos + lucro);
  res.json({ precoVenda: precoVenda.toFixed(2) });
};