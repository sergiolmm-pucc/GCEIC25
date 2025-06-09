const cpfValidatorController = require('../controllers/cpfValidatorController');

describe('cpfValidatorController.validate', () => {
  let req, res;

  beforeEach(() => {
    req = { params: {} };
    res = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn(),
    };
  });

  it('deve retornar erro 400 se não enviar CPF', () => {
    cpfValidatorController.validate(req, res);
    expect(res.status).toHaveBeenCalledWith(400);
    expect(res.json).toHaveBeenCalledWith({
      success: false,
      mensagem: 'CPF não fornecido'
    });
  });

  it('deve retornar sucesso para CPF válido', () => {
    req.params = { cpf: '52998224725' }; // CPF válido
    cpfValidatorController.validate(req, res);
    expect(res.json).toHaveBeenCalledWith({
      success: true,
      mensagem: 'CPF válido.'
    });
  });

  it('deve retornar erro para CPF inválido', () => {
    req.params = { cpf: '12345678900' }; // CPF inválido
    cpfValidatorController.validate(req, res);
    expect(res.json).toHaveBeenCalledWith({
      success: false,
      mensagem: 'CPF inválido.'
    });
  });
}); 