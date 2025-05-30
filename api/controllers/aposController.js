// Controller Grupo 09 - Cálculo de Aposentadoria

// Isabella Tressino
function calcularAposentadoria(req, res) {
  const { idade, contribuicao, sexo } = req.body;

  if (idade == null || contribuicao == null || !sexo) {
    return res.status(400).json({ erro: "Dados incompletos" });
  }

  const idadeMinima = sexo === "F" ? 62 : 65;
  const contribuicaoMinima = 15;

  if (idade >= idadeMinima && contribuicao >= contribuicaoMinima) {
    return res.json({
      podeAposentar: true,
      mensagem: "Você já pode se aposentar.",
    });
  } else {
    const faltaIdade = Math.max(idadeMinima - idade, 0);
    const faltaContribuicao = Math.max(contribuicaoMinima - contribuicao, 0);

    const mensagens = [];

    if (faltaIdade > 0) {
      mensagens.push(`${faltaIdade} ano(s) de idade`);
    }

    if (faltaContribuicao > 0) {
      mensagens.push(`${faltaContribuicao} ano(s) de contribuição`);
    }

    return res.json({
      podeAposentar: false,
      mensagem: `Você ainda não pode se aposentar. Faltam ${mensagens.join(
        " e "
      )}.`,
    });
  }
}

// Izabelle Oliveira
function calcularRegra(req, res) {
  const { sexo, idade, tempoContribuicao, categoria } = req.body;

  if (!sexo || idade == null || tempoContribuicao == null || !categoria) {
    return res.status(400).json({ erro: "Dados incompletos" });
  }

  const regrasAplicaveis = [];

  const pontuacao = idade + tempoContribuicao;
  if (
    (sexo === "masculino" && pontuacao >= 105) ||
    (sexo === "feminino" && pontuacao >= 100)
  ) {
    regrasAplicaveis.push("Pontuação Progressiva");
  }

  if (
    (sexo === "masculino" && tempoContribuicao >= 35) ||
    (sexo === "feminino" && tempoContribuicao >= 30)
  ) {
    regrasAplicaveis.push("Tempo mínimo de contribuição");
  }

  if (categoria === "professor") {
    regrasAplicaveis.push("Regra Especial para Professores");
  }

  if (categoria === "deficiencia") {
    regrasAplicaveis.push("Regra Especial para Pessoas com Deficiência");
  }

  if (
    (sexo === "masculino" && idade >= 65) ||
    (sexo === "feminino" && idade >= 62)
  ) {
    regrasAplicaveis.push("Idade mínima para aposentadoria");
  }

  if (categoria === "rural") {
    if (tempoContribuicao >= 15) {
      regrasAplicaveis.push(
        "Aposentadoria Rural: tempo mínimo de contribuição reduzido"
      );
    }
    if (
      (sexo === "masculino" && idade >= 60) ||
      (sexo === "feminino" && idade >= 55)
    ) {
      regrasAplicaveis.push("Aposentadoria Rural: idade mínima reduzida");
    }
  }

  if (categoria === "programada") {
    if (idade >= 65) {
      regrasAplicaveis.push(
        "Aposentadoria Programada: idade mínima de 65 anos"
      );
    }
  }

  if (categoria === "incapacidade") {
    if (tempoContribuicao >= 12) {
      regrasAplicaveis.push(
        "Aposentadoria por Incapacidade: tempo mínimo reduzido"
      );
    }
    regrasAplicaveis.push("Aposentadoria por Incapacidade: sem idade mínima");
  }

  return res.json({ regras: regrasAplicaveis });
}

