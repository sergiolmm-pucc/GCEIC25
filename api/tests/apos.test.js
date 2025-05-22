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

// Gabriel Cardoso

// Guilherme Maia
