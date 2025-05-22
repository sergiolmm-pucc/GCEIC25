// 1. Cálculo simples de markup
exports.calculoSimples = (req, res) => {
  const { custo, lucro } = req.body;
  if (!custo || !lucro)
    return res
      .status(400)
      .json({ error: "Campos obrigatórios: custo e lucro" });
  const precoVenda = custo * (1 + lucro);
  res.json({ precoVenda: precoVenda.toFixed(2) });
};

// Cálculo do lucro obtido
exports.lucroObtido = (req, res) => {
  const { custo, precoVenda } = req.body;
  if (!custo || !precoVenda)
    return res
      .status(400)
      .json({ error: "Campos obrigatórios: custo e precoVenda" });
  const lucro = (precoVenda - custo) / custo;
  res.json({ lucro: (lucro * 100).toFixed(2) + "%" });
};

exports.simulacao = (req, res) => {
  const { custo, despesas, impostos } = req.body;
  if ([custo, despesas, impostos].some((v) => v === undefined))
    return res
      .status(400)
      .json({ error: "Campos obrigatórios: custo, despesas, impostos" });

  const resultados = [];
  for (let lucro = 0.1; lucro <= 1; lucro += 0.1) {
    const precoVenda = custo * (1 + despesas + impostos + lucro);
    resultados.push({
      lucro: (lucro * 100).toFixed(0) + "%",
      precoVenda: precoVenda.toFixed(2),
    });
  }
  res.json({ simulacoes: resultados });
};