// Emilly Ferro
function calcularPontuacao(req, res) {
  let { idade, contribuicao, sexo } = req.body;

  // Validação de entrada
  if (
    idade == null ||
    typeof idade !== "number" ||
    idade < 0 ||
    contribuicao == null ||
    typeof contribuicao !== "number" ||
    contribuicao < 0 ||
    !sexo ||
    (sexo !== "F" && sexo !== "M")
  ) {
    return res.status(400).json({
      erro: true,
      mensagem:
        'Por favor, envie idade, contribuicao válidos e sexo ("M" ou "F").',
    });
  }

  const pontuacaoAlvoHomem = 105;
  const pontuacaoAlvoMulher = 100;
  const pontuacaoAlvo = sexo === "F" ? pontuacaoAlvoMulher : pontuacaoAlvoHomem;

  const pontuacaoAtual = idade + contribuicao;

  if (pontuacaoAtual >= pontuacaoAlvo) {
    return res.json({
      pontuacaoAtual: pontuacaoAtual,
      anosRestantes: 0,
      mensagem: `Parabéns! Você já tem pontuação suficiente (${pontuacaoAtual}) para se aposentar pela regra de pontos.`,
    });
  } else {
    let anosRestantes = 0;
    let tempIdade = idade;
    let tempContribuicao = contribuicao;
    let tempPontuacao = pontuacaoAtual;

    // A cada ano que passa, a idade aumenta em 1 e a contribuição aumenta em 1.
    // Isso adiciona 2 pontos por ano na pontuação total.
    while (tempPontuacao < pontuacaoAlvo) {
      anosRestantes++;
      tempIdade++;
      tempContribuicao++;
      tempPontuacao = tempIdade + tempContribuicao; // Recalcula a pontuação
    }

    return res.json({
      pontuacaoAtual: pontuacaoAtual,
      anosRestantes: anosRestantes,
      mensagem: `Faltam aproximadamente ${anosRestantes} ano(s) de contribuição e idade para atingir a pontuação necessária (${pontuacaoAlvo}).`,
    });
  }
}

// Gabriel Cardoso
let historicoOperacoes = [];

function limparHistorico() {
  historicoOperacoes.length = 0;
}

function registrarOperacao(operacao) {
  const timestamp = new Date().toISOString();
  historicoOperacoes.push({
    ...operacao,
    timestamp,
  });

  // Manter apenas as últimas 100 operações para evitar consumo excessivo de memória
  if (historicoOperacoes.length > 100) {
    historicoOperacoes = historicoOperacoes.slice(-100);
  }
}

// Middleware para registrar operações
function registrarMiddleware(req, res, next) {
  const oldJson = res.json;
  res.json = function (data) {
    // Não registrar operações da própria rota de histórico
    if (req.path !== "/historico") {
      registrarOperacao({
        tipo: req.path,
        dados: req.body,
        resultado: data,
      });
    }
    return oldJson.apply(res, arguments);
  };
  next();
}

function obterHistorico(req, res) {
  const { tipo } = req.query;
  let historicoFiltrado = historicoOperacoes;

  if (tipo) {
    historicoFiltrado = historicoFiltrado.filter((op) => op.tipo === tipo);
  }

  historicoFiltrado = historicoFiltrado
    .slice()
    .sort((a, b) => new Date(b.timestamp) - new Date(a.timestamp));

  res.status(200).json({ historico: historicoFiltrado });
}

// Guilherme Maia - Cálculo do Tempo para Aposentadoria
function calcularTempoAposentadoria(req, res) {
  const { idade, contribuicao, sexo } = req.body;

  if (idade == null || contribuicao == null || !sexo) {
    return res.status(400).json({ erro: "Dados incompletos" });
  }

  const idadeMinima = sexo === "F" ? 62 : 65;
  const contribuicaoMinima = 15;

  const anosParaIdadeMinima = Math.max(idadeMinima - idade, 0);
  const anosParaContribuicaoMinima = Math.max(
    contribuicaoMinima - contribuicao,
    0
  );

  const anosNecessarios = Math.max(
    anosParaIdadeMinima,
    anosParaContribuicaoMinima
  );
  const anoAtual = new Date().getFullYear();
  const anoAposentadoria = anoAtual + anosNecessarios;

  let resposta = {
    anosPrevistosParaAposentar: anosNecessarios,
    anoPrevisoAposentadoria: anoAposentadoria,
    detalhes: {
      idadeAtual: idade,
      idadeNaAposentadoria: idade + anosNecessarios,
      contribuicaoAtual: contribuicao,
      contribuicaoNaAposentadoria: contribuicao + anosNecessarios,
    },
  };

  if (anosNecessarios === 0) {
    resposta.mensagem = "Você já pode se aposentar!";
  } else {
    const requisitos = [];
    if (anosParaIdadeMinima > 0) {
      requisitos.push(
        `${anosParaIdadeMinima} anos para atingir a idade mínima`
      );
    }
    if (anosParaContribuicaoMinima > 0) {
      requisitos.push(
        `${anosParaContribuicaoMinima} anos para atingir o tempo mínimo de contribuição`
      );
    }
    resposta.mensagem = `Faltam ${anosNecessarios} anos para sua aposentadoria. Requisitos pendentes: ${requisitos.join(
      " e "
    )}.`;
  }

  return res.json(resposta);
}

module.exports = {
  calcularAposentadoria,
  calcularRegra,
  calcularPontuacao,
  calcularTempoAposentadoria,
  registrarMiddleware,
  obterHistorico,
  limparHistorico,
  historicoOperacoes,
};
