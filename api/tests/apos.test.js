// Teste Unitário Grupo 09 - Cálculo de Aposentadoria

const { calcularAposentadoria, calcularRegra } = require('../controllers/aposController');

function mockResponse() {
  const res = {};
  res.status = jest.fn().mockReturnValue(res);
  res.json = jest.fn().mockReturnValue(res);
  return res;
}

// Isabella Tressino
describe('Função calcularAposentadoria', () => {
  test('Mulher que já pode se aposentar', () => {
    const req = { body: { idade: 62, contribuicao: 15, sexo: 'F' } };
    const res = mockResponse();

    calcularAposentadoria(req, res);

    expect(res.json).toHaveBeenCalledWith({
      podeAposentar: true,
      mensagem: 'Você já pode se aposentar.'
    });
  });

  test('Homem que já pode se aposentar', () => {
    const req = { body: { idade: 65, contribuicao: 15, sexo: 'M' } };
    const res = mockResponse();

    calcularAposentadoria(req, res);

    expect(res.json).toHaveBeenCalledWith({
      podeAposentar: true,
      mensagem: 'Você já pode se aposentar.'
    });
  });

  test('Mulher que não pode se aposentar por idade', () => {
    const req = { body: { idade: 60, contribuicao: 15, sexo: 'F' } };
    const res = mockResponse();

    calcularAposentadoria(req, res);

    expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
      podeAposentar: false,
      mensagem: expect.stringContaining('2 ano(s) de idade'),
    }));
  });

  test('Homem que não pode se aposentar por contribuição', () => {
    const req = { body: { idade: 65, contribuicao: 10, sexo: 'M' } };
    const res = mockResponse();

    calcularAposentadoria(req, res);

    expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
      podeAposentar: false,
      mensagem: expect.stringContaining('5 ano(s) de contribuição'),
    }));
  });

  test('Mulher que não pode se aposentar por idade e contribuição', () => {
    const req = { body: { idade: 60, contribuicao: 10, sexo: 'F' } };
    const res = mockResponse();

    calcularAposentadoria(req, res);

    expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
      podeAposentar: false,
      mensagem: expect.stringContaining('2 ano(s) de idade'),
    }));
    expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
      mensagem: expect.stringContaining('5 ano(s) de contribuição'),
    }));
  });

  test('Idade negativa', () => {
    const req = { body: { idade: -1, contribuicao: 15, sexo: 'F' } };
    const res = mockResponse();

    calcularAposentadoria(req, res);

    expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
      podeAposentar: false,
      mensagem: expect.any(String),
    }));
  });

  test('Contribuição negativa', () => {
    const req = { body: { idade: 62, contribuicao: -5, sexo: 'M' } };
    const res = mockResponse();

    calcularAposentadoria(req, res);

    expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
      podeAposentar: false,
      mensagem: expect.any(String),
    }));
  });
});

// Izabelle Oliveira

