const calculoSimples = (req, res) => {
  const { custo, lucro } = req.body;
  if (!custo || !lucro)
    return res
      .status(400)
      .json({ error: "Campos obrigatórios: custo e lucro" });
  const precoVenda = custo * (1 + lucro);
  res.json({ precoVenda: precoVenda.toFixed(2) });
};

const lucroObtido = (req, res) => {
  const { custo, precoVenda } = req.body;
  if (!custo || !precoVenda)
    return res
      .status(400)
      .json({ error: "Campos obrigatórios: custo e precoVenda" });
  const lucro = (precoVenda - custo) / custo;
  // eslint-disable-next-line no-irregular-whitespace
  res.json({ lucro: (lucro * 100).toFixed(2) + "%" });
};

const calculoDetalhado = (req, res) => {
  const { custo, lucro, despesas, impostos } = req.body;
  if ([custo, lucro, despesas, impostos].some((v) => v === undefined))
    return res
      .status(400)
      .json({ error: "Campos obrigatórios: custo, lucro, despesas, impostos" });

  const precoVenda = custo * (1 + despesas + impostos + lucro);
  res.json({ precoVenda: precoVenda.toFixed(2) });
};

const sugestaoPreco = (req, res) => {
  const { custo, concorrentes } = req.body;
  if (!custo || !Array.isArray(concorrentes) || concorrentes.length === 0)
    return res
      .status(400)
      .json({ error: "Campos obrigatórios: custo e lista de concorrentes" });

  const mediaConcorrentes =
    concorrentes.reduce((a, b) => a + b, 0) / concorrentes.length;
  const precoSugerido = (custo + mediaConcorrentes) / 2;

  res.json({ precoSugerido: precoSugerido.toFixed(2) });
};

const simulacao = (req, res) => {
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

module.exports = {
  calculoSimples,
  lucroObtido,
  calculoDetalhado,
  sugestaoPreco,
  simulacao,
};
