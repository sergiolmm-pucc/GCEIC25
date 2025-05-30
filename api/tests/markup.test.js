const { markupMultiplicador } = require('../controllers/markupController');

describe('markupMultiplicador', () => {
  let req, res;

  beforeEach(() => {
    req = { body: {} };
    res = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn(),
    };
  });

  it('deve retornar erro 400 se faltar campo obrigatório', () => {
    markupMultiplicador(req, res);
    expect(res.status).toHaveBeenCalledWith(400);
    expect(res.json).toHaveBeenCalledWith({
      error: 'Campos obrigatórios: custo, despesasVariaveis, despesasFixas, margemLucro'
    });
  });

  it('deve retornar erro 400 se soma de percentuais ≥ 100%', () => {
    req.body = { custo: 50, despesasVariaveis: 50, despesasFixas: 30, margemLucro: 20 };
    markupMultiplicador(req, res);
    expect(res.status).toHaveBeenCalledWith(400);
    expect(res.json).toHaveBeenCalledWith({
      error: 'A soma de despesas e margem de lucro não pode ser igual ou maior que 100%'
    });
  });

  it('calcula corretamente markup e preço de venda', () => {
    req.body = { custo: 100, despesasVariaveis: 10, despesasFixas: 15, margemLucro: 20 };
    markupMultiplicador(req, res);
    expect(res.json).toHaveBeenCalledWith({
      markup: '1.8182',
      precoVenda: '181.82',
    });
  });

  it('markup = 1 e precoVenda = custo quando percentuais = 0', () => {
    req.body = { custo: 200, despesasVariaveis: 0, despesasFixas: 0, margemLucro: 0 };
    markupMultiplicador(req, res);
    expect(res.json).toHaveBeenCalledWith({
      markup: '1.0000',
      precoVenda: '200.00',
    });
  });
});