// Emilly Ferro
describe('Função calcularPontuacao', () => {
  // Teste 1: Já pode aposentar pela pontuação (mulher)
  test('Mulher que já pode se aposentar por pontuação', () => {
    const req = { body: { idade: 60, contribuicao: 40, sexo: 'F' } }; // Pontuação: 100
    const res = mockResponse();

    calcularPontuacao(req, res);

    expect(res.json).toHaveBeenCalledWith({
      pontuacaoAtual: 100,
      anosRestantes: 0,
      mensagem: expect.stringContaining('já tem pontuação suficiente')
    });
  });

  // Teste 2: Já pode aposentar pela pontuação (homem)
  test('Homem que já pode se aposentar por pontuação', () => {
    const req = { body: { idade: 65, contribuicao: 40, sexo: 'M' } }; // Pontuação: 105
    const res = mockResponse();

    calcularPontuacao(req, res);

    expect(res.json).toHaveBeenCalledWith({
      pontuacaoAtual: 105,
      anosRestantes: 0,
      mensagem: expect.stringContaining('já tem pontuação suficiente')
    });
  });

  // Teste 3: Faltam anos para mulher (ex: 50+25 = 75, precisa de 100 -> faltam 25 pontos / 2 pontos/ano = 12.5 anos ~ 13 anos)
  // Re-calculando: 75 -> 77 (1 ano), 79 (2 anos), ..., 99 (12 anos), 101 (13 anos)
  test('Mulher que faltam anos para atingir a pontuação', () => {
    const req = { body: { idade: 50, contribuicao: 25, sexo: 'F' } }; // Pontuação: 75
    const res = mockResponse();

    calcularPontuacao(req, res);

    expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
      pontuacaoAtual: 75,
      anosRestantes: 13, // 75 -> 77, 79, 81, 83, 85, 87, 89, 91, 93, 95, 97, 99, 101 (13 anos)
      mensagem: expect.stringContaining('13 ano(s) de contribuição e idade para atingir a pontuação necessária (100).')
    }));
  });

  // Teste 4: Faltam anos para homem (ex: 55+30 = 85, precisa de 105 -> faltam 20 pontos / 2 pontos/ano = 10 anos)
  test('Homem que faltam anos para atingir a pontuação', () => {
    const req = { body: { idade: 55, contribuicao: 30, sexo: 'M' } }; // Pontuação: 85
    const res = mockResponse();

    calcularPontuacao(req, res);

    expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
      pontuacaoAtual: 85,
      anosRestantes: 10, // 85 -> 87, ..., 105 (10 anos)
      mensagem: expect.stringContaining('10 ano(s) de contribuição e idade para atingir a pontuação necessária (105).')
    }));
  });

  // Teste 5: Idade zero ou baixa, mas contribuição alta
  test('Homem com idade baixa mas alta contribuição, faltando poucos anos', () => {
    const req = { body: { idade: 30, contribuicao: 70, sexo: 'M' } }; // Pontuação: 100
    const res = mockResponse();

    calcularPontuacao(req, res);

    expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
      pontuacaoAtual: 100,
      anosRestantes: 3, // 100 -> 102 (1 ano), 104 (2 anos), 106 (3 anos)
      mensagem: expect.stringContaining('3 ano(s) de contribuição e idade para atingir a pontuação necessária (105).')
    }));
  });

  // Teste 6: Idade negativa deve retornar erro
  test('Idade negativa deve retornar erro', () => {
    const req = { body: { idade: -5, contribuicao: 20, sexo: 'F' } };
    const res = mockResponse();

    calcularPontuacao(req, res);

    expect(res.status).toHaveBeenCalledWith(400);
    expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
      erro: true,
      mensagem: expect.stringContaining('idade, contribuicao válidos e sexo')
    }));
  });

  // Teste 7: Contribuição negativa deve retornar erro
  test('Contribuição negativa deve retornar erro', () => {
    const req = { body: { idade: 50, contribuicao: -10, sexo: 'M' } };
    const res = mockResponse();

    calcularPontuacao(req, res);

    expect(res.status).toHaveBeenCalledWith(400);
    expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
      erro: true,
      mensagem: expect.stringContaining('idade, contribuicao válidos e sexo')
    }));
  });

  // Teste 8: Sexo inválido deve retornar erro
  test('Sexo inválido deve retornar erro', () => {
    const req = { body: { idade: 50, contribuicao: 20, sexo: 'Z' } };
    const res = mockResponse();

    calcularPontuacao(req, res);

    expect(res.status).toHaveBeenCalledWith(400);
    expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
      erro: true,
      mensagem: expect.stringContaining('idade, contribuicao válidos e sexo')
    }));
  });

  // Teste 9: Dados incompletos (idade faltando) deve retornar erro
  test('Dados incompletos (idade faltando) deve retornar erro', () => {
    const req = { body: { contribuicao: 20, sexo: 'F' } };
    const res = mockResponse();

    calcularPontuacao(req, res);

    expect(res.status).toHaveBeenCalledWith(400);
    expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
      erro: true,
      mensagem: 'Por favor, envie idade, contribuicao válidos e sexo ("M" ou "F").'
    }));
  });

  // Teste 10: Dados incompletos (contribuicao faltando) deve retornar erro
  test('Dados incompletos (contribuicao faltando) deve retornar erro', () => {
    const req = { body: { idade: 50, sexo: 'M' } };
    const res = mockResponse();

    calcularPontuacao(req, res);

    expect(res.status).toHaveBeenCalledWith(400);
    expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
      erro: true,
      mensagem: 'Por favor, envie idade, contribuicao válidos e sexo ("M" ou "F").'
    }));
  });

  // Teste 11: Pontuação exata (mulher)
  test('Mulher com pontuação exata no limite (100)', () => {
    const req = { body: { idade: 50, contribuicao: 50, sexo: 'F' } }; // Pontuação: 100
    const res = mockResponse();

    calcularPontuacao(req, res);

    expect(res.json).toHaveBeenCalledWith({
      pontuacaoAtual: 100,
      anosRestantes: 0,
      mensagem: expect.stringContaining('já tem pontuação suficiente')
    });
  });

  // Teste 12: Pontuação exata (homem)
  test('Homem com pontuação exata no limite (105)', () => {
    const req = { body: { idade: 55, contribuicao: 50, sexo: 'M' } }; // Pontuação: 105
    const res = mockResponse();

    calcularPontuacao(req, res);

    expect(res.json).toHaveBeenCalledWith({
      pontuacaoAtual: 105,
      anosRestantes: 0,
      mensagem: expect.stringContaining('já tem pontuação suficiente')
    });
  });
});

// Gabriel Cardoso

// Guilherme Maia
