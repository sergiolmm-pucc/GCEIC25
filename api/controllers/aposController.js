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

module.exports = { calcularAposentadoria };
