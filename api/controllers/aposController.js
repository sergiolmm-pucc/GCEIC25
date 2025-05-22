// Controller Grupo 09 - Cálculo de Aposentadoria

// Isabella Tressino
function calcularAposentadoria(req, res) {
  const { idade, contribuicao, sexo } = req.body;

  if (idade == null || contribuicao == null || !sexo) {
    return res.status(400).json({ erro: 'Dados incompletos' });
  }

  const idadeMinima = sexo === 'F' ? 62 : 65;
  const contribuicaoMinima = 15;

  if (idade >= idadeMinima && contribuicao >= contribuicaoMinima) {
    return res.json({
      podeAposentar: true,
      mensagem: "Você já pode se aposentar."
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
      mensagem: `Você ainda não pode se aposentar. Faltam ${mensagens.join(' e ')}.`
    });
  }
}

// Izabelle Oliveira
function calcularRegra(req, res) {
  const { sexo, idade, tempoContribuicao, categoria } = req.body;

  if (!sexo || idade == null || tempoContribuicao == null || !categoria) {
    return res.status(400).json({ erro: 'Dados incompletos' });
  }

  const regrasAplicaveis = [];

  const pontuacao = idade + tempoContribuicao;
  if ((sexo === 'masculino' && pontuacao >= 105) || (sexo === 'feminino' && pontuacao >= 100)) {
    regrasAplicaveis.push('Pontuação Progressiva');
  }

  if ((sexo === 'masculino' && tempoContribuicao >= 35) || (sexo === 'feminino' && tempoContribuicao >= 30)) {
    regrasAplicaveis.push('Tempo mínimo de contribuição');
  }

  if (categoria === 'professor') {
    regrasAplicaveis.push('Regra Especial para Professores');
  }

  if (categoria === 'deficiencia') {
    regrasAplicaveis.push('Regra Especial para Pessoas com Deficiência');
  }

  if ((sexo === 'masculino' && idade >= 65) || (sexo === 'feminino' && idade >= 62)) {
    regrasAplicaveis.push('Idade mínima para aposentadoria');
  }

  if (categoria === 'rural') {
    if (tempoContribuicao >= 15) {
      regrasAplicaveis.push('Aposentadoria Rural: tempo mínimo de contribuição reduzido');
    }
    if ((sexo === 'masculino' && idade >= 60) || (sexo === 'feminino' && idade >= 55)) {
      regrasAplicaveis.push('Aposentadoria Rural: idade mínima reduzida');
    }
  }

  if (categoria === 'programada') {
    if (idade >= 65) {
      regrasAplicaveis.push('Aposentadoria Programada: idade mínima de 65 anos');
    }
  }

  if (categoria === 'incapacidade') {
    if (tempoContribuicao >= 12) {
      regrasAplicaveis.push('Aposentadoria por Incapacidade: tempo mínimo reduzido');
    }
    regrasAplicaveis.push('Aposentadoria por Incapacidade: sem idade mínima');
  }

  return res.json({ regras: regrasAplicaveis });
}

// Emilly Ferro

// Gabriel Cardoso

// Guilherme Maia

module.exports = { calcularAposentadoria, calcularRegra };
