exports.calculoSimples = (req, res) => {
    const { custo, lucro } = req.body;
    if (!custo || !lucro) return res.status(400).json({ error: 'Campos obrigatórios: custo e lucro' });
    const precoVenda = custo * (1 + lucro);
    res.json({ precoVenda: precoVenda.toFixed(2) });
  };

exports.lucroObtido = (req, res) => {
    const { custo, precoVenda } = req.body;
    if (!custo || !precoVenda) return res.status(400).json({ error: 'Campos obrigatórios: custo e precoVenda' });
    const lucro = (precoVenda - custo) / custo;
    res.json({ lucro: (lucro * 100).toFixed(2) + '%' });
};