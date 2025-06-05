const calculoSimples = (req, res) => {
  const { custo, lucro } = req.body;
  if (!custo || !lucro)
    return res
      .status(400)
      .json({ error: "Campos obrigatórios: custo e lucro" });
  const precoVenda = custo * (1 + lucro / 100);
  res.json({ "Preço de Venda": precoVenda.toFixed(2) });
};

const lucroObtido = async (req, res) => {
  try {
    const { custo, precoVenda } = req.body;

    if (!custo || !precoVenda) {
      return res.status(400).json({
        error: 'Custo e preço de venda são obrigatórios'
      });
    }

    const lucro = precoVenda - custo;
    const margemLucro = (lucro / custo) * 100;

    return res.json({
      "Lucro Obtido": lucro.toFixed(2),
      "Margem de Lucro": `${margemLucro.toFixed(2)}%`,
      "Custo": custo.toFixed(2),
      "Preço de Venda": precoVenda.toFixed(2)
    });
  } catch (error) {
    console.error('Erro ao calcular lucro obtido:', error);
    return res.status(500).json({
      error: 'Erro ao calcular lucro obtido'
    });
  }
};

const calculoDetalhado = (req, res) => {
  const { custo, lucro, despesas, impostos } = req.body;
  if ([custo, lucro, despesas, impostos].some((v) => v === undefined))
    return res
      .status(400)
      .json({ error: "Campos obrigatórios: custo, lucro, despesas, impostos" });

  const precoVenda = custo * (1 + despesas/100 + impostos/100 + lucro/100);
  res.json({ "Preço de Venda": precoVenda.toFixed(2) });
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

  res.json({ "Preço Sugerido": precoSugerido.toFixed(2) });
};

const simulacao = (req, res) => {
  const { custo, despesas, impostos } = req.body;
  if ([custo, despesas, impostos].some((v) => v === undefined))
    return res
      .status(400)
      .json({ error: "Campos obrigatórios: custo, despesas, impostos" });

  const resultados = [];
  for (let lucro = 10; lucro <= 100; lucro += 10) {
    const precoVenda = custo * (1 + despesas/100 + impostos/100 + lucro/100);
    resultados.push({
      "Margem de Lucro": lucro + "%",
      "Preço de Venda": precoVenda.toFixed(2),
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
